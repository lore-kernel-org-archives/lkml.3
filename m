Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3LaUt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 15:49:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59482 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756482Ab3LaUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 15:49:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to avoid sysfs warnings
Date: Tue, 31 Dec 2013 22:03:33 +0100
Message-ID: <6023795.zgEUjY5fWb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.13.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQVEqnWm1j0GckuNsD_FTPxWahZpCnF79sNgKN-JnCDT+w@mail.gmail.com>
References: <37552283.kG1L4S8Daa@vostro.rjw.lan> <31566676.sHXhScpSQ6@vostro.rjw.lan> <CAE9FiQVEqnWm1j0GckuNsD_FTPxWahZpCnF79sNgKN-JnCDT+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 31, 2013 10:45:46 AM Yinghai Lu wrote:
> On Mon, Dec 30, 2013 at 5:15 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, December 30, 2013 01:51:28 PM Rafael J. Wysocki wrote:
> >> > We have patches that need to stop ioapic and iommu between
> >> > pci_stop_root_bus and pci_remove_root_bus.
> >
> > BTW, what *exactly* do they need to be stopped between?  After these two patches:
> 
> need to stop regular pci drivers before stop "driver" for ioapic/dmar.
> 
> >
> >> > Please check if the problem still happen after
> >> >
> >> > http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/patch/?id=c4a0a5d964e90b93eb4101c3927b788e083e530f
> >> >
> >> > http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/patch/?id=e3b439e1d315aff59c1b4f0fc43c5cd2d82b4138
> >
> > pci_stop_root_bus() is just a walk over devices on the root bus stopping
> > them and pci_remove_root_bus() starts with the removal of those devices.
> >
> > Surely, those two list walks can be combined into one?
> 
> maybe ok, but we have to problem to make sure stop pci drivers before
> "driver" for ioapic/dmar.

That's fine, but ioapic/dmar stopping need not happen between the stopping of
drivers and removing of devices on the root bus I suppose?

Actually, I think that the ioapic/dmar stopping should be carried out after
removing all of the root bus devices, or it can be racy with respect to a
driver reload.  Isn't that the case?

> also stop all first and remove all make it much cleaner.

Well, I don't think that's worth special casing, though, because device removal
may be triggered via sysfs anyway for any PCI device.  In my opinion it would
be cleaner to use pci_stop_and_remove_bus_device() everywhere for PCI device
removal.

> and add path is two steps too. Add them all, and then attach driver for all.

The removal need not mirror the probing ...

Thanks,
Rafael

