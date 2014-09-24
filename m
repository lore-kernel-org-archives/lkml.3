Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaIXXsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:48:25 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60770 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaIXXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:48:23 -0400
Date: Wed, 24 Sep 2014 17:48:19 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has
 64bit mmio
Message-ID: <20140924234819.GF20416@google.com>
References: <CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
 <CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
 <CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
 <52A8BAC5.70006@canonical.com>
 <CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
 <52D01D82.5070202@canonical.com>
 <CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
 <54189BCE.2010206@canonical.com>
 <CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
 <CAE9FiQWphiORhaVNNVGZXY6eYxLH2QYNbHcLdjzrBD98tMKz0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWphiORhaVNNVGZXY6eYxLH2QYNbHcLdjzrBD98tMKz0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:46:24AM -0700, Yinghai Lu wrote:
> On Tue, Sep 16, 2014 at 3:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Tue, Sep 16, 2014 at 1:21 PM, Joseph Salisbury
> > <joseph.salisbury@canonical.com> wrote:
> >>
> >> A new bug[0] was opened due to enabling PCI_REALLOC_ENABLE_AUTO, which
> >> is similar to the original bug[1] we discussed.
> >>
> >> Just wondering if there have been any additional ideas on realloc since
> >> this was last discussed?
> >>
> >> [0] http://pad.lv/1363313
> >
> > So the resource realloc do work as expected. but LSI firmware has some
> > problem again?
> >
> > We may need to add command after the reset the bridge resource.
> 
> Can you try attached patch?

This sitting in patchwork, but I'm dropping it because there's no changelog
or signed-off-by.  I don't think the underlying bug has been resolved,
though.

Bjorn

> ---
>  drivers/pci/setup-bus.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -1615,6 +1615,22 @@ again:
>  						 fail_res->flags & type_mask,
>  						 rel_type);
>  
> +	/* reset LSI device */
> +	list_for_each_entry(fail_res, &fail_head, list) {
> +		struct pci_dev *pdev;
> +		struct pci_bus *pbus = fail_res->dev->bus;
> +
> +		if (pci_is_root_bus(pbus) || !pbus->self)
> +			continue;
> +
> +		/* LSI device firmware is not happy with changing BAR value */
> +		list_for_each_entry(pdev, &pbus->devices, bus_list)
> +			if (pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC) {
> +				pci_reset_secondary_bus(pbus->self);
> +				break;
> +			}
> +	}
> +
>  	/* restore size and flags */
>  	list_for_each_entry(fail_res, &fail_head, list) {
>  		struct resource *res = fail_res->res;

