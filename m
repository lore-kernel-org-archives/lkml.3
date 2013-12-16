Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3LPPv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:51:58 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:35041 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:51:56 -0500
Date: Mon, 16 Dec 2013 10:51:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ahci: only attach ICH6-M if it's in SATA mode
Message-ID: <20131216155136.GF32509@htj.dyndns.org>
References: <1387190097.9255.31.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387190097.9255.31.camel@x41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Mon, Dec 16, 2013 at 11:34:57AM +0100, Paul Bolle wrote:
> Intel's ICH6-M can operate either in IDE mode or in SATA mode. Attaching
> in IDE mode is pointless (and should fail, as long as BIOS has configured
> it even remotely sane). So let's only attach in SATA mode.
> 
> Note that ata_piix does the opposite: only attach if ICH6-M is in IDE
> mode, so we end up with just one driver attaching in either mode.
> 
> (And since we're touching this table update a minor typo too.)
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested on an ICH6-M that always runs in IDE mode. So I'm not certain
> this does the right thing for a ICH6-M running in SATA mode. 
> 
>  drivers/ata/ahci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 4ba3bde..12182fd 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -191,8 +191,10 @@ static const struct ata_port_info ahci_port_info[] = {
>  
>  static const struct pci_device_id ahci_pci_tbl[] = {
>  	/* Intel */
> -	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6 */
> -	{ PCI_VDEVICE(INTEL, 0x2653), board_ahci }, /* ICH6M */
> +	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6R */
> +	/* ICH6M Attach iff the controller is in SATA mode. */
> +	{ PCI_VENDOR_ID_INTEL, 0x2653, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_STORAGE_SATA << 8, 0xffff00, board_ahci },

I'm not quite sure about this one.  The patch seems correct on the
surface but given how old ich6 is at this point, the general
crappiness of BIOS on ahci front in that era, and that the existing
code has been working fine for all these years make me very reluctant
to change it.  e.g. I don't think CLASS_STORAGE_SATA was the only one.
They used different class for raid too.  It should be able to figure
out things given enough test cases but I don't think we have that
anymore and the benefit (avoding probe failure messages) doesn't seem
to justify the risk.

Thanks.

-- 
tejun
