Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbbAFToc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:44:32 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:50812 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789AbbAFTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:44:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
Date: Tue, 06 Jan 2015 20:43:37 +0100
Message-ID: <6786513.g26uGMFKLE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54ABF1E2.1010905@hurleysoftware.com>
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com> <9492211.AECobr3jIN@wuerfel> <54ABF1E2.1010905@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:CptUMOFaRZAhhXBs9YrZLnrpNH7vzAgL9QqHTcB4JSAUlvvwptU
 QH7i8hbbpqeScx19UmGxr22KZM0QQEVt/7AhHlTjcnf0zZMwZfZgzDBSvM1cEW7V+ILSmws
 HUGbqszS8a0M6hivd15S2WnpuDdXggBEOpq6ve5DgqolYDO9xxUmEDSIr2MFGJXJe7hXXeq
 N4OJasJwPikLQh9Ry+C/w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 09:32:02 Peter Hurley wrote:
> On 01/06/2015 08:13 AM, Arnd Bergmann wrote:
> > On Monday 05 January 2015 22:09:45 Peter Hurley wrote:
> >> Some arches have no need to create unprobed 8250 ports; these phantom
> >> ports are primarily required for ISA ports which have no probe
> >> mechanism or to provide non-operational ports for userspace to
> >> configure (via TIOCSSERIAL and TIOCSERCONFIG ioctls).
> >>
> >> Provide CONFIG_SERIAL_8250_PHANTOM_UARTS knob to disable phantom port
> >> registration; ie., CONFIG_SERIAL_8250_PHANTOM_UARTS=N only registers
> >> probed ports (ACPI/PNP, "serial8250" platform devices, PCI, etc).
> >>
> >> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >> Cc: Tony Lindgren <tony@atomide.com>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > 
> > The intent is definitely right, but I think a better approach is
> > possible.
> > 
> > I haven't tried it here, but how about moving the serial8250_init
> > function into a separate module, along with all the other parts
> > that are only used for ISA devices, but leaving the actual core
> > (all exported symbols) in this file?
> 
> Unfortunately, I don't see a way to remove the stacked initialization
> without risking tons of breakage.
> 
> Since later probes can "find" an already-existing port and
> re-initialize it, the probe order is crucial. For example, a PCI
> probe can "find" an existing "serial8250" platform device port,
> resulting in only one device node.

I'm probably missing something important, by why would that
be any different if the PCI driver gets loaded first and the
ISA driver second?

> And the configuration knob will be required on all arches anyway because
> that's how user-configurable device nodes are created.

I think that's fine: The user-configurable ports are the same as
the "ISA" or "phantom" ports we were talking about above, right?

If those are part of a separate (possibly loadable) module, having
a configuration knob is the obvious way to do it. A lot of architectures
can just turn it off because they know exactly which ports are present
and there is no need for user-configurability. The ones that don't know
can load the module.

> > At the same time, the serial8250_pnp_init/serial8250_pnp_exit calls
> > can be removed from the serial8250_init function and become
> > standalone initcalls.
> 
> PNP probe must occur before the phantom ports are registered.
> See commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
> ("8250_pnp: do pnp probe before legacy probe").

Makes sense.

	Arnd
