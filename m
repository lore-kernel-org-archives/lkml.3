Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3ALVd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:33:27 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39079 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3ALVd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:33:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 04/22] PCI: Fix a device reference count leakage issue in pci_dev_present()
Date: Sat, 12 Jan 2013 22:39:14 +0100
Message-ID: <3629201.dfk0t3lWhY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-5-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:31 PM Yinghai Lu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Function pci_get_dev_by_id() will hold a reference count on the pci device
> returned, so pci_dev_present() should release the corresponding reference
> count to avoid memory leakage.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/search.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index bf969ba..d0627fa 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -319,13 +319,13 @@ int pci_dev_present(const struct pci_device_id *ids)
>  	WARN_ON(in_interrupt());
>  	while (ids->vendor || ids->subvendor || ids->class_mask) {
>  		found = pci_get_dev_by_id(ids, NULL);
> -		if (found)
> -			goto exit;
> +		if (found) {
> +			pci_dev_put(found);
> +			return 1;
> +		}
>  		ids++;
>  	}
> -exit:
> -	if (found)
> -		return 1;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(pci_dev_present);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
