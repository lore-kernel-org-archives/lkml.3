Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaIXRsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:48:09 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38794 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaIXRsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:48:05 -0400
Date: Wed, 24 Sep 2014 11:48:01 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Scott Murray <scott@spiteful.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] PCI: remove assignement in non straight forward
 if condition
Message-ID: <20140924174801.GC20416@google.com>
References: <20140907180428.GA12424@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907180428.GA12424@greed>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 08:04:28PM +0200, Quentin Lambert wrote:
> The modifications effectively change the value of len_tmp
> in the case where the first condition is not met.
> 
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
> ---
>  drivers/pci/hotplug/ibmphp_res.c | 13 +++++++++----
>  drivers/pci/pci.c                |  6 +++++-
>  drivers/pci/slot.c               | 12 ++++++++++--
>  3 files changed, 24 insertions(+), 7 deletions(-)
> ...

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 8b63a5b..4c3ef21 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4434,9 +4434,13 @@ static int __init pci_setup(char *str)
>  {
>  	while (str) {
>  		char *k = strchr(str, ',');
> +		char tmp = *str;
> +
>  		if (k)
>  			*k++ = 0;
> -		if (*str && (str = pcibios_setup(str)) && *str) {
> +
> +		str = pcibios_setup(str);
> +		if (tmp && str && *str) {

I dropped this change  because I don't think the replacement is quite
equivalent.  Previously, we only called pcibios_setup() if "*str".  The new
code calls it even if "!*str".

>  			if (!strcmp(str, "nomsi")) {
>  				pci_no_msi();
>  			} else if (!strcmp(str, "noaer")) {
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 396c200..22d20db 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -265,8 +265,16 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
>  	slot = get_slot(parent, slot_nr);
>  	if (slot) {
>  		if (hotplug) {
> -			if ((err = slot->hotplug ? -EBUSY : 0)
> -			     || (err = rename_slot(slot, name))) {
> +			err = slot->hotplug ? -EBUSY : 0;
> +			if (err)
> +				goto hotplugerror;
> +
> +			err = rename_slot(slot, name);
> +			if (err)
> +				goto hotplugerror;
> +
> +			if (0) {
> +hotplugerror:
>  				kobject_put(&slot->kobj);
>  				slot = NULL;
>  				goto err;

And I dropped this one because the code is too ugly.  Granted, the
original is probably even uglier, but if we're going to change it, I'm
going to hold out for a prettier restructuring.

Bjorn
