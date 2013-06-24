Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FXJp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:45:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48871 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab3FXJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:45:56 -0400
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
Date: Mon, 24 Jun 2013 11:55:22 +0200
Message-ID: <1508248.YJkd4pGgsJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVATSK+apf0qmQPuf7SQuEuXx6Wm1GtdKuakMGsfZ8c9A@mail.gmail.com>
References: <2737587.I0nULev1kj@vostro.rjw.lan> <5632059.07cB6QdEcB@vostro.rjw.lan> <CAE9FiQVATSK+apf0qmQPuf7SQuEuXx6Wm1GtdKuakMGsfZ8c9A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 23, 2013 09:34:09 PM Yinghai Lu wrote:
> On Sun, Jun 23, 2013 at 5:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, June 23, 2013 04:04:52 PM Yinghai Lu wrote:
> >> On Sun, Jun 23, 2013 at 2:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
> >> > Ah, I overlooked the fact that each dock station is on its own dependent_list
> >> > and can also be on another dock station's dependent_list.  I'm not sure if that
> >> > makes sense, but let's not break the backwards compatibility here.
> >>
> >> wonder if dock_release_hotplug with second dock_station and dd will
> >> have problem.
> >>
> >> as first one dock_station/dd, could have hp_context release already,
> >> then second one could all release(context) again....
> >>
> >> so looks like dock_release_hotplug should go over dock_station/dd list
> >> to clear hp_context in other dock_station/... if they are the same?
> >
> > I'm not sure what you mean.  They are different dependent_device objects
> > and each of them has its own context pointer, although they both will point to
> > the same thing.
> >
> > Both "init" and "release" will be called for each of them individually which
> > for for acpiphp (which is the only user of that ATM) actually means "get" and
> > "put", so it should be OK.
> 
> yes, then hp_context can never be  the same, just the acpi handle is the same.
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks!

> BTW, thank you very much for the whole acpi scan rework.

Well, no problem, it was necessary for a number of reasons.

And honestly I think more along those lines is still needed. :-)

For example, the discussion here shows how fragile the design of acpiphp is.
Take hotplug_dock_devices() for instance.  It shouldn't even need to use those
"handlers", because ideally acpi_bus_trim() should automatically trigger the
removal of "physical" device objects depending on the stuff being trimmed.
And analogously for acpi_bus_scan().

The "trim" part should be possible to implement even now, because
struct acpi_device contains a "remove" callback pointer (that was added for
power resources IIRC), although perhaps it'll need to be called from
acpi_bus_device_detach().  The "scan" part should be doable too if we add
an "add child" callback to struct acpi_device, so that acpi_bus_device_attach()
can use it to handle devices that don't have scan handlers or ACPI drivers
(like PCI devices).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
