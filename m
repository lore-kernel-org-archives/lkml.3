Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab3BMIdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:33:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab3BMIdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:33:42 -0500
Date: Wed, 13 Feb 2013 09:32:43 +0100
From: Libor Pechacek <lpechacek@suse.cz>
To: Youquan Song <youquan.song@intel.com>
Cc: htejun@gmail.com, ming.lei@canonical.com, sshtylyov@mvista.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com, jlee@suse.com, james.d.ralston@intel.com,
        stable@vger.kernel.org, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v2] ata: Fix DVD not dectected at some Haswell platforms
Message-ID: <20130213083242.GD1106@fm.suse.cz>
References: <1359731982-1390-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359731982-1390-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Youquan Song,

On Fri 01-02-13 10:19:42, Youquan Song wrote:
> There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d 
> "ata_piix: make DVD Drive recognisable on systems with Intel Sandybridge
>  chipsets(v2)
> 
>     This quirk patch fixes one kind of bug inside some Intel Sandybridge
>     chipsets, see reports from
> 
>            https://bugzilla.kernel.org/show_bug.cgi?id=40592.
> 
>     Many guys also have reported the problem before:
> 
>         https://bugs.launchpad.net/bugs/737388
>         https://bugs.launchpad.net/bugs/794642
>         https://bugs.launchpad.net/bugs/782389
>         ......
> 
>     With help from Tejun, the problem is found to be caused by 32bit PIO
>     mode, so introduce the quirk patch to disable 32bit PIO on SATA piix
>     for some Sandybridge CPT chipsets.
> 
>     Seth also tested the patch on all five affected chipsets
>     (pci device ID: 0x1c00, 0x1c01, 0x1d00, 0x1e00, 0x1e01), and found
>     the patch does fix the problem.
> "

As to my understanding Sergei did not suggest citing the whole commit message.
I also find the numerous references to Sandy Bridge confusing as this is a fix
for Lynx Point chipset.

How about rephrasing the commit message in a way similar to the following one?
------8<-----
We've hit a problem with DVD not recognized on Haswell Desktop platform which
includes Lynx Point 2-port SATA controller.  This quirk patch disables 32bit
PIO on the controller in IDE mode.
------>8-----

> 
> Recently, the problem was shown at Haswell Desktop platform which includes 2 
> ports IDE controller.
> 
> So introduce a quirk patch to disable 32bit PIO on this IDE controller. 
> 
> v2: Change spelling error in statememnt pointed by Sergei Shtylyov.
> 
> Tested-by: Lee, Chun-Yi <jlee@suse.com>
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/ata/ata_piix.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index ef773e1..1993e52 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -150,6 +150,7 @@ enum piix_controller_ids {
>  	tolapai_sata,
>  	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
>  	ich8_sata_snb,
> +	ich8_2port_sata_snb,
>  };
>  
>  struct piix_map_db {
> @@ -326,7 +327,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
>  	/* SATA Controller IDE (Lynx Point) */
>  	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
>  	/* SATA Controller IDE (Lynx Point) */
> -	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
>  	/* SATA Controller IDE (Lynx Point) */
>  	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>  	/* SATA Controller IDE (Lynx Point-LP) */
> @@ -502,6 +503,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
>  	[ich8m_apple_sata]	= &ich8m_apple_map_db,
>  	[tolapai_sata]		= &tolapai_map_db,
>  	[ich8_sata_snb]		= &ich8_map_db,
> +	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
>  };
>  
>  static struct ata_port_info piix_port_info[] = {
> @@ -643,6 +645,16 @@ static struct ata_port_info piix_port_info[] = {
>  		.port_ops	= &piix_sata_ops,
>  	},
>  
> +	[ich8_2port_sata_snb] =
> +	{
> +		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,

The line might be worth splitting as it's over 80 characters.

Otherwise the patch looks OK to me.

Libor

> The above patch only fixing the 4 ports IDE controller 32bit PIO mode. 

> +		.pio_mask	= ATA_PIO4,
> +		.mwdma_mask	= ATA_MWDMA2,
> +		.udma_mask	= ATA_UDMA6,
> +		.port_ops	= &piix_sata_ops,
> +	},
> +
> +
>  };
>  
>  static struct pci_bits piix_enable_bits[] = {
> -- 
> 1.6.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Libor Pechacek
SUSE Labs, Prague
