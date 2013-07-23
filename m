Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3GWFBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:01:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10110 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3GWFBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:01:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 22 Jul 2013 22:00:30 -0700
Message-ID: <51EE0E2C.8090103@nvidia.com>
Date: Tue, 23 Jul 2013 14:01:32 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] decompressors: fix "no limit" output buffer length
References: <1374476169-32194-1-git-send-email-acourbot@nvidia.com> <1374516481.14712.3.camel@linaro1.home> <51EDE724.5020507@nvidia.com> <51EDF93B.1070101@wwwdotorg.org>
In-Reply-To: <51EDF93B.1070101@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 12:32 PM, Stephen Warren wrote:
> On 07/22/2013 07:15 PM, Alex Courbot wrote:
> ...
>> Although the patch seems ok to me in its current form, there are two
>> points for which I still have small doubts:
>>
>> 1) Whether size_t and pointers will have the same size on all platforms.
>
> ptrsize_t?
>

Do you mean ptrdiff_t? (I cannot find ptrsize_t anywhere in the kernel)

Looking further about the uses of size_t and ptrdiff_t, it seems like 
size_t is designed to store the maximum addressable member of an array, 
whereas ptrdiff_t is used to store a substraction of two pointers. In 
effect, they translate to the unsigned (size_t) and signed (ptrdiff_t) 
variants of the same type.

But since here we know that the result of the substraction will always 
be positive and potentially big (for devices with memory in the lower 
half of the address space) using size_t sounds safer to avoid overflows 
and sign-conversion issues (strm->avail_out, where the value of out_len 
eventually ends, is an unsigned int).

So point 1) at least seems to be handled correctly with size_t. Point 2) 
might still be of concern, but if your uncompressed kernel image ends up 
overflowing your addressable memory, I guess you have a bigger problem 
to start with. :)

Andrew, do you think you can merge this as-is? Sorry if you are not the 
right person to ask, but there is no clear maintainer for this part of 
the code and you appear to have handled the latest patches that affect 
the same file.

Thanks,
Alex.

