Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbbAZUv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:51:27 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43541 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:51:22 -0500
Date: Mon, 26 Jan 2015 20:50:57 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jon Masters <jcm@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        leif.lindholm@linaro.org, grant.likely@linaro.org
Subject: Re: inverse mapping from a struct console to device
Message-ID: <20150126205056.GA17169@leverpostej>
References: <54C6984A.20501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C6984A.20501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 07:40:58PM +0000, Jon Masters wrote:
> Hi Folks,
> 
> TLDR: I need a back reference from a console struct to its device. I
> can't see an easy way to do this right now without adding one?

I don't think that's quite what you need. All you need is to be able to
refer to the SPCR at serial probe time (more on that below), when you
should have the data you want.

> I've a quick question. I have prototype code that parses an ACPI table
> known as the SPCR (Serial Port Console Redirection - exists on both x86
> and ARM systems). It finds the correct serial device (but it's not a
> Linux specific DT-style solution so there's no "console=" parameter
> embedded in it or something)

In DT we have /chosen/stdout-path which offers analagous functionality.
It is independent of the command line, and has a standard set of
parameters (<baud>{<parity>{<bits>{<flow>}}}).

To make this work we check against the stdout-path when we register the
UART. Take a look at of_console check (called from uart_add_one_port).

Assuming your UART probing looks similar for ACPI, you can have an
analagous function that goes and checks uport->dev.acpi_dev_node against
entires in the SPCR, configuring the UART as required at this point at
registration time.

This requires that you parse the SPCR earlier, but presumably the SPCR
is simple enough that this is possible (no AML, for instance).

Is there some reason that approach is unworkable?

Mark.
