Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbbAGKGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:06:05 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63387 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbAGKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:06:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
Date: Wed, 07 Jan 2015 11:05:14 +0100
Message-ID: <2241604.rliP7ovaYi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AC580B.2050809@hurleysoftware.com>
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com> <6786513.g26uGMFKLE@wuerfel> <54AC580B.2050809@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:XxDFGbG9LVLnJ9JtfM0KuPsDC7I6FjarN9R+rRWcg0JExKQ3tMW
 AfxECD6gLw6UiQBp3Wk/RlOkqBBRobtm9X7It6KQkMe8VIwOHSMgifDxw5fYHeWCXtpRIZE
 Akxcf7DjN+7FyB9SobDa/La2eP+VGr4FrQWdoODK1M+S3SGeDMXKVPbhSMwGwvWMJPV1Fr/
 lMIZA7ndK4hveX8CdPALg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 16:47:55 Peter Hurley wrote:
> On 01/06/2015 02:43 PM, Arnd Bergmann wrote:
> > On Tuesday 06 January 2015 09:32:02 Peter Hurley wrote:
> >> On 01/06/2015 08:13 AM, Arnd Bergmann wrote:
> >>> On Monday 05 January 2015 22:09:45 Peter Hurley wrote:
> >>>> Some arches have no need to create unprobed 8250 ports; these phantom
> >>>> ports are primarily required for ISA ports which have no probe
> >>>> mechanism or to provide non-operational ports for userspace to
> >>>> configure (via TIOCSSERIAL and TIOCSERCONFIG ioctls).
> >>>>
> >>>> Provide CONFIG_SERIAL_8250_PHANTOM_UARTS knob to disable phantom port
> >>>> registration; ie., CONFIG_SERIAL_8250_PHANTOM_UARTS=N only registers
> >>>> probed ports (ACPI/PNP, "serial8250" platform devices, PCI, etc).
> >>>>
> >>>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >>>> Cc: Tony Lindgren <tony@atomide.com>
> >>>> Cc: Grant Likely <grant.likely@linaro.org>
> >>>> Cc: Arnd Bergmann <arnd@arndb.de>
> >>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> >>>
> >>> The intent is definitely right, but I think a better approach is
> >>> possible.
> >>>
> >>> I haven't tried it here, but how about moving the serial8250_init
> >>> function into a separate module, along with all the other parts
> >>> that are only used for ISA devices, but leaving the actual core
> >>> (all exported symbols) in this file?
> >>
> >> Unfortunately, I don't see a way to remove the stacked initialization
> >> without risking tons of breakage.
> >>
> >> Since later probes can "find" an already-existing port and
> >> re-initialize it, the probe order is crucial. For example, a PCI
> >> probe can "find" an existing "serial8250" platform device port,
> >> resulting in only one device node.
> > 
> > I'm probably missing something important, by why would that
> > be any different if the PCI driver gets loaded first and the
> > ISA driver second?
> 
> Well, the PCI driver would have the proper irq, for one. So, if the
> the platform driver re-initialized the port to the wrong irq...

I see. So we must still ensure that the ISA driver either gets loaded
before the PCI driver, or never. It is already closely coupled with
the PNP driver, but I think we can still get to the point where you
don't load the ISA driver at all if you only have platform 8250
ports that are not supposed to be reconfigurable.

On most non-x86 machines, I would think we also want a way to build
the PCI driver without that dependency.

	Arnd
