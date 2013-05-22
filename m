Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3EVPBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:01:46 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57810 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab3EVPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <519CBB30.3060200@redhat.com>
References: <5195ED8B.7060002@meduna.org>
	<1369183168.6828.168.camel@gandalf.local.home>
	<519CBB30.3060200@redhat.com>
Date: Wed, 22 May 2013 08:01:43 -0700
X-Google-Sender-Auth: TyfK3VQnxA744ZqCwaUNiPJ3UkM
Message-ID: <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
Subject: Re: [PATCH - sort of] x86: Livelock in handle_pte_fault
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 5:33 AM, Rik van Riel <riel@redhat.com> wrote:
>
> That sounds like maybe we DO want a TLB flush on spurious
> page faults, so we get rid of this problem.

Hmm. If it was just the Geode, I wouldn't be surprised. But with a Celeron too?

Anyway, worth testing..

> We can get flush_tlb_fix_spurious_fault to do a local TLB
> invalidate of just the address in question by removing the
> x86-specific dummy version, falling back to the asm-generic
> version that does something.
>
> Can you test the attached patch?

I think you should also remove the

        if (flags & FAULT_FLAG_WRITE)

test in handle_pte_fault(). Because if it's spurious, it might happen
on reads too, I think.

RT people - does RT do anything special with the page tables?

Stanislav, the patch you sent out may well work, but it's damned odd.
On UP, we don't do the leave_mm() optimization that makes that code
necessary. So I agree with Rik that it's more likely somewhere else
(and infinite page faults do imply the TLB not getting flushed by the
page fault exception), and your patch might just be working around it
by simply flushing the TLB at least when switching between threads,
which still happens.

                   Linus
