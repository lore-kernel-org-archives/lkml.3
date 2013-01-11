Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3AKMBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:01:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37704 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab3AKMBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:01:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Yinghai Lu <yinghai@kernel.org>, Myron Stowe <mstowe@redhat.com>,
        Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>,
        bhelgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 3/6] ACPI/pci_slot: update PCI slot information when PCI hotplug event happens
Date: Fri, 11 Jan 2013 13:07:07 +0100
Message-ID: <5909244.EGY0dYuDSG@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50EFF27F.6030802@fold.natur.cuni.cz>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <1410202.K95a8u1BYT@vostro.rjw.lan> <50EFF27F.6030802@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 12:07:43 PM Martin Mokrejs wrote:
> Hi,
>   I just hit this thread in my bloated Inbox.
> 
> Rafael J. Wysocki wrote:
> > On Thursday, January 10, 2013 03:03:53 PM Yinghai Lu wrote:
> >> On Thu, Jan 10, 2013 at 1:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> Well, I don't see what functional problems that can bring.
> >>>
> >>> In theory people may want to have them as modules to avoid loading them on
> >>> systems that don't use PCI hotplug, but honestly I think that the complexity
> >>> this causes us to deal with is not worth it.
> >>>
> >>> Moreover, removing the modularity may actually allow us to solve some ordering
> >>> issues once and for good.
> >>
> >> No, the world is not really ideal yet.
> >>
> >> looks like laptops have problem with pci express cards.
> >>
> >> when pciehp is used, surprise insert/removal does not work because
> >> PresDect does not change properly, so no interrupt is generated.
> >> --- i suspects that is silicon problem.
> 
> That's what seemed to be the conclusion half a year ago around 3.2.x/3.3.x
> for my issues as well (SandyBridge C6/C200 chipset).
> 
> >>
> >> but when acpiphp is used, that surprise  insert/removal is working.
> 
> That's what I discovered few days ago as well. However, there are still some
> differences between individual express cards and I just need to find some time to
> dig through the data I collected.
> 
> >>
> >> some laptop like thinkpad, just don't give osc to kernel..
> >> [    0.505117]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> >> [    0.505413]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT),
> >> returned control mask: 0x0d
> >> [    0.505517] ACPI _OSC control for PCIe not granted, disabling ASPM
> >>
> >> and other laptop give that to kernel, in recent kernel will not give
> >> acpiphp to have that slot, because it want to hold that for pciehp.
> >> poor user have to pass 'pci_aspm=off" to disable _OSC for all.
> >> --- please check the mail that i forward to you yesterday.
> > 
> > Yes, this is a bug, but I'm not sure how to fix it yet.
> 
> Looks like what I see with Dell Vostro 3550 as well.
> 
> > 
> >> Anyway, we do need to let the user to have choice to use acpiphp and pciehp.
> >> and it should be first come and first serve policy.
> > 
> > And that's why you think they should be modules?  I disagree if so.
> 
> For me it is easier to cold boot with a card plugged in and fiddle later with
> hotplug if I want to unload the card. Until that, I can inspect wheteher PresDet
> really reports the card is in, and the see if system reports same after loading
> acpiphp or pciehp. I wouldn't drop the possibility to have them as modules, at
> least for now when finally we have some clue what is going on and can load the
> modules as we want while chasing the bugs.

The problem with modules is that the initialization ordering depends on the
order in which the modules are loaded.  If there are two modules, there are 2
different ways, if there are 3 modules, there are 6 ways and so on.  You get
the idea. :-)

Now, we need to take all of the possible orderings in the code and that's
quite complicated.  Also it is easy to leave one ordering untested if the
distro you use for testing happens to prefer a different one.  So the fact that
they are modules very well may be the _source_ of the problems you're seeing.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
