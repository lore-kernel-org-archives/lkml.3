Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3C2SLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:11:35 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58586 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab3C2SLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130329032200.GA11990@google.com>
References: <CAE9FiQXmeb66dc8fET0y99BjqpUXp11c7utiQ5keR1Wf+N9xaA@mail.gmail.com>
	<1363628226-6679-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
	<CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
	<CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
	<CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
	<CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
	<20130329032200.GA11990@google.com>
Date: Fri, 29 Mar 2013 20:11:31 +0200
Message-ID: <CAPTwTV9eXDUcr_4HyGFJ1aHkT-rB5jXcQVEKeJScasmUcUu6XQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
From: Roman Yepishev <roman.yepishev@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 5:22 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Matthew]
> [+cc e1000-devel@lists.sourceforge.net for suspected 82575/82598 regression]
>
> I think this regression has nothing to do with pci_disable_link_state().
>
> ...
>
> There are also PCI_FIXUP_FINAL quirks for 82575 and 82598 NICs that call
> pci_disable_link_state().  In 3.7, these quirks are run before
> aspm_disabled is set, but 8c33f51d moved the pcie_no_aspm() call up
> before we start scanning the bus, so in 3.8, aspm_disabled is set
> *before* we run them.  I think that means 8c33f51d broke all these
> quirks.  That's also a problem, of course, but this isn't the one Roman
> is seeing either.
I have to say that my iwlwifi device (Intel Corporation Centrino
Wireless-N 1000 [Condor Peak] [8086:0084] also appears to be affected
- it calls pci_disable_link_state too and in current 3.8 that does not
do anything. It looks like it affects something when the system is
resumed from suspend, but I was not able to confirm that yet (but
there's a thread about removing the code since it did not appear to
work - http://thread.gmane.org/gmane.linux.kernel.pci/20628/focus=20640)

> I think the problem Roman is seeing happens when
> pcie_aspm_init_link_state() calls pcie_aspm_sanity_check() during device
> enumeration.  In 3.8, the fact that aspm_disabled is already set by the
> time we get here means we skip the check for pre-1.1 PCIe devices, and
> I think *this* is what Roman is seeing.
>
> I suspect the following hunk of your patch is enough to fix things for
> Roman:
>
>> --- linux-2.6.orig/drivers/pci/pcie/aspm.c
>> +++ linux-2.6/drivers/pci/pcie/aspm.c
>> @@ -493,15 +492,6 @@ static int pcie_aspm_sanity_check(struct
>>                       return -EINVAL;
>>
>>               /*
>> -              * If ASPM is disabled then we're not going to change
>> -              * the BIOS state. It's safe to continue even if it's a
>> -              * pre-1.1 device
>> -              */
>> -
>> -             if (aspm_disabled)
>> -                     continue;
>> -
>> -             /*
>>                * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
>>                * RBER bit to determine if a function is 1.1 version device
>>                */
>
> However, this test was added by Matthew in c9651e70, and I can't remove
> it unless we have an explanation of why removing it will not reintroduce
> the bug he was fixing.
>
> This code is such a terrible mess that it's not surprising at all that
> we have all these issues.  But there's too much to untangle in v3.9; all
> we can hope for is to fix the regressions in v3.9 and clean it up later.
>
I have removed the check and indeed it allowed ASPM to become disabled
during the ath5k driver load.

--
Regards, Roman Yepishev
