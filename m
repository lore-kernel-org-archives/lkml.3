Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaFOPFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 11:05:40 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:46259 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaFOPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 11:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140429234130.GC9912@google.com>
References: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
	<20140429234130.GC9912@google.com>
Date: Sun, 15 Jun 2014 19:05:38 +0400
Message-ID: <CALYGNiNbTFa9k-braPQYZkxs_A0DeNhK-ME9RQhBBkRUv+R51Q@mail.gmail.com>
Subject: Re: [PATCH v3] PCI: rework new_id interface for known vendor/device values
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Bandan Das <bsd@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 3:41 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Apr 01, 2014 at 09:32:59PM -0400, Bandan Das wrote:
>>
>> While using the new_id interface, the user can unintentionally feed
>> incorrect values if the driver static table has a matching entry.
>> This is possible since only the device and vendor fields are
>> mandatory and the rest are optional. As a result, store_new_id
>> will fill in default values that are then passed on to the driver
>> and can have unintended consequences.
>>
>> As an example, consider the ixgbe driver and the 82599EB network card :
>> echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
>>
>> This will pass a driver_data value of 0 to the driver whereas
>> the index 0 in ixgbe actually points to a different set of card
>> operations.
>>
>> This change returns an error if the user attempts to add a dynid for
>> a vendor/device combination for which a static entry already exists.
>> However, if the user intentionally wants a different set of values,
>> she must provide all the 7 fields and that will be accepted.
>>
>> In KVM/device assignment scenario, the user might want
>> to bind a device back to the host driver by writing to new_id
>> and trip on a possible null pointer dereference.

It's not directly related to this patch, but I have a problem with
this interface.

iwlwifi.ko stores internal pointer in private_data field. So, it's
hard to guess right one for adding new alias.
Currently I'm using CONFIG_KALLSYMS_ALL=y, but it seems so ugly.

I was thinking about adding new interface: "clone_id" (or "dup_id")
which would make a copy of existing entry but with different product:vendor id.
And I mostly have a patch for that.

Or it's would be better to fix that driver (replace opaque pointer
with some stable indexes)?


>>
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>
> Applied with Alex's ack to pci/misc for v3.16, thanks!
>
