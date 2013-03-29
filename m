Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3C2MYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 08:24:25 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61526 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3C2MYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 08:24:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
References: <CAE9FiQXmeb66dc8fET0y99BjqpUXp11c7utiQ5keR1Wf+N9xaA@mail.gmail.com>
 <1363628226-6679-1-git-send-email-yinghai@kernel.org> <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
 <CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
 <CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
 <CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
 <CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
 <20130329032200.GA11990@google.com> <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Mar 2013 06:24:02 -0600
Message-ID: <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
To: Yinghai Lu <yinghai@kernel.org>
Cc: Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:59 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> On Thu, Mar 28, 2013 at 8:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> [+cc Matthew]
>> [+cc e1000-devel@lists.sourceforge.net for suspected 82575/82598
>> regression]
>>
>> On Thu, Mar 28, 2013 at 01:24:55PM -0700, Yinghai Lu wrote:
>> > patch for Roman
>> >
>> > On Thu, Mar 28, 2013 at 1:24 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > > resending with adding To Roman.
>> > >
>> > > On Thu, Mar 28, 2013 at 5:46 AM, Bjorn Helgaas <bhelgaas@google.com>
>> > > wrote:
>> > >> This patch might be *safe*, but it (and the changelog) are completely
>> > >> unintelligible.
>> > >>
>> > >> The problem with applying an unintelligible stop-gap patch is that it
>> > >> becomes forever part of the changelog, and it's a huge waste of time
>> > >> to everybody who tries to understand the history later.  That's why I
>> > >> think it's worth spending some time to make a good patch now.
>> > >
>> > > Please check if attached patch is doing what you want.
>>
>> Patch inlined below for convenience.
>>
>> > Subject: [PATCH] PCI: Remove not needed check in disable aspm link
>> >
>> > Roman reported ath5k does not work anymore on 3.8.
>> > Bisected to
>> > | commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6
>> > | Author: Taku Izumi <izumi.taku@jp.fujitsu.com>
>> > | Date:   Tue Oct 30 15:27:13 2012 +0900
>> > |
>> > |    PCI/ACPI: Request _OSC control before scanning PCI root bus
>> > |
>> > |    This patch moves up the code block to request _OSC control in order
>> > to
>> > |    separate ACPI work and PCI work in acpi_pci_root_add().
>> >
>> > It make pci_disable_link_state does not work anymore as acpi_disabled
>> > is set before pci root bus scanning.
>> > It will skip that in quirks and pcie_aspm_sanity_check.
>>
>> I think this regression has nothing to do with pci_disable_link_state().
>>
>> When aspm_disabled is set, pci_disable_link_state() doesn't do anything.
>>
>> In both 3.7 and 3.8, aspm_disabled is set in acpi_pci_root_add() before
>> any driver probe routines are run, so it looks like calling
>> pci_disable_link_state() from a driver had no effect even in 3.7.  This
>> is a problem, of course, but not the one Roman is seeing, because ath5k
>> calls pci_disable_link_state() from the driver probe routine.
>>
>> There are also PCI_FIXUP_FINAL quirks for 82575 and 82598 NICs that call
>> pci_disable_link_state().  In 3.7, these quirks are run before
>> aspm_disabled is set, but 8c33f51d moved the pcie_no_aspm() call up
>> before we start scanning the bus, so in 3.8, aspm_disabled is set
>> *before* we run them.  I think that means 8c33f51d broke all these
>> quirks.  That's also a problem, of course, but this isn't the one Roman
>> is seeing either.
>>
>> I think the problem Roman is seeing happens when
>> pcie_aspm_init_link_state() calls pcie_aspm_sanity_check() during device
>> enumeration.  In 3.8, the fact that aspm_disabled is already set by the
>> time we get here means we skip the check for pre-1.1 PCIe devices, and
>> I think *this* is what Roman is seeing.
>>
>> I suspect the following hunk of your patch is enough to fix things for
>> Roman:
>>
>> > --- linux-2.6.orig/drivers/pci/pcie/aspm.c
>> > +++ linux-2.6/drivers/pci/pcie/aspm.c
>> > @@ -493,15 +492,6 @@ static int pcie_aspm_sanity_check(struct
>> >                       return -EINVAL;
>> >
>> >               /*
>> > -              * If ASPM is disabled then we're not going to change
>> > -              * the BIOS state. It's safe to continue even if it's a
>> > -              * pre-1.1 device
>> > -              */
>> > -
>> > -             if (aspm_disabled)
>> > -                     continue;
>> > -
>> > -             /*
>> >                * Disable ASPM for pre-1.1 PCIe device, we follow MS to
>> > use
>> >                * RBER bit to determine if a function is 1.1 version
>> > device
>> >                */
>>
>> However, this test was added by Matthew in c9651e70, and I can't remove
>> it unless we have an explanation of why removing it will not reintroduce
>> the bug he was fixing.
>>
>> This code is such a terrible mess that it's not surprising at all that
>> we have all these issues.  But there's too much to untangle in v3.9; all
>> we can hope for is to fix the regressions in v3.9 and clean it up later.
>
>
> v1 will fix quirks and pcie_aspm_sanity_check path.
> v2. will go further even user pass "aspm=off", those quirks and disable aspm
> in driver
> will still work, and also call pcie_no_aspm for disable aspm for FADT path
> early.
>
> So now you want half of v1, and not want to fix quirk path.
> Is my understanding right?

What I want is a patch that fixes the regression and doesn't break
anything else, along with a changelog that makes it obvious that we're
doing the right thing.  I don't know what that looks like yet.  None
of your patches so far is even close.

Half of your v1 patch (removing the pcie_aspm_sanity_check() test)
*might* be the right thing, but only if you can clearly explain why
that will not reintroduce the bug Matthew fixed with c9651e70.

I think we also need to fix the PCI_FIXUP_FINAL quirk regression, but
that's a separate issue and should be a separate patch.
