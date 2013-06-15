Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3FOGvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 02:51:40 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44134 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3FOGvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 02:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <1371238081-32260-2-git-send-email-jiang.liu@huawei.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
	<1371238081-32260-2-git-send-email-jiang.liu@huawei.com>
Date: Fri, 14 Jun 2013 23:51:38 -0700
X-Google-Sender-Auth: 0_lsQpw4wJJQmx62ZyoGdRTQR6M
Message-ID: <CAE9FiQWOMF4HWdQRfxF68BBYC4ONcr8wOHWvVGt6Jvb_-p6S8w@mail.gmail.com>
Subject: Re: [BUGFIX v2 1/4] ACPI, DOCK: initialize dock subsystem before
 scanning PCI root buses
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:27 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> Changeset "3b63aaa70e1 PCI: acpiphp: Do not use ACPI PCI subdriver
> mechanism" causes a regression which breaks ACPI dock support,
> please refer to https://bugzilla.kernel.org/show_bug.cgi?id=59501
>
> The root cause is that changeset 3b63aaa70e1 changed the relative
> initialization order of ACPI dock subsystem and acpiphp driver,
> and acpiphp driver has dependency on ACPI dock subsystem's
> initialization result, so that acpiphp can't correctly detect ACPI
> dock stations now.
>
> On the other hand, ACPI dock is a built-in driver, so we could
> explicitly initialize it before the acpiphp driver is used.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 3.9+
> ---
>  drivers/acpi/dock.c     | 7 +------
>  drivers/acpi/internal.h | 5 +++++
>  drivers/acpi/scan.c     | 1 +
>  3 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 4fdea38..02b0563 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -1033,7 +1033,7 @@ find_dock_and_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
>         return AE_OK;
>  }
>
> -static int __init dock_init(void)
> +int __init acpi_dock_init(void)
>  {
>         if (acpi_disabled)
>                 return 0;
> @@ -1062,9 +1062,4 @@ static void __exit dock_exit(void)
>                 dock_remove(dock_station);
>  }
>
> -/*
> - * Must be called before drivers of devices in dock, otherwise we can't know
> - * which devices are in a dock
> - */
> -subsys_initcall(dock_init);
>  module_exit(dock_exit);

why not remove dock_exit?

> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 297cbf4..c610a76 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -40,6 +40,11 @@ void acpi_container_init(void);
>  #else
>  static inline void acpi_container_init(void) {}
>  #endif
> +#ifdef CONFIG_ACPI_DOCK
> +void acpi_dock_init(void);
> +#else
> +static inline void acpi_dock_init(void) {}
> +#endif
>  #ifdef CONFIG_ACPI_HOTPLUG_MEMORY
>  void acpi_memory_hotplug_init(void);
>  #else
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 44225cb..4148163 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -2045,6 +2045,7 @@ int __init acpi_scan_init(void)
>         acpi_lpss_init();
>         acpi_container_init();
>         acpi_memory_hotplug_init();
> +       acpi_dock_init();
>
>         mutex_lock(&acpi_scan_lock);
>         /*
> --
> 1.8.1.2
>
