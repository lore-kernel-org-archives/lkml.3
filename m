Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaA1Lzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:55:55 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51834 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaA1Lzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:55:53 -0500
Date: Tue, 28 Jan 2014 12:55:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
Message-ID: <20140128115549.GA26230@gmail.com>
References: <52E6AFFE.3030004@siemens.com>
 <20140127202252.GA11821@two.firstfloor.org>
 <52E767C2.2090807@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E767C2.2090807@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Kiszka <jan.kiszka@siemens.com> wrote:

> On 2014-01-27 21:22, Andi Kleen wrote:
> > On Mon, Jan 27, 2014 at 08:14:06PM +0100, Jan Kiszka wrote:
> >> apic_icr_write and its users in smpboot.c were apparently written under
> >> the assumption that this code would only run during early boot. But
> >> nowadays we also execute it when onlining a CPU later on while the
> >> system is fully running. That will make wakeup_cpu_via_init_nmi and,
> >> thus, also native_apic_icr_write run in plain process context. If we
> >> migrate the caller to a different CPU at the wrong time or interrupt it
> >> and write to ICR/ICR2 to send unrelated IPIs, we can end up sending
> >> INIT, SIPI or NMIs to wrong CPUs.
> >>
> >> Fix this by disabling interrupts during the write to the ICR halves and
> >> disable preemption around waiting for ICR availability and using it.
> > 
> > If you just want to disable migration use get_cpu()/put_cpu()
> 
> Fine with me if that is now preferred. Will that be the upstream way of
> -rt's migrate_disable()?

Your original patch is fine, the suggestion to do ICR accesses with 
just preemption disabled is crap and is really asking for trouble: if 
some IRQ comes in at that point after all then it might cause all 
sorts of hard to debug problems (hangs, delays, missed IPIs, etc.).

Thanks,

	Ingo
