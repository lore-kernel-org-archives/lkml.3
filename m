Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3LSSWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:22:45 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:62518 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3LSSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:22:43 -0500
MIME-Version: 1.0
In-Reply-To: <1387456702-4709-4-git-send-email-jiang.liu@linux.intel.com>
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com> <1387456702-4709-4-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Dec 2013 11:22:22 -0700
Message-ID: <CAErSpo4oKsJCKxUhxT8E745BkX+veOD-tMEeHULHOuH-3suMRA@mail.gmail.com>
Subject: Re: [Patch v2 03/13] PCI, pci-label: release allocated ACPI object on
 error recovery path
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 5:38 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Function dsm_get_label() leaks the returned ACPI object if
> obj->package.count is not 2, so fix the possible memory leak.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Rafael, if you want to take these through your tree, feel free.  I'm
guessing it probably makes sense to keep the whole series together.

> ---
>  drivers/pci/pci-label.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
> index d51f45a..f6e01a5 100644
> --- a/drivers/pci/pci-label.c
> +++ b/drivers/pci/pci-label.c
> @@ -233,11 +233,7 @@ dsm_get_label(acpi_handle handle, int func,
>                 return -1;
>
>         obj = (union acpi_object *)output->pointer;
> -
> -       switch (obj->type) {
> -       case ACPI_TYPE_PACKAGE:
> -               if (obj->package.count != 2)
> -                       break;
> +       if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2) {
>                 len = obj->package.elements[0].integer.value;
>                 if (buf) {
>                         if (attribute == ACPI_ATTR_INDEX_SHOW)
> @@ -250,10 +246,10 @@ dsm_get_label(acpi_handle handle, int func,
>                 }
>                 kfree(output->pointer);
>                 return len;
> -       break;
> -       default:
> -               kfree(output->pointer);
>         }
> +
> +       kfree(output->pointer);
> +
>         return -1;
>  }
>
> --
> 1.7.10.4
>
