Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaAZJJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:09:37 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56421 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaAZJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:09:29 -0500
Date: Sun, 26 Jan 2014 10:09:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabled APICs being counted as processors ?
Message-ID: <20140126090926.GB30987@gmail.com>
References: <20140123221316.GA23367@redhat.com>
 <20140125074107.GA10565@gmail.com>
 <20140125153048.GA8536@redhat.com>
 <alpine.DEB.2.02.1401252223460.1723@chino.kir.corp.google.com>
 <20140126083631.GA29339@gmail.com>
 <CAE9FiQVUKZ2RsQ_BkePfmpXq+Ty3kj+k7h675fHy8Zm1Za=1Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVUKZ2RsQ_BkePfmpXq+Ty3kj+k7h675fHy8Zm1Za=1Zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Jan 26, 2014 at 12:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > No, this message is printed in prefill_possible_map() which
> > _generates_ cpu_possible_map, so '8' is the number of bits in
> > cpu_possible_map.
> >
> > So the problem is that the counting of disabled but hotpluggable CPUs
> > is over-eager. Since I haven't actually seen _true_ hotplug CPU
> > hardware yet, I'd argue we do the change below - allocating space for
> > never-present CPUs is stupid. If there's true hot-plug CPUs around
> > that could come online after we've booted, then we want to know about
> > them explicitly.
> >
> >
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index a32da80..75a351a 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -1223,10 +1223,7 @@ __init void prefill_possible_map(void)
> >         i = setup_max_cpus ?: 1;
> >         if (setup_possible_cpus == -1) {
> >                 possible = num_processors;
> > -#ifdef CONFIG_HOTPLUG_CPU
> > -               if (setup_max_cpus)
> > -                       possible += disabled_cpus;
> > -#else
> > +#ifndef CONFIG_HOTPLUG_CPU
> >                 if (possible > i)
> >                         possible = i;
> >  #endif
> 
> Agreed.

A question would be kexec and virtualization: do any of those variants 
boot a kernel with 'disabled but working' CPUs, which could be 
hot-onlined later on?

Thanks,

	Ingo
