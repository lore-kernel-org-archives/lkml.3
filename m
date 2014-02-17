Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaBQOQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:16:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaBQOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:16:32 -0500
Date: Mon, 17 Feb 2014 15:16:26 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jan Beulich <JBeulich@suse.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs >
 maxcpus and CONFIG_HOTPLUG=n
Message-ID: <20140217151626.5ff99027@hananiah.suse.cz>
In-Reply-To: <20140217134006.GA14786@khazad-dum.debian.net>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
	<5301D7AA020000780011CBE9@nat28.tlf.novell.com>
	<20140217110402.7e4fc211@hananiah.suse.cz>
	<20140217134006.GA14786@khazad-dum.debian.net>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 10:40:07 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Mon, 17 Feb 2014, Petr Tesarik wrote:
> > Well, if the user passes both nr_cpus and maxcpus parameters to the
> > kernel, I think it's fair to issue two warnings. But if everyone agrees
> > that only the maxcpus warning should be printed in that case, I can
> > send a version 2 of my patch.
> 
> Please remember that the market is full of motherboards with the extremely
> annoying behaviour of declaring ACPI objects for CPU cores that will never
> be available.  This includes a large number of workstation and server boards
> at the very least, from at least one rather large vendor.
> 
> As far as I know, we still don't have a way to realiably detect this and get
> rid of the ghost processors which will *NEVER* become online.  Setting
> maxcpus or nr_cpus manually is the current way to avoid wasting runtime
> resources because of phantom cores that will never become reality.
> 
> So, when you fix the bug that always supress the warnings, you will at the
> same time cause a regression on those boxes, which will now print undesired
> warnings.  If the user has manually set nr_cpus or maxcpus, maybe it would
> be best to not print any warnings or alternatively to downgrade them to
> debug level?

While I appreciate your concerns, I fail to see how they are related.

First, please keep in mind that my patch does not alter the (more
common) case with CONFIG_HOTPLUG_CPU=y in any way. For the (presumably
less common) !HOTPLUG_CPU case, it adds a warning that is always issued
in the HOTPLUG_CPU case.

Second, regarding your use case, I don't think it changes anything. So,
let's say you have a board with 16 CPUs and a MADT that describes 1024
CPUs. You know that there can (physically) be at most 48 CPUs, so you
boot with nr_cpus=48:

  num_processors = 16  /* online CPUs at boot */
  disabled_cpus = 992  /* 1008 - 16 */

This results in:

  total_cpus = 1008   /* this is purely informative, it is *NOT* used
                         to size anything */
  possible = 48       /* clamped to nr_cpu_ids */

A warning message (with or without my patch):
  1024 Processors exceeds NR_CPUS limit of 48

Informative message:
  Allowing 16 CPUs, 32 hotplug CPUs

No other warning (with or without my patch).

Petr Tesarik
SUSE L3 Team 1
