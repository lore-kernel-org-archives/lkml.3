Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaAZJoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:44:30 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:39213 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaAZJo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:44:27 -0500
Date: Sun, 26 Jan 2014 01:44:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: disabled APICs being counted as processors ?
In-Reply-To: <20140126092912.GA31643@gmail.com>
Message-ID: <alpine.DEB.2.02.1401260131160.15844@chino.kir.corp.google.com>
References: <20140123221316.GA23367@redhat.com> <20140125074107.GA10565@gmail.com> <20140125153048.GA8536@redhat.com> <alpine.DEB.2.02.1401252223460.1723@chino.kir.corp.google.com> <20140126083631.GA29339@gmail.com> <alpine.DEB.2.02.1401260038510.15844@chino.kir.corp.google.com>
 <20140126092912.GA31643@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014, Ingo Molnar wrote:

> > > So the problem is that the counting of disabled but hotpluggable 
> > > CPUs is over-eager.
> > 
> > In the kernel, yeah, and we don't distinguish between physically 
> > absent processors that have lapic entries and physically present but 
> > disabled processors.
> 
> Correct. Is there a robust distinction possible between the two?
> 

Not with acpi, I'm afraid, which allows for both possibilities to either 
have no lapic entry or have ACPI_MADT_ENABLED clear.

> > > --- a/arch/x86/kernel/smpboot.c
> > > +++ b/arch/x86/kernel/smpboot.c
> > > @@ -1223,10 +1223,7 @@ __init void prefill_possible_map(void)
> > >  	i = setup_max_cpus ?: 1;
> > >  	if (setup_possible_cpus == -1) {
> > >  		possible = num_processors;
> > > -#ifdef CONFIG_HOTPLUG_CPU
> > > -		if (setup_max_cpus)
> > > -			possible += disabled_cpus;
> > > -#else
> > > +#ifndef CONFIG_HOTPLUG_CPU
> > >  		if (possible > i)
> > >  			possible = i;
> > >  #endif
> > 
> > Yeah, this should suppress the warning for Dave.  This way, the only way 
> > the log reports the number of "hotplug CPUs" is because we used 
> > possible_cpus.
> 
> Not just that, it also reduces the number of possible CPUs, which 
> should reduce percpu memory allocation overhead, amongst other things, 
> right?
> 

Indeed, it gives people a good motivation for clearing out those 
unnecessary lapic entries :)

> I wouldn't object to someone sending a changelogged, tested patch that 
> does all that. Maybe two patches: first the cleanups, then the CPU 
> count trimming. Just in case it regresses ...
> 

Sounds good.  I need to look into your point about kexec as far as the 
possible count trimming first for the second patch.
