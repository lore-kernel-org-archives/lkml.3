Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaAISJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:09:04 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50891 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaAISJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:09:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140109153513.21446.31778.stgit@bling.home>
References: <20140109153513.21446.31778.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 Jan 2014 11:08:38 -0700
Message-ID: <CAErSpo4Asnx4JiZvppZLUzxmVymz0t-fHXRFMr81-Qz31XyR+g@mail.gmail.com>
Subject: Re: [PATCH] pci/iov: VFs are never multifunction
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        sathya.perla@emulex.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ajit.khaparde@emulex.com, Don Dutile <ddutile@redhat.com>,
        subbu.seetharaman@emulex.com, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 8:36 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Per the SR-IOV spec rev 1.1:
>
> 3.4.1.9 Header Type (Offset 0Eh)
>
> "... For VFs, this register must be RO Zero."
>
> Unfortunately some devices get this wrong, ex. Emulex OneConnect 10Gb
> NIC.  When they do it makes us handle ACS testing and therefore IOMMU
> groups as if they were actual multifunction devices and require ACS
> capabilities to make sure there's no peer-to-peer between functions.
> VFs are never traditional multifunction devices, so simply clear this
> bit before we get any further into setup.

This seems reasonable.  Do you have "lspci -vvxxxx" output for this
device?  I'd like to save it for future reference.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/iov.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 1fe2d6f..e2fbb67 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -84,6 +84,7 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
>         virtfn->dev.parent = dev->dev.parent;
>         virtfn->physfn = pci_dev_get(dev);
>         virtfn->is_virtfn = 1;
> +       virtfn->multifunction = 0;
>
>         for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
>                 res = dev->resource + PCI_IOV_RESOURCES + i;
>
