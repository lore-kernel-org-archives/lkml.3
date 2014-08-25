Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaHYGla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:41:30 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:40391 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaHYGl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:41:29 -0400
Date: Mon, 25 Aug 2014 06:38:33 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_tis: Verify ACPI-specified interrupt
In-Reply-To: <20140822203241.GB1733@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain> <20140822160626.GA8477@obsidianresearch.com> <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain> <20140822203241.GB1733@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Jason Gunthorpe wrote:
> On Fri, Aug 22, 2014 at 08:17:27PM +0000, Scot Doyle wrote:
>> On Fri, 22 Aug 2014, Jason Gunthorpe wrote:
>>> On Fri, Aug 22, 2014 at 12:58:41AM +0000, Scot Doyle wrote:
>>>> Some machines, such as the Acer C720 and Toshiba CB35, have TPMs
>>>> that do not use interrupts while also having an ACPI TPM entry
>>>
>>> How do these machines work in Windows?
>>
>> I don't know. Since they're Chromebooks (booted in legacy mode running
>> SeaBIOS instead of depthcharge or whatever ChromeOS uses), I think they're
>> mostly used to run Linux.
>
> I remain somewhat confused - there have already been TPM patches for
> Chromebooks from Google - presumably the TPM actually does work
> fine. Make sure you are using a Linux with the ATMEL timeout fix, that
> is particularly applicable to Chromebooks IIRC.
>
> And again, the driver uses interrupts when booting, so I'm somewhat
> confused what the problem is. I wouldn't think the driver would
> successfully attach if interrupts were enabled but the interrupt
> didn't work? Can you elaborate on what is going on during boot with
> the interrupt, and the boot time GET_DURATIONS and TPM_STARTUP
> sequences?
>
> Perhaps the driver is timing out all commands and going ahead and
> attaching anyhow? If this is the case I think we'd get a good result
> if we just fixed that and had the driver simply not attach. Then your
> resume will not be broken.
>
>>> I'd be more comfortable with some kind of ACPI black list or patch or
>>> something? What is normal for handling broken ACPI?
>>
>> I would be more comfortable with this general approach as well. However,
>> I've had to submit several patches for individual Chromebooks related to
>> backlight control since the VBT also is misconfigured. Would it be
>> possible to find a blacklist mechanism that didn't require identifying
>> each Chromebook separately, since they seem to have this issue on an
>> ongoing basis?
>
> So, if you are booting the Chromebook in some weird way, is this a
> problem that can be addressed by patching SeaBIOS instead of the
> kernel? The internet says the SeaBIOS payload is replaceable on the
> Chromebook.
>
> Can it fix the ACPI tables to be correct before lauching Linux?
>
>> A more general approach might be to verify the ACPI interrupt for
>> systems matching the first three identifiers.
>
> Testing the interrupt and failing driver attach if it doesn't work
> seems very reasonable to me, I would view that as a bug fix in the driver.
>
> Jason


Hopefully this explanation will provide any missing bits of information.
Please correct me where needed.


The Chromebooks use coreboot + payload as firmware. The three payloads of 
interest are:

1. Depthcharge. Used when a ChromeOS user boots the machine. Since the
   kernel must be signed, presumably the TPM chip is used extensively.
   Signing prevents usage with other distributions.

2. The stock version of SeaBIOS. Used in "developer" mode, and provides
   typical BIOS functionality. Kernel signature is not checked, so those
   parts of the TPM are not needed. However, the machine will reboot on
   resume unless the tpm_tis module is loaded and working, as documented
   in commit f7595464.

