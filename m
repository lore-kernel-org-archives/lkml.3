Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaCROBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:01:11 -0400
Received: from canardo.mork.no ([148.122.252.1]:51071 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbaCROBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:01:09 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: v3.14-rc1+: new error: "nsc-ircc, Wrong chip version ff"
Organization: m
References: <1395006095.2002.8.camel@x41>
Date: Tue, 18 Mar 2014 15:00:46 +0100
In-Reply-To: <1395006095.2002.8.camel@x41> (Paul Bolle's message of "Sun, 16
	Mar 2014 22:41:35 +0100")
Message-ID: <87ppljip2p.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> Rafael,
>
> 0) Ever since v3.14-rc1 I've noticed two new boot messages on an,
> outdated, ThinkPad X41:
>     nsc-ircc, Found chip at base=0x164e
>     nsc-ircc, Wrong chip version ff

Looks like that driver calls request_region for its "fir_base" IO ports
too late.

Parts of nsc_ircc_open:

..
        IRDA_MESSAGE("%s, Found chip at base=0x%03x\n", driver_name,
                     info->cfg_base);

        if ((nsc_ircc_setup(info)) == -1)
                return -1;

=> fails while attempting to write to info->fir_base + 3 and then read
   from info->fir_base + 0

..
        /* Initialize IO */
        self->io.cfg_base  = info->cfg_base;
        self->io.fir_base  = info->fir_base;
        self->io.irq       = info->irq;
        self->io.fir_ext   = CHIP_IO_EXTENT;
        self->io.dma       = info->dma;
        self->io.fifo_size = 32;
        
        /* Reserve the ioports that we need */
        ret = request_region(self->io.fir_base, self->io.fir_ext, driver_name);

Maybe reorder this a bit, requesting the fir_base IO ports before
calling nsc_ircc_setup?  You'll have to reorder the error cleanups too.


> The first is printed at info level, so I would have ignored it, but the
> second is printed at error level.
>
> 1) I've finally managed to bisect these messages to commit 202317a573b2
> ("ACPI / scan: Add acpi_device objects for all device nodes in the
> namespace"). That's a rather big commit, so I've not even bothered to
> try to revert it on top on v3.14-rc6.

My guess is that you've got some pnp device now claiming the FIR IO
ports.  cat /proc/ioports may help you find out what to look for?


Bjørn
