Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3A0Pux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 10:50:53 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55224 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3A0Pus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 10:50:48 -0500
Date: Sun, 27 Jan 2013 16:50:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, mina86@mina86.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Jan Beulich <JBeulich@novell.com>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH]smp: Fix send func call IPI to empty cpu mask
Message-ID: <20130127155043.GA6214@gmail.com>
References: <20130126075357.GA3205@udknight>
 <CA+55aFyJ0tsvJeujyRwX=q5KPKjeejmvQOMTCJxDcaEmYprpvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyJ0tsvJeujyRwX=q5KPKjeejmvQOMTCJxDcaEmYprpvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jan 25, 2013 at 11:53 PM, Wang YanQing <udknight@gmail.com> wrote:
> > I get below warning every day with 3.7,
> > one or two times per day.
> >
> > [ 2235.186027] WARNING: at /mnt/sda7/kernel/linux/arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x2f/0xb8()
> > [ 2235.186030] Hardware name: Aspire 4741
> > [ 2235.186032] empty IPI mask
> > [ 2235.186079]  [<c1015cbc>] native_send_call_func_ipi+0x4f/0x57
> > [ 2235.186087]  [<c1053453>] smp_call_function_many+0x191/0x1a9
> > [ 2235.186097]  [<c101e074>] native_flush_tlb_others+0x21/0x24
> > [ 2235.186101]  [<c101e0da>] flush_tlb_page+0x63/0x89
> > [ 2235.186105]  [<c101d360>] ptep_set_access_flags+0x20/0x26
> > [ 2235.186111]  [<c108fadd>] do_wp_page+0x234/0x502
> > [ 2235.186121]  [<c1090825>] handle_pte_fault+0x50d/0x54c
> > [ 2235.186148]  [<c1090934>] handle_mm_fault+0xd0/0xe2
> > [ 2235.186153]  [<c12dd143>] __do_page_fault+0x411/0x42d
> > [ 2235.186166]  [<c12dd167>] do_page_fault+0x8/0xa
> > [ 2235.186170]  [<c12db31a>] error_code+0x5a/0x60
> >
> > This patch fix it.
> >
> > This patch also fix some system hang problem:
> > If the data->cpumask been cleared after pass
> >
> >         if (WARN_ONCE(!mask, "empty IPI mask"))
> >                 return;
> > then the problem 83d349f3 fix will happen again.
> 
> Hmm. We have very consciously tried to avoid the extra copy, although
> I'm not entirely sure why (it might possibly hurt on the MAXSMP
> configuration).
> 
> See for example commit 723aae25d5cd ("smp_call_function_many: handle
> concurrent clearing of mask") which fixed another version of this
> problem.
> 
> But I do agree that it looks like the copy is required, simply because
> - as you say - once we've done the "list_add_rcu()" to add it to the
> queue, we can have (another) IPI to the target CPU that can now see it
> and clear the mask.
> 
> So by the time we get to actually send the IPI, the mask might have
> been cleared by another IPI. So I do agree that your patch seems
> correct, but I really really want to run it by other people.
> 
> Guys? Original patch on lkml. The other possible fix might be 
> to take the &call_function.lock earlier in 
> generic_smp_call_function_interrupt(), so that we can never 
> clear the bit while somebody is adding entries to the list... 
> But I think it very much tries to avoid that on purpose right 
> now, with only the last CPU responding to that IPI taking the 
> lock.
> 
> So copying the IPI mask seems to be the reasonable approach. 
> Comments?

Agreed, looks correct to me as well - I've queued the fix up in 
tip:x86/urgent.

( I've added your Acked-by to the patch, please holler if you 
  disagree with how the final commit ended up looking like. )

Thanks,

	Ingo
