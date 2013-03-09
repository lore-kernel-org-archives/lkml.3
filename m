Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3CIXY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 18:24:58 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37443 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3CIXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 18:24:56 -0500
MIME-Version: 1.0
In-Reply-To: <F766E4F80769BD478052FB6533FA745D25F440A477@SC-VEXCH4.marvell.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
	<CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com>
	<CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com>
	<CAErSpo6ascpN=bBUUzkk5W3-Wee_1ZztAyTwnKd-tq=L_9Q3mw@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440A477@SC-VEXCH4.marvell.com>
Date: Sat, 9 Mar 2013 16:24:55 -0700
Message-ID: <CAL-B5D1=zqB_9sWL9A_GgY6OgGdw18qxBHbgj_YG2bj0VGDh4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
From: Myron Stowe <myron.stowe@gmail.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 7:49 AM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
> Hi, Bjorn
>
>>> >> > Fix system hang issue: if first accessed resource file of BAR0 ~
>>> >> > BAR4, system will hang after executing lspci command
>>> >>
>>> >> This needs more explanation.  We've already read the BARs by the
>>> >> time header quirks are run, so apparently it's not just the mere
>>> >> act of accessing a BAR that causes a hang.
>>> >>
>>> >> We need to know exactly what's going on here.  For example, do
>>> >> BARs
>>> >> 0-4 exist?  Does the device decode accesses to the regions
>>> >> described by the BARs?  The PCI core has to know what resources
>>> >> the device uses, so if the device decodes accesses, we can't just
>>> >> throw away the start/end information.
>>> > The BARs 0-4 is exist and the PCI device is enable IO space, but
>>> > user access
>>> the regions file by udevadm command with info parameter, the system will hang.
>>> > Like this: udevadmin info --attribut-walk
>>> --path=/sys/device/pci-device/000:*.
>>> > Because the device is just AHCI host controller, don't need the
>>> > BAR0 ~ 4 region
>>> file.
>>> > Is my explanation ok for the patch?
>>>
>>> No, I still don't know what causes the hang; I only know that udevadm
>>> can trigger it.  I don't want to just paper over the problem until we
>>> know what the root cause is.
>>>
>>> Does "lspci -H1 -vv" also cause a hang?  What about "setpci -s<dev>
>>> BASE_ADDRESS_0"?  "setpci -H1 -s<dev> BASE_ADDRESS_0"?
>> The commands are ok because the commands can't find the device after accessing IO port.
>> The root cause is that accessing of IO port will make the chip go bad. So, the point of the patch is don't export capability of the IO accessing.
>
>>Ah, so the problem is not with accessing the BAR in config space.  The problem is with accessing the I/O port space mapped by the BAR.  Is that right?
>
> Yes...
>
>>Does "udevadm info --attribute-walk" really access the device address space mapped by the BARs?
>
> The older version maybe will access the space, I just got the info from HP. And I simplify the issue by executing following command:
> Cat /sys/devices/pci-device/**/resourceX
>
> I want to set the resources of BAR0 ~ 4 to 0 to avoid the IO accessing by user.

I tried to explain earlier the possible issues with the approach that
is currently being put forth.  Please review that and if you have any
questions ask.

>
> Any question? Thanks!

Googling and looking at the PCI IDs data base I see that the Marvell
9125 device has been around since sometime around 2010 and that there
even seem to be a number of follow-on iterations of the chip (i.e.
9128, 9120, ...).  It seems incredibly unlikely that Marvell made a
device that has been shipping for 2+ years with five I/O BARs that do
not work and we are only now finding out such.

Am I missing something relevant here?  Can you verify that this device
has is indeed not new and has been successfully used in recent
platforms?


You just recently responded with  "... I just got the info from HP.
..." so I'm assuming this is an issue that has just been encountered
on some type of HP system - is this correct?  If so, do you have
access to the system to provide the logs I asked for earlier?  Also,
is there anything special or completely new about this platform that
would explain away the arguments for why this is probably not a
Marvell device issue?

At this point it seems more likely that there is an issue with the
BIOS of the HP system, perhaps a resource duplication/overlap issue
much like I talked about earlier.

To understand the root cause and not just band-aid over a symptom we
need to get the logs asked for from the system.  HP likely needs to
get involved and start participating and providing such at this point.

Again, the logs that would be helpful currently are: A 'dmesg' log
from the system which was booted using both the "debug" and
"ignore_loglevel" boot parameters, a 'lspci -xxx -s<dev>' capture
targeting the Marvell 9125 device, and a 'lspci -vv' capture of the
system's entire PCI hierarchy.

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
