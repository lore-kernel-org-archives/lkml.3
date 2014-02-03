Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaBCLLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:11:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44098 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBCLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:11:12 -0500
Date: Mon, 3 Feb 2014 11:10:40 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Pavel Roskin <proski@gnu.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: serial8250: bogus low_latency destabilizes kernel, need sanity
 check
Message-ID: <20140203111040.4cafe560@alan.etchedpixels.co.uk>
In-Reply-To: <52ED0E0F.5050300@hurleysoftware.com>
References: <20140113193547.47b7a646@IRBT4585>
	<20140114120811.648571ea@alan.etchedpixels.co.uk>
	<20140114112457.q54ujbz9c444s040-cebfxv@webmail.spamcop.net>
	<52ED0E0F.5050300@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Feb 2014 10:09:03 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> On 01/14/2014 11:24 AM, Pavel Roskin wrote:
> > Hi Alan,
> >
> > Quoting One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>:
> >
> >>> Maybe we should unset the low_latency flag as soon as DMA fails?  There
> >>> are two flags, one is state->uart_port->flags and the other is
> >>> port->low_latency.  I guess we need to unset both.
> >>
> >> Well low latency and DMA are pretty much exclusive in the real world so
> >> probably DMA ports shouldn't allow low_latency to be set at all in DMA
> >> mode.
> >
> > That's a useful insight.  I assumed exactly the opposite.
> 
> The meaning of low_latency has migrated since 2.6.28

Not really. The meaning of low latency was always "get the turn around
time for command/response protocols down as low as possible". DMA driven
serial usually reports a transfer completion on a watermark or a timeout,
so tends to work very badly within the Linux definition of 'low latency'
for tty.

What it does has certainly changed but thats implementation detail.
 
> Perhaps we should unconditionally unset low_latency (or remove it entirely).
> Real low latency can be addressed by using the -RT kernel.

Just saying "use -RT" would be a regression and actually hurt quite a few
annoying "simple protocol" using tools for all sorts of control systems.
We are talking about milliseconds not microseconds here.

The expected behaviour in low_latency is probably best described as

data arrives
processed
wakeup

and to avoid the case of

data arrives
queued for back end
[up to 10mS delay, but typically 1-2mS]
processed
wakeup


which multipled over a 50,000 S record download is a lot of time

Everything else is not user visible so can be changed freely to get that
assumption to work (including ending up not needing it in the first
place).

Getting tty to the point everything but N_TTY canonical mode is a fast
path would probably eliminate the need nicely - I don't know of any use
cases that expect ICANON, ECHO or I*/O* processing for low latency.