3. A custom version of SeaBIOS. While it could be bespoke, usually it is
   built by someone else for all users of a given Chromebook model (see
   https://johnlewis.ie/custom-chromebook-firmware/rom-download/ ). It
   functions like stock SeaBIOS, except that the TPM usually isn't started
   by this payload. However, the ACPI DSDT still has a TPM entry listing
   the IFX0102 chip, which causes the tpm_tis module to load. The
   tpm_tis_init function calls tpm_get_timeouts, which in turn sees that
   the chip has not been started and therefore issues a startup(clear)
   command. Now the chip is running. It will not be reboot on resume
   (unlike stock SeaBIOS), presumably since the firmware is not
   interacting with the TPM. But because an error 38 is returned during
   the selftest issued on resume, its functioning will degrade over
   suspend/resume cycles until the machine refuses to enter suspend,


Manual workarounds for these three payloads:

1. Depthcharge. I don't know how ChromeOS interacts with the TPM chip.
   From what I've seen, it may boot with kernel parameters tpm_tis.force=1
   and tpm_tis.interrupts=0 (see #2 following). The kernel is older.

2. Stock SeaBIOS. Boot the kernel with tpm_tis.force=1 or
   tpm_tis.interrupts=0. 'force=1' causes the module to ignore the ACPI
   TPM interrupt entry and instead probe for interrupts. Since no
   interrupts are found to be valid, the driver falls back to polling
   mode. And 'interrupts=0' causes the interrupt probing to be skipped,
   defaulting to polling mode. So, even though most users set BOTH of
   these parameters, they have the same effect on these machines and only
   one or the other are necessary.

3. Custom SeaBIOS. Blacklist the tpm_tis module so that it doesn't load
   and therefore doesn't issue startup(clear) to the TPM chip.


While there are manual workarounds, a number of people would like the 
tpm_tis module to automatically function correctly for stock and custom 
SeaBIOS, as we use these machines with those payloads.

Because there are so many users, and flashing the payload is considered 
risky, and those who do flash are not usually the ones who build their 
firmware, fixing the ACPI table in firmware (which requires flashing) 
would not be a general solution. Hopefully Google (or their manufacturing 
partners) will correct this in future Chromebooks.


Details about tpm_tis module init using stock SeaBIOS:

The firmware sends a startup(clear). Then the tpm_tis module is loaded 
because there is a matching ACPI entry for "IFX0102". By default, module 
parameters are interrupts=1 and force=0. I will talk about these default 
values, since that is the case that I'd like to fix. force=0 causes the 
module to look for an ACPI entry. It finds an entry indicating IRQ 6 and 
continues with the tpm_tis_init function.

tpm_tis_init starts in polling mode. It registers the hardware device, 
performs some initial setup, queries the chip manufacturer and vendor id, 
deterines the chip capabilities (I think they are all enabled), gets 
timeouts, does a selftest (which passes), sets up the interrupt and read 
queues, and enables chip interrupts. It does all of this in polling mode. 
Then, because interrupts=1 and the interrupt was determined from the ACPI 
table entry, it skips the code section which probes for available 
interrupts. Next, it switches to interrupt mode. It tells the TPM to use 
IRQ 6, requests IRQ 6 for use with the driver, does some clean up, and 
exits, returning 0.

I've verified that no blocking commands are send to the TPM during the 
tpm_tis_init function. Since none are sent, no interrupts fail, and the 
attach procedes as normal.

Side note 1: my understanding is that the module exchanges data with the 
TPM in the same way whether in polling mode or interrupt mode. These two 
modes only indicate how the module determines that it may send additional 
commands and/or receive expected data from the TPM. In other words, the 
interrupt or polling tell the module when it can continue.

Side note 2: There seems to be a bug that would have prevented detection 
of interrupt timeout anyway. I'll follow up with a patch.


Details about tpm_tis module init using custom SeaBIOS:

The same as stock SeaBIOS, except that no startup(clear) has been sent by 
the firmware, so tpm_get_timeouts sees that the chip has not been started 
and therefore issues a startup(clear) command itself.


Some possible solutions for discussion...

To make stock SeaBIOS work automatically:
1. For all systems in interrupt mode because of an ACPI entry: Use a
   non-fragile method to detect correct functioning of the TPM and the
   failure of interrupts. If detected, then fall back to polling mode.
   Worst case is (slightly?) degraded performance.
2. Same as 1, but only for quirked machines

To make custom SeaBIOS work automatically:
3. For all systems: If error 38 received from selftest at resume, do not
   issue subsequent save_state commands before suspend. (This approach has
   been tested.)
4. For all systems: Do not send startup(clear) in tpm_get_timeouts unless
   a module parameter is set.
5. Same as 4, but only for quirked machines

As suggested by Jason:
6. For all machines in interrupt mode. Use a non-fragile method to detect
   the failure of interrupts. Don't attach if detected.


Thanks!
