Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3LMWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:16:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53387 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3LMWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:16:24 -0500
Date: Fri, 13 Dec 2013 15:16:16 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Betty Dall <betty.dall@hp.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI AER: Handle non-AER HEST error sources in
 aer_hest_parse()
Message-ID: <20131213221616.GC6746@google.com>
References: <1386948196-9409-1-git-send-email-betty.dall@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386948196-9409-1-git-send-email-betty.dall@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 08:23:16AM -0700, Betty Dall wrote:
> aer_hest_parse() could pass a non-AER HEST error source to the function
> hest_match_pci(). hest_match_pci() assumes that the HEST error source is
> type ACPI_HEST_TYPE_AER_ROOT_PORT, ACPI_HEST_TYPE_AER_ENDPOINT, or
> ACPI_HEST_TYPE_AER_BRIDGE. I have a platform that has some
> ACPI_HEST_TYPE_GENERIC error sources where hest_match_pci() was trying to
> access the structure as if it had the acpi_hest_aer_common fields.
> 
> aer_hest_parse() is only ever interested in the AER type HEST error
> sources. Add a check on the type of the error souce at the beginning of
> aer_hest_parse().
> 
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
> 
>  drivers/pci/pcie/aer/aerdrv_acpi.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index cf611ab..39186e3 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -56,6 +56,10 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>  	struct acpi_hest_aer_common *p;
>  	int ff;
>  
> +	if (hest_hdr->type != ACPI_HEST_TYPE_AER_ROOT_PORT &&
> +		hest_hdr->type != ACPI_HEST_TYPE_AER_ENDPOINT &&
> +		hest_hdr->type != ACPI_HEST_TYPE_AER_BRIDGE)
> +		return 0;
>  	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
>  	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>  	if (p->flags & ACPI_HEST_GLOBAL) {

Hi Betty,

I propose the following tweaked version.  Will this work for you?


PCI/AER: Ingore non-PCIe AER error sources in aer_hest_parse()

From: Betty Dall <betty.dall@hp.com>

aer_set_firmware_first() searches the HEST for an error source descriptor
matching the specified PCI device.  It uses the apei_hest_parse() iterator
to call aer_hest_parse() for every descriptor in the HEST.

Previously, aer_hest_parse() incorrectly assumed every descriptor was for a
PCIe error source.  This patch adds a check to avoid that error.

[bhelgaas: factor check into helper function, changelog]
Signed-off-by: Betty Dall <betty.dall@hp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pcie/aer/aerdrv_acpi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index cf611ab2193a..f670313479ee 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -50,12 +50,24 @@ struct aer_hest_parse_info {
 	int firmware_first;
 };
 
+static int hest_source_is_pcie_aer(struct acpi_hest_header *hest_hdr)
+{
+	if (hest_hdr->type == ACPI_HEST_TYPE_AER_ROOT_PORT ||
+	    hest_hdr->type == ACPI_HEST_TYPE_AER_ENDPOINT ||
+	    hest_hdr->type == ACPI_HEST_TYPE_AER_BRIDGE)
+		return 1;
+	return 0;
+}
+
 static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 {
 	struct aer_hest_parse_info *info = data;
 	struct acpi_hest_aer_common *p;
 	int ff;
 
+	if (!hest_source_is_pcie_aer(hest_hdr))
+		return 0;
+
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
 	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
 	if (p->flags & ACPI_HEST_GLOBAL) {
