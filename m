Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3EJJhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:37:34 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54859 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3EJJhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:37:32 -0400
Date: Fri, 10 May 2013 11:37:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510093729.GA16487@gmail.com>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
 <20130510092811.GA22942@pd.tnic>
 <CAFTL4hxx_pHkJExnRks4hcOYGrJb8TCMRdCtt0UA-i3wsaWWcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxx_pHkJExnRks4hcOYGrJb8TCMRdCtt0UA-i3wsaWWcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/5/10 Borislav Petkov <bp@alien8.de>:
> > On Fri, May 10, 2013 at 02:29:31AM +0200, Frederic Weisbecker wrote:
> >> @@ -616,8 +616,17 @@ static bool wake_up_full_nohz_cpu(int cpu)
> >>  {
> >>       if (tick_nohz_full_cpu(cpu)) {
> >>               if (cpu != smp_processor_id() ||
> >> -                 tick_nohz_tick_stopped())
> >> +                 tick_nohz_tick_stopped()) {
> >> +                     if (!cpu_online(cpu)) {
> >> +                             static int printed = 0;
> >> +                             if (!printed) {
> >> +                                     printk("%d %d\n", cpu, smp_processor_id());
> >> +                                     dump_stack();
> >> +                                     printed = 1;
> >
> > You know about printk_once, right? We even have all the pr_<level>_once
> > macros.
> >
> > :-)
> 
> But but that didn't fit as I also want the dump_stack(). May be we
> want dump_stack_once().

The pattern I use in such cases is:

	if (WARN_ONCE(!cpu_online(cpu))) {
		printk("%d %d\n", cpu, smp_processor_id());
		dump_stack();
	}

Thanks,

	Ingo
