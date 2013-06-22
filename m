Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab3FVVnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:43:31 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:32783 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3FVVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:43:29 -0400
MIME-Version: 1.0
X-Originating-IP: [178.150.189.253]
In-Reply-To: <2737587.I0nULev1kj@vostro.rjw.lan>
References: <2737587.I0nULev1kj@vostro.rjw.lan>
From: Illya Klymov <xanf@xanf.me>
Date: Sun, 23 Jun 2013 00:43:08 +0300
Message-ID: <CALSWrKhdDAEPJE7xXcWx4ZqqJe-B+okyJfAwx=viR+saR0ZYkw@mail.gmail.com>
Subject: Re: [PATCH 0/3] ACPI / dock / PCI: Fix problems with dock and PCI hotplug
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys. Sorry for entering your talk
I have a Sony Vaio SVZ1311Z9RXI and just tested your patched against
3.10-rc7 and they work like a charm
scenarios tested:
- boot with dock
- boot without dock, hotplug dock
- dock / undock / redock

All devices tested to be working in all 3 cases:
- video card
- ethernet controller
- blue ray drive
- USB controller

Thank you a lot!

On Sun, Jun 23, 2013 at 12:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi All,
>
> Unfortunately, the Alexander's docking station for Sony VAIO VPCZ23A4R is
> basically unusable with v3.10-rc6 and, as it turns out, there are multiple
> problems with it.
>
> First, the acpiphp initialization ordering has changed recently,
> acpiphp_enumerate_slots() is now always run for the first time during the
> initial ACPI namespace scan in acpi_scan_init() which has broken support
> for PCI devices on ACPI-based docking stations, because the ACPI dock
> subsystem has to be initialized *before* acpiphp_enumerate_slots() is first
> run.
>
> Fix that, and it turns out that undocking actually doesn't work correctly
> because of some synchronization problems between the dock driver, acpiphp
> and the PCI core.  [That part was actually the most difficult to fix.]
>
> Fix that, and you'll find that PCI resources are not allocated correctly
> after undocking and re-docking (when initially docked).
>
> The three patches in this series make the Alexander's docking station kind
> of usable, so if no one has objections, I'd like to put them on a fast track
> to Linus.
>
> [1/3] Initialize ACPI dock subsystem before enumerating the PCI hierarchy
>       (that also makes the dock driver non-modular).
>
> [2/3] Make acpiphp use the same rules for allocating PCI resources that are
>       used at boot time.
>
> [3/3] Make acpiphp handle dock events synchronously (instead of spawning
>       separate work items to handle them).  [The changelog of this patch
>       is likely one of the longest I've ever written and it sort of looks
>       like a crime story.]
>
> This series is mostly based on the work of Jiang Liu (thanks Gerry!) and
> the Alexander's testing that we wouldn't have done much progress without
> (thanks Alexander!).
>
> Alexander, I've modified patch [3/3] a bit since you have tested it.
> The modifications shouldn't affect the behavior, but if you could re-test it,
> that would be great.
>
> Thanks,
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
