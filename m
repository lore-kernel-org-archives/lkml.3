Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3KTT2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:28:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:18461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab3KTT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:28:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,738,1378882800"; 
   d="scan'208";a="431049287"
Message-ID: <528D0D61.1030902@linux.intel.com>
Date: Wed, 20 Nov 2013 11:28:33 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Peter Anvin <hpa@zytor.com>, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, fenghua.yu@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org> <CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
In-Reply-To: <CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 10:44 PM, Linus Torvalds wrote:
> So this doesn't do the 32-bit truncation in the error path of the
> generic string copy. Oversight?
> 
>        Linus

I looked at the code again, and it turns out to be false alarm.

We *do* do 32-bit truncation in every path, still:

> ENTRY(copy_user_generic_string)
> 	CFI_STARTPROC
> 	ASM_STAC
> 	cmpl $8,%edx
> 	jb 2f		/* less than 8 bytes, go to byte copy loop */

-> If we jump here, we will truncate at 2:

> 	ALIGN_DESTINATION
> 	movl %edx,%ecx

-> If we don't jb 2f we end up

> 	shrl $3,%ecx

32-bit truncation here...

> 	andl $7,%edx
> 1:	rep
> 	movsq
> 2:	movl %edx,%ecx

32-bit truncation here...

> 3:	rep
> 	movsb
> 	xorl %eax,%eax
> 	ASM_CLAC
> 	ret
> 
> 	.section .fixup,"ax"
> 11:	lea (%rdx,%rcx,8),%rcx
> 12:	movl %ecx,%edx		/* ecx is zerorest also */

-> Even if %rdx+%rcx*8 > 2^32 we end up truncating at 12: -- not that it
matters, since both arguments are prototyped as "unsigned" and therefore
the C compiler is supposed to guarantee the upper 32 bits are ignored.

So I think Fenghua's patch is fine as-is.

	-hpa

