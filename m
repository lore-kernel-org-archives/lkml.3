Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3DQQmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:42:36 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39434 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3DQQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:42:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6uAbiJ5GtvOmoABvwSnWj3DRRrXB6K1PzQSnReFqbqxA@mail.gmail.com>
References: <1366196798-15929-1-git-send-email-artem.savkov@gmail.com> <CAErSpo6uAbiJ5GtvOmoABvwSnWj3DRRrXB6K1PzQSnReFqbqxA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 17 Apr 2013 10:42:12 -0600
Message-ID: <CAErSpo7nj3DQ-RB0UJdkzfN0L891xiTH8yzzcv7pW4AZ6waJ2A@mail.gmail.com>
Subject: Re: [PATCH] PCI: pci_bus_add_device() should succeed even if creating
 sysfs files fails
To: Artem Savkov <artem.savkov@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 9:54 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Apr 17, 2013 at 5:06 AM, Artem Savkov <artem.savkov@gmail.com> wrote:
>> Introduced in cc8f7f9e4e79a0940af6b4b6fdfbcf18a03aa9f4
>> ("PCI: Fix __must_check annotation on pci_create_sysfs_dev_files()")
>>
>> pci_bus_add_device() should not fail to add device if
>> pci_create_sysfs_dev_files() call fails, as sysfs files are not critical.
>>
>> pci_sysfs_init() is a "late_initcall" and is called after acpi_init, so
>> pci_bus_add_device() fails to create devices during boot resulting in a
>> bug during acpi_init. It is safe not to create sysfs_dev_files in
>> pci_bus_add_device() as they are later created in pci_sysfs_ini().
>> ...

> Sorry for the breakage.  Thanks for the report, analysis, and fix.
> I'll fix this up

It's not clear to me what the best fix is, so I just dropped my original patch.

It's clearly wrong to have __must_check on the
pci_create_sysfs_dev_files() definition, because it doesn't do
anything there.

We could simply drop the __must_check altogether, as you suggest, but
I'd rather structure things to avoid the failure in the first place
rather than ignoring an error.

It would be ideal if we could get rid of the pci_sysfs_init()
late_initcall and just make the pci_create_sysfs_dev_files() from
pci_bus_add_device() work all the time, even at boot-time.  I didn't
look hard enough to figure out why this needs to be a late_initcall.

In any case, we can figure this out later, after we merge the current
stuff for v3.10.

Bjorn
