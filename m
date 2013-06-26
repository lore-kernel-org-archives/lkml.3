Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3FZX2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:28:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35340 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3FZX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <1372177330-28013-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-2-git-send-email-mika.westerberg@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Jun 2013 17:28:30 -0600
Message-ID: <CAErSpo4Ks+8PPvpscWZE7LrRd-daOzV-kJi6Oim42A+nZnp3HQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] PCI: acpiphp: do not check for SLOT_ENABLED in enable_device()
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> With Thunderbolt you can chain devices: connect a new devices to plugged
> one. In this case the slot is already enabled, but we still want to look
> for new devices behind it.
>
> We're going to reuse enable_device() for rescan for new devices on the
> enabled slot. Let's push the check up by stack.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 59df857..b983e29 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -688,9 +688,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>         int num, max, pass;
>         LIST_HEAD(add_list);
>
> -       if (slot->flags & SLOT_ENABLED)
> -               goto err_exit;
> -
>         list_for_each_entry(func, &slot->funcs, sibling)
>                 acpiphp_bus_add(func);
>
> @@ -1242,6 +1239,8 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
>                 goto err_exit;
>
>         if (get_slot_status(slot) == ACPI_STA_ALL) {
> +               if (slot->flags & SLOT_ENABLED)
> +                       goto err_exit;

Why do we check for SLOT_ENABLED at all?  I think we're handling a Bus
Check notification, which means "re-enumerate on the device tree
starting from the notification point."  It doesn't say anything about
skipping the re-enumeration if we find a device that's already
enabled.

It seems like we ought to just re-enumerate all the way down in case a
device was added farther down in the tree (which is what it sounds
like Thunderbolt is doing).

>                 /* configure all functions */
>                 retval = enable_device(slot);
>                 if (retval)
> --
> 1.8.3.1
>
