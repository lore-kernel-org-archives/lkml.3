Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3G2S2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:28:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39182 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3G2S2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:28:14 -0400
Date: Mon, 29 Jul 2013 19:27:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
	people interested in device tree janitoring / cleanup?]
Message-ID: <20130729182730.GN24642@n2100.arm.linux.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <51F39FD8.6080808@broadcom.com> <20130727183059.GD4813@netboy> <1441731.8CGUI1tUxh@flatron> <20130729180513.GB1884@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729180513.GB1884@obsidianresearch.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 12:05:13PM -0600, Jason Gunthorpe wrote:
> Clearly general purpose systems (eg servers, workstations, etc) with
> *full featured firmware* fall into category b. Linux already basically
> has stable DT for those systems - but the firmware is expected to do
> lots of work and hide all the low level details from the
> kernel. Basically, the DT should stick to approximately ePAR and
> everything else is hidden by the firmware. This is essentially how x86
> works and achieves its compatibility.

and the downside of placing that trust in firmware is that it very often
leads to bugs which can't be solved.

I have a set of patches for my laptop/docking station which gets the
serial/printer ports working.  I've had them for many years now - and
I thought I had a problem sorted.  I was wrong - the nice helpful ACPI
reports on dock that the serial port is enabled, but the port is
actually disabled in hardware.

If I have ACPI/PNP stuff setup to always believe that this port is
disabled, then on boot with the docking station connected, it comes up
initially as ttyS0, and then, because the port is "disabled", the
resources are busy so it gets reassigned to a different IO port.
Undocking/redocking works because the port is now properly re-enabled
after a dock event.

If I report the ACPI status to the kernel, then on boot, it correctly
remains as ttyS0.  However, after an undock/redock event, Linux
believes that the port is back, but any attempt to use it gets the
"LSR safety check engaged" message, because the port is actually
disabled.  The only way to get it working again is to manually unbind
the device and rebind it - so the ACPI disable + enable methods get
called.

I've had this problem for years, and it's basically unfixable for me -
it's only fixable if you are IBM and can reflash the BIOS with alternative
ACPI tables which are correct.  And I won't submit these patches all the
time that I don't know they work correctly.

That's the problem with "compatible systems" - you give away trust that
someone else will do the right thing, and if they don't, you may be
screwed in a way that is can not be worked around by quirks or similar
- just like the above.

Firmware is swings and roundabouts.  You give up some control to a
third party so you don't have to think about XYZ, and you hope that
they get it right.
