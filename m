Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3FOTyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 15:54:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38620 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab3FOTyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 15:54:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [BUGFIX v2 1/4] ACPI, DOCK: initialize dock subsystem before scanning PCI root buses
Date: Sat, 15 Jun 2013 22:03:48 +0200
Message-ID: <6161178.guRcsL2k7p@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51BC3C6B.9010908@gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQWOMF4HWdQRfxF68BBYC4ONcr8wOHWvVGt6Jvb_-p6S8w@mail.gmail.com> <51BC3C6B.9010908@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 15, 2013 06:05:31 PM Jiang Liu wrote:
> On 06/15/2013 02:51 PM, Yinghai Lu wrote:
> > On Fri, Jun 14, 2013 at 12:27 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> >> Changeset "3b63aaa70e1 PCI: acpiphp: Do not use ACPI PCI subdriver
> >> mechanism" causes a regression which breaks ACPI dock support,
> >> please refer to https://bugzilla.kernel.org/show_bug.cgi?id=59501
> >>
> >> The root cause is that changeset 3b63aaa70e1 changed the relative
> >> initialization order of ACPI dock subsystem and acpiphp driver,
> >> and acpiphp driver has dependency on ACPI dock subsystem's
> >> initialization result, so that acpiphp can't correctly detect ACPI
> >> dock stations now.
> >>
> >> On the other hand, ACPI dock is a built-in driver, so we could
> >> explicitly initialize it before the acpiphp driver is used.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> >> Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> >> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> >> Cc: linux-acpi@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: <stable@vger.kernel.org> # 3.9+
> >> ---
> >>  drivers/acpi/dock.c     | 7 +------
> >>  drivers/acpi/internal.h | 5 +++++
> >>  drivers/acpi/scan.c     | 1 +
> >>  3 files changed, 7 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> >> index 4fdea38..02b0563 100644
> >> --- a/drivers/acpi/dock.c
> >> +++ b/drivers/acpi/dock.c
> >> @@ -1033,7 +1033,7 @@ find_dock_and_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
> >>         return AE_OK;
> >>  }
> >>
> >> -static int __init dock_init(void)
> >> +int __init acpi_dock_init(void)
> >>  {
> >>         if (acpi_disabled)
> >>                 return 0;
> >> @@ -1062,9 +1062,4 @@ static void __exit dock_exit(void)
> >>                 dock_remove(dock_station);
> >>  }
> >>
> >> -/*
> >> - * Must be called before drivers of devices in dock, otherwise we can't know
> >> - * which devices are in a dock
> >> - */
> >> -subsys_initcall(dock_init);
> >>  module_exit(dock_exit);
> > 
> > why not remove dock_exit?
> I have a pending patchset to clean up dock driver, Rafael suggested to
> focus on bugfix first, so I will send out the clean up patchset later.

Well, you can remove dock_exit() in the same patch.  This is kind of not
directly related to the fix, but since you're changing it from modular to
non-modular, it'd be prudent to remove all of the "modular" code in the
process.

Thanks,
Rafael


> >> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> >> index 297cbf4..c610a76 100644
> >> --- a/drivers/acpi/internal.h
> >> +++ b/drivers/acpi/internal.h
> >> @@ -40,6 +40,11 @@ void acpi_container_init(void);
> >>  #else
> >>  static inline void acpi_container_init(void) {}
> >>  #endif
> >> +#ifdef CONFIG_ACPI_DOCK
> >> +void acpi_dock_init(void);
> >> +#else
> >> +static inline void acpi_dock_init(void) {}
> >> +#endif
> >>  #ifdef CONFIG_ACPI_HOTPLUG_MEMORY
> >>  void acpi_memory_hotplug_init(void);
> >>  #else
> >> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >> index 44225cb..4148163 100644
> >> --- a/drivers/acpi/scan.c
> >> +++ b/drivers/acpi/scan.c
> >> @@ -2045,6 +2045,7 @@ int __init acpi_scan_init(void)
> >>         acpi_lpss_init();
> >>         acpi_container_init();
> >>         acpi_memory_hotplug_init();
> >> +       acpi_dock_init();
> >>
> >>         mutex_lock(&acpi_scan_lock);
> >>         /*
> >> --
> >> 1.8.1.2
> >>
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
