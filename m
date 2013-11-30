Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab3K3Qu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:50:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3K3Qu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:50:57 -0500
Date: Sat, 30 Nov 2013 17:51:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131130165122.GA24507@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for completely offtopic question, but while we are here...

On 11/30, Jiri Kosina wrote:
>
> We have moved from using stop_machine() to int3-based patching exactly
> because it's much more lightweight.

I don't really understans the barriers in poke_int3_handler() and
text_poke_bp(). To the point, I do not really understand why do we
actually need bp_patching_in_progress, but lets ignore this.

Lets look at the end of text_poke_bp(), it does

	on_each_cpu(do_sync_core, NULL, 1);

	bp_patching_in_progress = false;
	smp_wmb();

First of all, this smp_wmb() is not clear. But what I actually
can't understand is why it is safe to clear bp_patching_in_progress.

OK, on_each_cpu() should serialize us with do_int3(), but only if
poke_int3_handler() is called with irqs disabled.

However, do_int3() does preempt_conditional_sti() and this looks
as if it can be called with irqs enabled? If this is actually
possible then text_poke_bp() needs synchronize_sched() to avoid
the races with poke_int3_handler(), afaics.

OTOH, int3 is GATE_INTERRUPT, doesn't this mean that that do_int3()
can enable irqs unconditionally and on_each_cpu() also acts as a
synchronization barrier?

Oleg.

