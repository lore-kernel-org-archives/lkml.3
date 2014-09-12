Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaILNkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:40:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53398 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaILNkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:40:19 -0400
Message-ID: <5412F7AB.5040901@zytor.com>
Date: Fri, 12 Sep 2014 06:39:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120015030.4178@nanos> <5412230A.6090805@intel.com> <541223B1.5040705@zytor.com> <alpine.DEB.2.10.1409120133330.4178@nanos> <54127A16.4030701@zytor.com> <alpine.DEB.2.10.1409121238290.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121238290.4178@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 06:10 AM, Thomas Gleixner wrote:
>>
>> I'm not wedded to that concept, by the way, but using the generic parser had a
>> whole bunch of its own problems, including the fact that you're getting bytes
>> from user space.
> 
> Errm. The instruction decoder does not even know about user space.
> 
>       u8 buf[MAX_INSN_SIZE];
> 
>       memset(buf, 0, MAX_INSN_SIZE);
>       if (copy_from_user(buf, addr, MAX_INSN_SIZE))
>       	    return 0;
> 
>       insn_init(insn, buf, is_64bit(current));
> 
>       /* Process the entire instruction */
>       insn_get_length(insn);
> 
>       /* Decode the faulting address */
>       return mpx_get_addr(insn, regs);
> 
> I really can't see why that should not work. insn_get_length()
> retrieves exactly the information which is required to call
> mpx_get_addr().
> 
> Sure it might be a bit slower because the generic decoder does a bit
> more than the mpx private sauce, but this happens in the context of a
> bounds violation and it really does not matter at all whether SIGSEGV
> is delivered 5 microseconds later or not.
> 
> The only difference is the insn->limit handling in the MPX
> decoder. The existing decoder has a limit check of:
> 
> #define MAX_INSN_SIZE       16
> 
> and MPX private one makes that
> 
> #define MAX_MPX_INSN_SIZE   15
> 
> and limits it runtime further to:
> 
>     MAX_MPX_INSN_SIZE - bytes_not_copied_from_user_space;
> 
> This is beyond silly, really. If we cannot copy 16 bytes from user
> space, why bother in dealing with a partial copy at all.
> 

The correct limit is 15 bytes, not anything else, so this is a bug in
the existing decoder.  A sequence of bytes longer than 15 bytes will
#UD, regardless of being "otherwise valid".

Keep in mind the instruction may not be aligned, and you could fit an
instruction plus a jump and still overrun a page in 15 bytes.

> Aside of that the existing decoder handles the 32bit app on a 64bit
> kernel already correctly while the extra magic MPX decoder does
> not. It just adds some magically optimized and different copy of the
> existing decoder for exactly ZERO value.
> 
>> It might be worthwhile to compare the older patchset which did use the generic
>> parser to make sure that it actually made sense.
> 
> I can't find such a thing. The first version I found contains an even
> more convoluted private parser. Intelnal mail perhaps?

Yes, I suspect so.

	-hpa

