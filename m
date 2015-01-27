Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbbA0Map (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:30:45 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43908 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbbA0Ma0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:30:26 -0500
Date: Tue, 27 Jan 2015 12:30:02 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jon Masters <jcm@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Andre Przywara <Andre.Przywara@arm.com>
Subject: Re: inverse mapping from a struct console to device
Message-ID: <20150127123002.GE17721@leverpostej>
References: <54C6984A.20501@redhat.com>
 <20150126205056.GA17169@leverpostej>
 <54C700BB.5030200@redhat.com>
 <20150127101440.GA17721@leverpostej>
 <54C77C6A.8000508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C77C6A.8000508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 11:54:18AM +0000, Jon Masters wrote:
> On 01/27/2015 05:14 AM, Mark Rutland wrote:
> > On Tue, Jan 27, 2015 at 03:06:35AM +0000, Jon Masters wrote:
> >> On 01/26/2015 03:50 PM, Mark Rutland wrote:
> >>> On Mon, Jan 26, 2015 at 07:40:58PM +0000, Jon Masters wrote:
> >>>> Hi Folks,
> >>>>
> >>>> TLDR: I need a back reference from a console struct to its device. I
> >>>> can't see an easy way to do this right now without adding one?
> >>>
> >>> I don't think that's quite what you need. All you need is to be able to
> >>> refer to the SPCR at serial probe time (more on that below), when you
> >>> should have the data you want.
> >>
> >> Hmm. I wanted to do it in console_register due to the existing logic for
> >> adding a preferred console there. But that's a silly reason.
> >>
> >>>> I've a quick question. I have prototype code that parses an ACPI table
> >>>> known as the SPCR (Serial Port Console Redirection - exists on both x86
> >>>> and ARM systems). It finds the correct serial device (but it's not a
> >>>> Linux specific DT-style solution so there's no "console=" parameter
> >>>> embedded in it or something)
> >>>
> >>> In DT we have /chosen/stdout-path which offers analagous functionality.
> >>> It is independent of the command line, and has a standard set of
> >>> parameters (<baud>{<parity>{<bits>{<flow>}}}).
> >>
> >> Hmm. I thought it was embedding a Linux specific console parameter, but
> >> I see when I actually check the code and the Documentation (sorry) that
> >> it is indeed similar in capability. Which is awesome. I'll do similar.
> >>
> >>> To make this work we check against the stdout-path when we register the
> >>> UART. Take a look at of_console check (called from uart_add_one_port).
> 
> I have working SPCR setup on a system using an 8250 interface (Mustang)
> with ACPI. The preferred console comes up nicely. So, that's good.
> 
> >> Great. Thanks. I looked at modifying uart_add_one_port, but I wasn't
> >> convinced it was called by every serial driver (for example, the
> >> sbsauart driver). I don't know the tty/serial code as well as I'd like.
> >> But I'll implement it the same way as in the OF case for the moment, and
> >> if we need to fix up a driver or two we can always do that.
> 
> Confirmed that the existing sbsauart driver I have doesn't use
> uart_add_one_port (it's an older driver based on Linaro's code). It
> seems like we need to update, which I'll follow up on separately.
> 
> > The SBSA UART is a bit of a special case, given it cannot be
> > reconfigured. While Andre's SBSA UART driver [1] will call
> > uart_add_one_port (as the PL011 driver seems to currently), I believe
> > any configuration is ignored.
> 
> Indeed. And we don't need to reconfigure it, but we still want to know
> which console to use since it could be an SBSA or 8250. And in theory
> someone could build something else (but not conforming to SBBR).
> 
> > In the DT case, we'd expect the SBSA UART node to have a current-speed
> > property describing the fixed, preconfigured speed. This has no bearing
> > on the operation of the driver (because there's nothing to configure)
> > and is only used to report the speed to userspace.
> > 
> > I guess we don't have something on the ACPI node, and you want to use
> > the SPCR to determine the preconfigured rate in this case?
> 
> Nope, I just want to know that I'm using the SBSA console and not
> another. Hence the SPCR will tell me which to set as preferred.

Configuring the default UART should work, even with the SBSA UART.

The only issue that leaves is that the with the SBSA UART the baud rate
reported to userspace may be wrong (because the baud rate read from the
SPCR will be ignored by the driver as it thinks this is configuration).

If the ACPI node for the SBSA UART has the configured rate, we can
handle that as we do for DT. Otherwise we need to have the SBSA UART
driver see if there's a rate in the SPCR that it can report.

> Here's an example of the data we get in the SPCR for reference:
> 
> [0012]               Serial Port Register : [Generic Address Structure]
> [0001]                           Space ID : 00 [SystemMemory]
> [0001]                          Bit Width : 08
> [0001]                         Bit Offset : 00
> [0001]               Encoded Access Width : 01 [Byte Access:8]
> [0008]                            Address : 000000001c020000
> 
> [0001]                     Interrupt Type : 08
> [0001]                PCAT-compatible IRQ : 00
> [0004]                          Interrupt : 0000006C
> [0001]                          Baud Rate : 07
> [0001]                             Parity : 00
> [0001]                          Stop Bits : 01
> [0001]                       Flow Control : 00
> [0001]                      Terminal Type : 00
> [0001]                           Reserved : 00
> 
> The actual structure is longer, but you get the idea. I first map this
> to the correct Device in the DSDT with a device_initcall that will find
> the table then walk the ACPI namespace to find the corresponding device.
> This is stashed so that later we can perform the same kind of comparison
> that you do with DT today. I also populate options, though so far have
> only bothered to implement baud rate.

I would recommend that you set up as many of these ASAP. Otherwise
someone's certain to mess up a table and we can never add them later.

Otherwise, sounds good!

Mark.
