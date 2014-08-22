Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaHVUUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:20:31 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:53862 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaHVUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:20:30 -0400
Date: Fri, 22 Aug 2014 20:17:27 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_tis: Verify ACPI-specified interrupt
In-Reply-To: <20140822160626.GA8477@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain> <20140822160626.GA8477@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Jason Gunthorpe wrote:
> On Fri, Aug 22, 2014 at 12:58:41AM +0000, Scot Doyle wrote:
>> Some machines, such as the Acer C720 and Toshiba CB35, have TPMs
>> that do not use interrupts while also having an ACPI TPM entry
>
> How do these machines work in Windows?

I don't know. Since they're Chromebooks (booted in legacy mode running 
SeaBIOS instead of depthcharge or whatever ChromeOS uses), I think they're 
mostly used to run Linux.

> Why only resume? Shouldn't every TPM command (such as the 3 or 4 the
> driver issues at startup) timeout too?

I noticed that startup(save_state) on suspend did take longer, but only 
four or five seconds instead of the 160 seconds during selftest on resume.

>> indicating a specific interrupt to be used. Since this interrupt
>> is invalid, these machines freeze on resume until the interrupt
>> times out.
>
>> Generate the ACPI-specified interrupt. If none is received, then
>> fall back to polling mode.
>
> So, this makes the IRQ detection code run unconditionally, but that
> code was only ever really used in certain old non-probable case..
>
> I wonder if it works reliably?

That is good to know. I share your concerns about reliability, not having 
the ability to test on other machines.

> In any event, I think a FIRMWARE_BUG message should be printed if this
> case is detected.

I agree.

> I'd be more comfortable with some kind of ACPI black list or patch or
> something? What is normal for handling broken ACPI?

I would be more comfortable with this general approach as well. However, 
I've had to submit several patches for individual Chromebooks related to 
backlight control since the VBT also is misconfigured. Would it be 
possible to find a blacklist mechanism that didn't require identifying 
each Chromebook separately, since they seem to have this issue on an 
ongoing basis?

dmidecode outputs:

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: coreboot
        Version:
        Release Date: 12/04/2013
        ROM Size: 8192 kB
        Characteristics:
                PCI is supported
                PC Card (PCMCIA) is supported
                BIOS is upgradeable
                Selectable boot is supported
                ACPI is supported
                Targeted content distribution is supported
        BIOS Revision: 4.0
        Firmware Revision: 0.0

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: Toshiba
        Product Name: Leon
        Version: 1.0
        Serial Number: 123456789
        UUID: Not Settable
        Wake-up Type: Reserved
        SKU Number: Not Specified
        Family: Not Specified

All Chromebooks that I've seen list the BIOS vendor as 'coreboot'.

We also have access to TPM chip vendor and revision. All chromebooks that 
I've seen so far have the same vendor (11) and revision (16).

So we have five pieces of identifying information...
1. TPM chip vendor
2. TPM chip revision
3. BIOS vendor
4. System manufacturer
5. System product name

and at least two possible actions...
1. ignore the acpi interrupt
2. verify the acpi interrupt

The safest approach would be to ignore the ACPI information for systems 
matching all five identifiers.

A more general approach might be to verify the ACPI interrupt for 
systems matching the first three identifiers.

Thoughts?

> Jason
>
