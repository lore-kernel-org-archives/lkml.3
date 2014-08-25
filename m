Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaHYSYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:24:32 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37335 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbaHYSYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:24:30 -0400
Date: Mon, 25 Aug 2014 12:24:14 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_tis: Verify ACPI-specified interrupt
Message-ID: <20140825182414.GB1298@obsidianresearch.com>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain>
 <20140822160626.GA8477@obsidianresearch.com>
 <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain>
 <20140822203241.GB1733@obsidianresearch.com>
 <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 06:38:33AM +0000, Scot Doyle wrote:

>    command. Now the chip is running. It will not be reboot on resume
>    (unlike stock SeaBIOS), presumably since the firmware is not
>    interacting with the TPM. But because an error 38 is returned during
>    the selftest issued on resume, its functioning will degrade over
>    suspend/resume cycles until the machine refuses to enter suspend,

So, be aware, on x86 the TPM specs require some BIOS support for
suspend/resume to work properly.

> Manual workarounds for these three payloads:
> 
> 1. Depthcharge. I don't know how ChromeOS interacts with the TPM chip.
>    From what I've seen, it may boot with kernel parameters tpm_tis.force=1
>    and tpm_tis.interrupts=0 (see #2 following). The kernel is older.

The HW or interrupt routing is fundamentally broken somehow?
 
> 2. Stock SeaBIOS. Boot the kernel with tpm_tis.force=1 or
>    tpm_tis.interrupts=0. 'force=1' causes the module to ignore the ACPI
>    TPM interrupt entry and instead probe for interrupts. Since no
>    interrupts are found to be valid, the driver falls back to polling
>    mode. And 'interrupts=0' causes the interrupt probing to be skipped,
>    defaulting to polling mode. So, even though most users set BOTH of
>    these parameters, they have the same effect on these machines and only
>    one or the other are necessary.
> 
> 3. Custom SeaBIOS. Blacklist the tpm_tis module so that it doesn't load
>    and therefore doesn't issue startup(clear) to the TPM chip.

It seems to me at least in this case you should be able to get rid of
the IRQ entry, people are going to be flashing the custom SeaBIOS
anyhow.

Further, in x86 land you really should have BIOS support for operating
a TPM if the OS is going to touch it. I don't really understand why
you want to flash a custom BIOS that doesn't work and then hack the
kernel to fix the custom BIOS's deficiencies? Fix the BIOS, you are
flashing it already anyhow.

> The firmware sends a startup(clear). Then the tpm_tis module is loaded 
> because there is a matching ACPI entry for "IFX0102". By default, module 
> parameters are interrupts=1 and force=0. I will talk about these default 
> values, since that is the case that I'd like to fix. force=0 causes the 
> module to look for an ACPI entry. It finds an entry indicating IRQ 6 and 
> continues with the tpm_tis_init function.

So, sounds like IRQ=6 is a BIOS bug.

> tpm_tis_init starts in polling mode. It registers the hardware device, 
> performs some initial setup, queries the chip manufacturer and vendor id,
> deterines the chip capabilities (I think they are all enabled), gets 
> timeouts, does a selftest (which passes), sets up the interrupt and read 
> queues, and enables chip interrupts. It does all of this in polling
> mode.

This is the wrong order, I think, the interrupts should be on before
issuing commands, other tpm drivers are working this way already.

> I've verified that no blocking commands are send to the TPM during the 
> tpm_tis_init function. Since none are sent, no interrupts fail, and the 
> attach procedes as normal.

tpm_get_timeouts and tpm_do_selftest should both be commands that
potentially wait for interrupt.
 
> Side note 1: my understanding is that the module exchanges data with the 
> TPM in the same way whether in polling mode or interrupt mode.

Right, the interrupt simply indicates when the TPM has completed
executing the comamnd, the driver can either poll loop or wait on IRQ
to read back the status register bit indicating the command is done.

> To make stock SeaBIOS work automatically:
> 1. For all systems in interrupt mode because of an ACPI entry: Use a
>    non-fragile method to detect correct functioning of the TPM and the
>    failure of interrupts. If detected, then fall back to polling mode.
>    Worst case is (slightly?) degraded performance.
> 2. Same as 1, but only for quirked machines
> 
> To make custom SeaBIOS work automatically:
> 3. For all systems: If error 38 received from selftest at resume, do not
>    issue subsequent save_state commands before suspend. (This approach has
>    been tested.)

This isn't right, if tpm core is going to handle resume without BIOS
support then it must do the protocol properly. IIRC this is issuing a
startup and then restore state command at resume (the BIOS is expected
to do this on x86, and it is expected to not jump back to the OS if
something goes wrong with the TPM, or the resume image has been
tampered with)

This might be interesting to people doing embedded (and I can't recall
exactly, but I want to say that one of the drivers implemented this).

Clearly we'd need a way to turn on 'embedded' mode for the TPM, but
that could potentially be a module parameter on x86...

> 4. For all systems: Do not send startup(clear) in tpm_get_timeouts unless
>    a module parameter is set.

No, all embedded systems require this functionality, why would you
want to take this out?

Jason
