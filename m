Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbaFYRv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:51:56 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:50594 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaFYRvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <de1a45e8e5d548b88b5f797348a39e0d@DM2PR05MB671.namprd05.prod.outlook.com>
References: <20140617192734.30783.71260.stgit@amt.stowe> <CAErSpo7t2kXj2ZULLXCJSWb_awS+DCtCg51dnLbb8ztWmQdYog@mail.gmail.com>
 <53A0C763.7080003@roeck-us.net> <aa91dac8e0f4416bb5f8b901b4da8f22@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAErSpo4xWtBtL6a-vNh_s+MRHNVa6iEe3g8ZcgFPyHHD0ZrM9g@mail.gmail.com> <de1a45e8e5d548b88b5f797348a39e0d@DM2PR05MB671.namprd05.prod.outlook.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Jun 2014 11:51:34 -0600
Message-ID: <CAErSpo6Wr4NrbwkJg6L0khU=fcH7UOOVCUoFo1QNLTxu2Z9Dsw@mail.gmail.com>
Subject: Re: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
To: Rajat Jain <rajatjain@juniper.net>
Cc: Guenter Roeck <linux@roeck-us.net>, Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:26 PM, Rajat Jain <rajatjain@juniper.net> wrote:

>> > Essentially my hiccup was that I was not sure whether the driver should or
>> should not take care of the link change events that have happened BEFORE
>> the driver gets loaded. This has more impact if the pciehp is built as a kernel
>> module.
>> >
>> > As an example:
>> >
>> > It is common for the platform init code built into the kernel, to take the PCI
>> devices on the board out of reset. And that can happen after the PCI
>> enumeration but before the pciehp driver gets loaded. Thus in this condition,
>> with this patch, the pciehp will ignore the linkup event, thus device will not
>> be visible. The only way (other than a rescan) to do hot-add the device would
>> be to apply-and-remove-reset-signal to the device again. At which point
>> pciehp may give a warning about about an attempt to remove a non-existent
>> card, and then will proceed fine with hot-add.
>>
>> When you saw these problems, was pciehp a module?
>
> No, we did not actually hit *this* problem (DLLSC getting set before pciehp init). We had observed another HW specific problem where both link event and presence detect were toggling, hence 2 independent hot-plug interrupts events were coming, thus resulting in spurious messages.

OK, this sounds like a slightly different problem that we can work on
later if it turns out to be necessary.

>  > For example, if a card were inserted
>> after enumeration but before pciehp is initialized, we'd miss the PDC
>> indication, so I think we would fail to notice the new device.
>> That seems basically the same as missing the linkup event in your example.
>> In both cases, I think we *should* notice the new device, so the fact that we
>> don't is a problem.
> ...

>>   - We currently have a problem with missing pre-pciehp events, but there is
>> a way to fix this
>
> Somewhat agree (I do not understand what that way is currently. But I think it can wait as we don't hit that problem today and also the window where it can occur is very small).

My thought was that we could fix this by integrating pciehp into PCI
enumeration, so we're prepared to handle hotplug events on the bridge
before we enumerate any device below the bridge.  But I haven't
actually tried this so I don't know whether it's practical.

Bjorn
