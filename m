Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3LMWrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:47:55 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41604 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3LMWrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:47:39 -0500
Message-ID: <1386974853.10497.64.camel@ejdallLaptop>
Subject: Re: [PATCH] PCI AER: Handle non-AER HEST error sources in
 aer_hest_parse()
From: Betty Dall <betty.dall@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Fri, 13 Dec 2013 15:47:33 -0700
In-Reply-To: <20131213221616.GC6746@google.com>
References: <1386948196-9409-1-git-send-email-betty.dall@hp.com>
	 <20131213221616.GC6746@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 15:16 -0700, Bjorn Helgaas wrote:
> On Fri, Dec 13, 2013 at 08:23:16AM -0700, Betty Dall wrote:
> > aer_hest_parse() could pass a non-AER HEST error source to the function
> > hest_match_pci(). hest_match_pci() assumes that the HEST error source is
> > type ACPI_HEST_TYPE_AER_ROOT_PORT, ACPI_HEST_TYPE_AER_ENDPOINT, or
> > ACPI_HEST_TYPE_AER_BRIDGE. I have a platform that has some
> > ACPI_HEST_TYPE_GENERIC error sources where hest_match_pci() was trying to
> > access the structure as if it had the acpi_hest_aer_common fields.
> > 
> > aer_hest_parse() is only ever interested in the AER type HEST error
> > sources. Add a check on the type of the error souce at the beginning of
> > aer_hest_parse().
> > 
> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > ---
> > 
> >  drivers/pci/pcie/aer/aerdrv_acpi.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> > index cf611ab..39186e3 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> > @@ -56,6 +56,10 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
> >  	struct acpi_hest_aer_common *p;
> >  	int ff;
> >  
> > +	if (hest_hdr->type != ACPI_HEST_TYPE_AER_ROOT_PORT &&
> > +		hest_hdr->type != ACPI_HEST_TYPE_AER_ENDPOINT &&
> > +		hest_hdr->type != ACPI_HEST_TYPE_AER_BRIDGE)
> > +		return 0;
> >  	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
> >  	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
> >  	if (p->flags & ACPI_HEST_GLOBAL) {
> 
> Hi Betty,
> 
> I propose the following tweaked version.  Will this work for you?
> 
> 
> PCI/AER: Ingore non-PCIe AER error sources in aer_hest_parse()
> 
> From: Betty Dall <betty.dall@hp.com>
> 
> aer_set_firmware_first() searches the HEST for an error source descriptor
> matching the specified PCI device.  It uses the apei_hest_parse() iterator
> to call aer_hest_parse() for every descriptor in the HEST.
> 
> Previously, aer_hest_parse() incorrectly assumed every descriptor was for a
> PCIe error source.  This patch adds a check to avoid that error.
> 
> [bhelgaas: factor check into helper function, changelog]
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_acpi.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index cf611ab2193a..f670313479ee 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -50,12 +50,24 @@ struct aer_hest_parse_info {
>  	int firmware_first;
>  };
>  
> +static int hest_source_is_pcie_aer(struct acpi_hest_header *hest_hdr)
> +{
> +	if (hest_hdr->type == ACPI_HEST_TYPE_AER_ROOT_PORT ||
> +	    hest_hdr->type == ACPI_HEST_TYPE_AER_ENDPOINT ||
> +	    hest_hdr->type == ACPI_HEST_TYPE_AER_BRIDGE)
> +		return 1;
> +	return 0;
> +}
> +
>  static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>  {
>  	struct aer_hest_parse_info *info = data;
>  	struct acpi_hest_aer_common *p;
>  	int ff;
>  
> +	if (!hest_source_is_pcie_aer(hest_hdr))
> +		return 0;
> +
>  	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
>  	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>  	if (p->flags & ACPI_HEST_GLOBAL) {

Hi Bjorn,

Yes, that is more readable code. Thanks for revising it. I tested it on
my system that has non-AER error sources and it works fine. One nit is
that "Ignore" is misspelled in the subject line. 

-Betty


