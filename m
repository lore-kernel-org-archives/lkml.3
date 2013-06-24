Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3FXAa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 20:30:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48464 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab3FXAa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 20:30:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <liuj97@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Update][PATCH 3/3] ACPI / dock / PCI: Synchronous handling of dock events for PCI devices
Date: Mon, 24 Jun 2013 02:40:22 +0200
Message-ID: <5632059.07cB6QdEcB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUJh-u-yimuGpFiOO_-L7=+V-57W0Tn+cgR3ru=PQ+xvw@mail.gmail.com>
References: <2737587.I0nULev1kj@vostro.rjw.lan> <1528326.6SFofebmNT@vostro.rjw.lan> <CAE9FiQUJh-u-yimuGpFiOO_-L7=+V-57W0Tn+cgR3ru=PQ+xvw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 23, 2013 04:04:52 PM Yinghai Lu wrote:
> On Sun, Jun 23, 2013 at 2:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, June 23, 2013 01:29:19 PM Yinghai Lu wrote:
> >> On Sun, Jun 23, 2013 at 12:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> > On Sun, Jun 23, 2013 at 8:54 AM, Jiang Liu <liuj97@gmail.com> wrote:
> >> >> On 06/23/2013 05:25 AM, Rafael J. Wysocki wrote:
> >> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> >>>
> >> >>> The interactions between the ACPI dock driver and the ACPI-based PCI
> >> >>> hotplug (acpiphp) are currently problematic because of ordering
> >> >>> issues during hot-remove operations.
> >> >>>
> >> >>> First of all, the current ACPI glue code expects that physical
> >> >>> devices will always be deleted before deleting the companion ACPI
> >> >>> device objects.  Otherwise, acpi_unbind_one() will fail with a
> >> >>> warning message printed to the kernel log, for example:
> >> >>>
> >> >>> [  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
> >> >>> [  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
> >> >>> [  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
> >> >>> [  180.013656]  port1: Oops, 'acpi_handle' corrupt
> >> >>>
> >> >> [...]
> >> >>> @@ -597,15 +654,11 @@ register_hotplug_dock_device(acpi_handle
> >> >>>                * ops
> >> >>>                */
> >> >>>               dd = find_dock_dependent_device(dock_station, handle);
> >> >>> -             if (dd) {
> >> >>> -                     dd->ops = ops;
> >> >>> -                     dd->context = context;
> >> >>> -                     dock_add_hotplug_device(dock_station, dd);
> >> >>> -                     ret = 0;
> >> >>> -             }
> >> >>> +             if (dd)
> >> >>> +                     return dock_init_hotplug(dd, ops, context,
> >> >>> +                                              init, release);
> >> >> Hi Rafael,
> >> >>         Seems not an equivalent change. According to the comment just above the
> >> >> code, we shouldn't return but continue here.
> >> >> /*
> >> >>  * An ATA bay can be in a dock and itself can be ejected
> >> >>  * separately, so there are two 'dock stations' which need the
> >> >>  * ops
> >> >>  */
> >> >
> >> > two dock stations:
> >> > Do you mean two dock station has same handle?
> >> >
> >> > dock_add should add correctly flags for IS_DOCK and IS_ATA.
> >> > if one handle has _DCK and _GTF etc.
> >> >
> >> > or do you mean there are two dependent devices with same handle?
> >> > like one is for acpiphp slot and one is for ATA?
> >>
> >> related commit:
> >> commit 61b836958371c717d1e6d4fea1d2c512969ad20b
> >> Author: Shaohua Li <shaohua.li@intel.com>
> >> Date:   Thu Aug 28 10:07:14 2008 +0800
> >>
> >>     dock: fix for ATA bay in a dock station
> >>
> >>     an ATA bay can be in a dock and itself can be ejected separately.
> >>     This patch handles such eject bay. Found by Holger.
> >>
> >>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> >>     Signed-off-by: Len Brown <len.brown@intel.com>
> >> @@ -618,16 +619,21 @@ register_hotplug_dock_device(acpi_handle handle, struct ac
> >> pi_dock_ops *ops,
> >>          * this would include the dock station itself
> >>          */
> >>         list_for_each_entry(dock_station, &dock_stations, sibiling) {
> >> +               /*
> >> +                * An ATA bay can be in a dock and itself can be ejected
> >> +                * seperately, so there are two 'dock stations' which need the
> >> +                * ops
> >> +                */
> >>                 dd = find_dock_dependent_device(dock_station, handle);
> >>                 if (dd) {
> >>                         dd->ops = ops;
> >>                         dd->context = context;
> >>                         dock_add_hotplug_device(dock_station, dd);
> >> -                       return 0;
> >> +                       ret = 0;
> >>                 }
> >>         }
> >>
> >> -       return -EINVAL;
> >> +       return ret;
> >>  }
> >>
> >> so two doc station with different handle.
> >>
> >> and dependent devices in both...
> >>
> >> looks like Rafael's change can not handle this case anymore.
> >
> > Ah, I overlooked the fact that each dock station is on its own dependent_list
> > and can also be on another dock station's dependent_list.  I'm not sure if that
> > makes sense, but let's not break the backwards compatibility here.
> 
> wonder if dock_release_hotplug with second dock_station and dd will
> have problem.
> 
> as first one dock_station/dd, could have hp_context release already,
> then second one could all release(context) again....
> 
> so looks like dock_release_hotplug should go over dock_station/dd list
> to clear hp_context in other dock_station/... if they are the same?

I'm not sure what you mean.  They are different dependent_device objects
and each of them has its own context pointer, although they both will point to
the same thing.

Both "init" and "release" will be called for each of them individually which
for for acpiphp (which is the only user of that ATM) actually means "get" and
"put", so it should be OK.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
