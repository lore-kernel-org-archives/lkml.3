Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3GJVcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab3GJVcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:32:07 -0400
Message-ID: <51DD9A78.5040308@redhat.com>
Date: Wed, 10 Jul 2013 13:31:36 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Malcolm Crossley <malcolm.crossley@citrix.com>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Expand interrupt remapping quirk to cover
 x58 chipset
References: <1373397069-8968-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1373397069-8968-1-git-send-email-nhorman@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:11 PM, Neil Horman wrote:
> Recently we added an early quirk to detect 5500/5520 chipsets with early
> revisions that had problems with irq draining with interrupt remapping enabled:
>
> commit 03bbcb2e7e292838bb0244f5a7816d194c911d62
> Author: Neil Horman<nhorman@tuxdriver.com>
> Date:   Tue Apr 16 16:38:32 2013 -0400
>
>      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets
>
> It turns out this same problem is present in the intel X58 chipset as well.  See
> errata 69 here:
> http://www.intel.com/content/www/us/en/chipsets/x58-express-specification-update.html
>
> This patch extends the pci early quirk so that the chip devices/revisions
> specified in the above update are also covered in the same way:
>
> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>
> Reviewed-by: Jan Beulich<jbeulich@suse.com>
> CC: Jan Beulich<jbeulich@suse.com>
> CC: Joerg Roedel<joro@8bytes.org>
> CC: Andrew Cooper<andrew.cooper3@citrix.com>
> CC: Malcolm Crossley<malcolm.crossley@citrix.com>
> CC: Prarit Bhargava<prarit@redhat.com>
> CC: Don Zickus<dzickus@redhat.com>
> CC: Don Dutile<ddutile@redhat.com>
> CC: Thomas Gleixner<tglx@linutronix.de>
> CC: Ingo Molnar<mingo@redhat.com>
> CC: "H. Peter Anvin"<hpa@zytor.com>
> CC: x86@kernel.org (maintainer:X86 ARCHITECTURE...)
> CC: stable@vger.kernel.org
> ---
>   arch/x86/kernel/early-quirks.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 94ab6b9..743d583 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -196,15 +196,23 @@ static void __init ati_bugs_contd(int num, int slot, int func)
>   static void __init intel_remapping_check(int num, int slot, int func)
>   {
>   	u8 revision;
> +	u16 device;
>
> +	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
>   	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
>
>   	/*
> -	 * Revision 0x13 of this chipset supports irq remapping
> -	 * but has an erratum that breaks its behavior, flag it as such
> + 	 * Revision 13 of all triggering devices id in this quirk have
> +	 * a problem draining interrupts when irq remapping is enabled,
> +	 * and should be flagged as broken.  Additionally revisions 0x12
> +	 * and 0x22 of device id 0x3405 has this problem.
>   	 */
>   	if (revision == 0x13)
>   		set_irq_remapping_broken();
> +	else if ((device == 0x3405)&&
> +	    ((revision == 0x12) ||
> +	     (revision == 0x22)))
> +		set_irq_remapping_broken();
>
>   }
>
When discussing the original-seen errata w/Intel on 55xx chips, the
statements made were any chip with rev C1(revision = 0x21) or greater had the 
correct
hw implementation for the intr-pending flush.
We knew the bug existed in the A3 (rev=0x13) rev of the chip, but the
true check should be:
	revision < 0x21

I suspect there were multiple revs of the x58, of which B2(0x12) & C2(0x22)
were shipped to oem's, system vendors, etc.
But, in case there were any chip revisions in between these well-known values
out there, I suggest the 0x3405 check be changed to:
	revision < 0x22

Since it's unlikely that hw degressed in design over revisions, it seems
more correct to check for revs less than a rev-value having an errata,
or conversely, a chip value >= rev-value do not have the errata.
IOW, an equal check may not provide sufficient.

- Don
> @@ -239,8 +247,11 @@ static struct chipset early_qrk[] __initdata = {
>   	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
>   	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
>   	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
> +	{ PCI_VENDOR_ID_INTEL, 0x3405, PCI_CLASS_BRIDGE_HOST,
> +	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>   	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
>   	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
> +	
>   	{}
>   };
>

