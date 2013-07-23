Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3GWCPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:15:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11091 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3GWCPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:15:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 22 Jul 2013 19:13:59 -0700
Message-ID: <51EDE724.5020507@nvidia.com>
Date: Tue, 23 Jul 2013 11:15:00 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] decompressors: fix "no limit" output buffer length
References: <1374476169-32194-1-git-send-email-acourbot@nvidia.com> <1374516481.14712.3.camel@linaro1.home>
In-Reply-To: <1374516481.14712.3.camel@linaro1.home>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 03:08 AM, Jon Medhurst (Tixy) wrote:
> On Mon, 2013-07-22 at 15:56 +0900, Alexandre Courbot wrote:
>> When decompressing into memory, the output buffer length is set to some
>> arbitrarily high value (0x7fffffff) to indicate the output is,
>> virtually, unlimited in size.
>>
>> The problem with this is that some platforms have their physical memory
>> at high physical addresses (0x80000000 or more), and that the output
>> buffer address and its "unlimited" length cannot be added without
>> overflowing. An example of this can be found in inflate_fast():
>>
>> /* next_out is the output buffer address */
>> out = strm->next_out - OFF;
>> /* avail_out is the output buffer size. end will overflow if the output
>>   * address is >= 0x80000104 */
>> end = out + (strm->avail_out - 257);
>>
>> This has huge consequences on the performance of kernel decompression,
>> since the following exit condition of inflate_fast() will be always
>> true:
>>
>> } while (in < last && out < end);
>>
>> Indeed, "end" has overflowed and is now always lower than "out". As a
>> result, inflate_fast() will return after processing one single byte of
>> input data, and will thus need to be called an unreasonably high number
>> of times. This probably went unnoticed because kernel decompression is
>> fast enough even with this issue.
>>
>> Nonetheless, adjusting the output buffer length in such a way that the
>> above pointer arithmetic never overflows results in a kernel
>> decompression that is about 3 times faster on affected machines.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> This speeds up booting of my Versatile Express TC2 by 15 seconds when
> starting on the A7 cluster :-)
>
> Tested-by: Jon Medhurst <tixy@linaro.org>

Good to hear! Thanks for taking the time to test this.

Although the patch seems ok to me in its current form, there are two 
points for which I still have small doubts:

1) Whether size_t and pointers will have the same size on all platforms. 
It not we might end up with some funny behaviors. My limited research on 
the topic did not end up with evidence that their size may differ, but I 
don't have a definite case that they do neither.
2) Whether all platforms have their address space ending at (~0). I do 
not have a concrete example in mind, but can imagine, say, a platform 
which represents its addresses as 32-bit pointers but has a smaller 
physical bus. In this case the current calculation could cause overflows 
again.

If one (or both) of these points are to be concerned about, there may 
exist macros I am not aware of that better represent the actual limits 
of pointers in the kernel.

Thanks,
Alex.

>
>> ---
>>   lib/decompress_inflate.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
>> index 19ff89e..d619b28 100644
>> --- a/lib/decompress_inflate.c
>> +++ b/lib/decompress_inflate.c
>> @@ -48,7 +48,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
>>   		out_len = 0x8000; /* 32 K */
>>   		out_buf = malloc(out_len);
>>   	} else {
>> -		out_len = 0x7fffffff; /* no limit */
>> +		out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
>>   	}
>>   	if (!out_buf) {
>>   		error("Out of memory while allocating output buffer");
>
>

