Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993Ab3IDGBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:01:13 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34126 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761925Ab3IDGBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:01:11 -0400
Message-ID: <5226CC9D.30904@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 11:31:01 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Subject: Re: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420> <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420> <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com> <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com> <521C36F4.8030607@linux.vnet.ibm.com> <A5ED84D3BB3A384992CBB9C77DEDA4D443E9E24D@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443E9E24D@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090405-5490-0000-0000-00000417650D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 September 2013 07:14 AM, Seiji Aguchi wrote:
> Aruna,
>
> Sorry for the late response.
>
>> Seiji,
>>
>> Could you let us know the efivars buffer size with which the pstore is
>> registered when
>> the failure occurred.
> I looked into the issue today.
>
> I added some debug message just before pstore_compress().
> As you can see below, the buffer size is a fixed value(1024).
> Therefore, the size doesn't seem to be related to the failure directly.
>
> Also, in the failure case, zlib_deflate() returns Z_OK and stream.avail_out is zero.
> So, I thought big_oops_buf_sz is too big in my environment.
> And then, I tuned  big_oops_buf_sz to (psinfo->bufsize * 100) / 53.
Seiji,

Thank you for the analysis.

The reason behind compression failure is the size of big_oops_buf which is too
big for efivars case. I will do some experiments with different kind of texts
for buffer size 1024 to check if 100/53 suits for all the cases.

>
> At the same time, while looking into this issue, I had two concerns about current cording.
>
> 1) In pstore_decompress(), why not use zlib_inflateInit2() instead of zlib_inflateInit()?
>       If you use zlib_deflateInit2()  for specifying window_bit at compressing time,
>       zlib_inflateInit2() seems to be appropriate for decompressing.
>       (Please see a comment about inflateInit2() in include/linux/zlib.h and source code of crypto/deflate.c)

Yes this can be changed to zlib_inflateInit2().

> 2) As looking at crypto/deflate.c, stream->workspace is kzalloced at the beginning of
>     compressing/decompressing time.
>      So, in pstore case,  stream.workspace must be initialized to 0 with memset() in pstore_compress()/decompress().

Hmm.. I don't think this is a issue. If you see fs/logfs/compr.c from which I 
derived the compression
algorithms for pstore as well, they have not initialized stream.workspace. Since 
the space will be overwritten
during the calculation, I dont think it will matter.

The above 2 things you have suggested are good to have. But the reason behind 
compression failure is
the big_oops_buf_sz which is too big for efivars.

> I did three things above, tuning big_oops_buf_sz, using zlib_inflateInit2() and initializing stream.workspace , in my environment.
> As a result, compressions/decmpressions of all entries succeeded with efivars driver.
>
> <snip>
> Panic#2 Part1
> <4>[   75.665020]  [<ffffffff811af59c>] SyS_write+0x4c/0xa0
> <4>[   75.665020]  [<ffffffff8168be82>] system_call_fastpath+0x16/0x1b
> <4>[   75.665020] Code: ef e8 ff f7 ff ff eb d8 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 55 c7 05 cc f3 c9 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 0f 1f 44 00 00 55 31 c0 c7 05 5e
> <1>[   75.665020] RIP  [<ffffffff813d3946>] sysrq_handle_crash+0x16/0x20
> <4>[   75.665020]  RSP <ffff88007852de80>
> <4>[   75.665020] CR2: 0000000000000000
> <4>[   75.665020] ---[ end trace 97bb4a1f8d3fe7b2 ]---
> <3>[   75.665020] pstore_dump hsize=13 len=2155 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=13 len=2246 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore: compression failed for Part 2 returned -5
> <3>[   75.665020] pstore: Capture uncompressed oops/panic report of Part 2
> <3>[   75.665020] pstore_dump hsize=13 len=2239 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=13 len=2231 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=13 len=2185 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore: compression failed for Part 5 returned -5
> <3>[   75.665020] pstore: Capture uncompressed oops/panic report of Part 5
> <3>[   75.665020] pstore_dump hsize=13 len=2234 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=13 len=2208 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=13 len=2218 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=13 len=2222 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore: compression failed for Part 9 returned -5
> <3>[   75.665020] pstore: Capture uncompressed oops/panic report of Part 9
> <3>[   75.665020] pstore_dump hsize=14 len=2256 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=14 len=2219 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <3>[   75.665020] pstore_dump hsize=14 len=2226 big_oops_buf_sz=2275 psinfo->bufsize=1024
> <0>[   75.665020] Kernel panic - not syncing: Fatal exception
> <3>[   75.665020] drm_kms_helper: panic occurred, switching back to text console
> <snip>
>
> Seiji
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

