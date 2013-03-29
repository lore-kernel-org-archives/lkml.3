Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3C2SC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:02:56 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:37716 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3C2SCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
References: <CAE9FiQXmeb66dc8fET0y99BjqpUXp11c7utiQ5keR1Wf+N9xaA@mail.gmail.com>
	<1363628226-6679-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
	<CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
	<CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
	<CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
	<CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
	<20130329032200.GA11990@google.com>
	<CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
	<CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
Date: Fri, 29 Mar 2013 11:02:52 -0700
X-Google-Sender-Auth: tuCUqfT0ZH0LIq32fn_WT63-bfc
Message-ID: <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
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

On Fri, Mar 29, 2013 at 5:24 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Half of your v1 patch (removing the pcie_aspm_sanity_check() test)
> *might* be the right thing, but only if you can clearly explain why
> that will not reintroduce the bug Matthew fixed with c9651e70.
>
> I think we also need to fix the PCI_FIXUP_FINAL quirk regression, but
> that's a separate issue and should be a separate patch.


First commit from Matthew
 0ae5eaf10     PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
    Right now we won't touch ASPM state if ASPM is disabled, except in the case
    where we find a device that appears to be too old to reliably support ASPM.
    Right now we'll clear it in that case, which is almost certainly the wrong
    thing to do

Try to not touch pre-1.1 ASPM for all, and it causes lots of regression.

So second commit

cdb0f9a1ad2e ASPM: Fix pcie devices with non-pcie children
    Since 3.2.12 and 3.3, some systems are failing to boot with a BUG_ON.
    Some other systems using the pata_jmicron driver fail to boot because no
    disks are detected.  Passing pcie_aspm=force on the kernel command line
    works around it.

move the check aspm_disabled down.

but ath5 and etc (pre-1.1) really need to aspm_disable to change their
hw setting.

So the right solution would be dropping pcie_aspm_sanity_check()
change -in v2 should make all both happy, as quirk and disable that in
driver for ath5 are calling
pcie_disable_aspm_state explicitly.

In v2, we already removed pcie_clear_aspm() that is calling
pcie_disable_aspm_state.


Please check attached -v3.


Thanks

Yinghai
