Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaCXSbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:31:32 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:53576 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbaCXSba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:31:30 -0400
Date: Mon, 24 Mar 2014 19:31:11 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] NULL pointer dereference in acpi_gpiochip_add (on
 modprobe ssb)
Message-ID: <20140324183111.GC25669@kria>
References: <20140324154944.GB25669@kria>
 <20140324180033.GM19349@intel.com>
 <20140324181112.GN19349@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140324181112.GN19349@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-24, 20:11:12 +0200, Mika Westerberg wrote:
> On Mon, Mar 24, 2014 at 08:00:33PM +0200, Mika Westerberg wrote:
> > On Mon, Mar 24, 2014 at 04:49:44PM +0100, Sabrina Dubroca wrote:
> > > Hi,
> > > 
> > > With next-20140324, I get the BUG below when I modprobe ssb.
> > > I bisected it to aa92b6f689ac
> > > "gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()"
> > > 
> > > The device that needs ssb is:
> > > 0c:00.0 Network controller [0280]: Broadcom Corporation BCM4321 802.11a/b/g/n [14e4:4328] (rev 03)
> > >         Subsystem: Dell Wireless 1500 Draft 802.11n WLAN Mini-card [1028:000a]
> > >         Kernel driver in use: b43-pci-bridge
> > >         Kernel modules: ssb
> > > 
> > > 
> > > [   92.693606] ssb: Found chip with id 0x4321, rev 0x03 and package 0x00
> > > [   92.693649] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
> > > [   92.693675] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
> > > [   92.693699] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x04, vendor 0x4243)
> > > [   92.693723] ssb: Core 3 found: PCI (cc 0x804, rev 0x0D, vendor 0x4243)
> > > [   92.693746] ssb: Core 4 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
> > > [   92.753554] BUG: unable to handle kernel NULL pointer dereference at 00000138
> > > [   92.753760] IP: [<c126c2b3>] acpi_gpiochip_add+0x13/0x190
> > > [   92.753901] *pde = 00000000 
> > > [   92.753986] Oops: 0000 [#1] PREEMPT SMP 
> > > [   92.754125] Modules linked in: ssb(+) mmc_core netconsole nouveau mxm_wmi i2c_algo_bit drm_kms_helper ttm drm joydev mousedev tg3 coretemp kvm_intel ptp pcmcia kvm pps_core libphy dell_laptop gpio_ich rfkill yenta_socket pcmcia_rsrc intel_agp intel_gtt iTCO_wdt iTCO_vendor_support dell_wmi sparse_keymap pcmcia_core evdev agpgart dcdbas snd_hda_codec_idt snd_hda_codec_generic microcode psmouse pcspkr i2c_i801 i2c_core serio_raw lpc_ich mfd_core acpi_cpufreq ac battery thermal button wmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm video snd_timer shpchp processor snd soundcore nfs lockd sunrpc ext4 crc16 mbcache jbd2 sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix libata scsi_mod firewire_ohci firewire_core crc_itu_t uhci_hcd ehci_pci ehci_hcd usbcore usb_common
> > > [   92.756833] CPU: 0 PID: 512 Comm: modprobe Tainted: G        W     3.14.0-rc7-next-20140324-t1 #24
> > > [   92.756833] Hardware name: Dell Inc. Latitude D830                   /0UY141, BIOS A02 06/07/2007
> > > [   92.756833] task: f5799900 ti: f543e000 task.ti: f543e000
> > > [   92.756833] EIP: 0060:[<c126c2b3>] EFLAGS: 00010282 CPU: 0
> > > [   92.756833] EIP is at acpi_gpiochip_add+0x13/0x190
> > > [   92.756833] EAX: 00000000 EBX: f57824c4 ECX: 00000000 EDX: 00000000
> > > [   92.756833] ESI: f57824c4 EDI: 00000010 EBP: f543fc54 ESP: f543fc40
> > > [   92.756833]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > [   92.756833] CR0: 8005003b CR2: 00000138 CR3: 355f8000 CR4: 000007d0
> > 
> > To me looks like chip->dev is NULL. My understanding is that the GPIO core
> > wants to have it non-NULL.
> 
> Actually gpiolib seems to handle ->dev as optional. Can you try this patch
> instead? Thanks.
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index bf0f8b476696..642b2bf3360e 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -501,6 +501,9 @@ void acpi_gpiochip_add(struct gpio_chip *chip)
>  	acpi_handle handle;
>  	acpi_status status;
>  
> +	if (!chip || !chip->dev)
> +		return;
> +
>  	handle = ACPI_HANDLE(chip->dev);
>  	if (!handle)
>  		return;
> @@ -531,6 +534,9 @@ void acpi_gpiochip_remove(struct gpio_chip *chip)
>  	acpi_handle handle;
>  	acpi_status status;
>  
> +	if (!chip || !chip->dev)
> +		return;
> +
>  	handle = ACPI_HANDLE(chip->dev);
>  	if (!handle)
>  		return;

Thanks, this patch solves the problem.

-- 
Sabrina
