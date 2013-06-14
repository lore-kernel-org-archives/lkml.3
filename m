Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3FNMbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:31:03 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47211 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FNMbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <2301639.HY0nSRLtah@vostro.rjw.lan>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<1371141152-9468-3-git-send-email-jiang.liu@huawei.com>
	<2448481.HbOiE9Npmq@vostro.rjw.lan>
	<2301639.HY0nSRLtah@vostro.rjw.lan>
Date: Fri, 14 Jun 2013 18:30:58 +0600
Message-ID: <CAN_LGv1_b16XDAS-hrP2w=ERBgJ+V+P3kgKrksR0qO3navXiOg@mail.gmail.com>
Subject: Re: [BUGFIX 2/9] ACPIPHP: fix device destroying order issue when
 handling dock notification
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/14 Rafael J. Wysocki <rjw@sisk.pl>:

> What about the appended patch (on top of [1/9], untested)?
>
> Rafael

Sorry, I have lost the track of which patches, on top of 3.10-rc5, I
should include in my testing and which I shouldn't. Could you please
restore my understanding? I.e., please provide a full list of LKML or
Bugzilla links to patches which I should test during the next boot of
the laptop.

Thanks in advance.

> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -145,9 +145,20 @@ static int post_dock_fixups(struct notif
>         return NOTIFY_OK;
>  }
>
> +static void handle_dock_event_func(acpi_handle handle, u32 event, void *context)
> +{
> +       if (event == ACPI_NOTIFY_EJECT_REQUEST) {
> +               struct acpiphp_func *func = context;
> +
> +               if (!acpiphp_disable_slot(func->slot))
> +                       acpiphp_eject_slot(func->slot);
> +       } else {
> +               handle_hotplug_event_func(handle, event, context);
> +       }
> +}
>
>  static const struct acpi_dock_ops acpiphp_dock_ops = {
> -       .handler = handle_hotplug_event_func,
> +       .handler = handle_dock_event_func,
>  };
>
>  /* Check whether the PCI device is managed by native PCIe hotplug driver */
>



--
Alexander E. Patrakov
