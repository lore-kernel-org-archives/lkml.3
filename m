Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3AYEXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:23:39 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:57614 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3AYEXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:23:37 -0500
MIME-Version: 1.0
In-Reply-To: <50DD5E8A.5050205@cn.fujitsu.com>
References: <1356679902-4266-1-git-send-email-linfeng@cn.fujitsu.com>
 <CAE9FiQU1YM32pb+iGJHj1m3W-nGUbHh5f8Qkx5bRsfptgGParw@mail.gmail.com> <50DD5E8A.5050205@cn.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 24 Jan 2013 21:23:16 -0700
Message-ID: <CAErSpo5VofkxRDvDc3q5xF5nq4Wy+5RAYwkQ6BdSftRXPPF3kw@mail.gmail.com>
Subject: Re: [PATCH] pci: remove redundant function calls in pci_reassigndev_resource_alignment()
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 1:55 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>
>
> On 12/28/2012 03:45 PM, Yinghai Lu wrote:
>> On Thu, Dec 27, 2012 at 11:31 PM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>>> pci_reassigndev_resource_alignment() potentially calls
>>> pci_specified_resource_alignment() twice, which is redundant.
>>>
>>> pci_is_reassigndev() is only called in pci_reassigndev_resource_alignment(),
>>> and from sematic/functionality aspects pci_specified_resource_alignment() is
>>> sufficient to substitute, so also make some cleanup.
>>>
>>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/pci/pci.c |   16 ++--------------
>>>  1 files changed, 2 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>> index 5cb5820..789f401 100644
>>> --- a/drivers/pci/pci.c
>>> +++ b/drivers/pci/pci.c
>>> @@ -3766,18 +3766,6 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
>>>         return align;
>>>  }
>>>
>>> -/**
>>> - * pci_is_reassigndev - check if specified PCI is target device to reassign
>>> - * @dev: the PCI device to check
>>> - *
>>> - * RETURNS: non-zero for PCI device is a target device to reassign,
>>> - *          or zero is not.
>>> - */
>>> -int pci_is_reassigndev(struct pci_dev *dev)
>>> -{
>>> -       return (pci_specified_resource_alignment(dev) != 0);
>>> -}
>>> -
>>>  /*
>>>   * This function disables memory decoding and releases memory resources
>>>   * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
>>> @@ -3792,7 +3780,8 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
>>>         resource_size_t align, size;
>>>         u16 command;
>>>
>>> -       if (!pci_is_reassigndev(dev))
>>> +       align = pci_specified_resource_alignment(dev);
>>> +       if (!align)
>>>                 return;
>>>
>>>         if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
>>> @@ -3808,7 +3797,6 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
>>>         command &= ~PCI_COMMAND_MEMORY;
>>>         pci_write_config_word(dev, PCI_COMMAND, command);
>>>
>>> -       align = pci_specified_resource_alignment(dev);
>>>         for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
>>>                 r = &dev->resource[i];
>>>                 if (!(r->flags & IORESOURCE_MEM))
>>> --
>>> 1.7.1
>>>
>>
>> looks the same as the one that i posted 6 months ago.
>>
>> http://copilotco.com/mail-archives/linux-kernel.2012/msg18498.html
> Sorry, I didn't notice your patchset before :)
> Yes, they are the same. But why does nobody care this?

I applied Yinghai's patch to my pci/misc branch, headed for v3.9.

Bjorn
