Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaHYRSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:18:53 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:50646 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHYRSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:18:52 -0400
Date: Mon, 25 Aug 2014 19:18:45 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <373053698.20140825191845@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, gregkh@linuxfoundation.org,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5] Fixes to Xen pciback for 3.17.
In-Reply-To: <53E34102.8030002@citrix.com>
References: <53DBB27D.2040203@citrix.com> <20140804184318.GB9009@laptop.dumpdata.com> <75613802.20140805104438@eikelenboom.it> <53E0A45C.4050400@citrix.com> <1985206568.20140805114433@eikelenboom.it> <20140805134930.GE13057@laptop.dumpdata.com> <1724263917.20140805160443@eikelenboom.it> <182103485.20140806205959@eikelenboom.it> <20140806191831.GB30062@laptop.dumpdata.com> <1081188855.20140806212559@eikelenboom.it> <20140806193916.GA31040@laptop.dumpdata.com> <53E34102.8030002@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Konrad,

Just in case you forgot this one .. a subtle ping (we are just in the low RC's) :-)

--
Sander

Thursday, August 7, 2014, 11:04:02 AM, you wrote:

> On 06/08/14 20:39, Konrad Rzeszutek Wilk wrote:
>> 
>> From 00a5b6e3c9ee2c2d605879bdaebc627fa640b024 Mon Sep 17 00:00:00 2001
>> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Date: Wed, 6 Aug 2014 16:21:32 -0400
>> Subject: [PATCH] xen/pciback: Restore configuration space when detaching from
>>  a guest.
>> 
>> The commit 9eea3f7695226f9af9992cebf8e98ac0ad78b277
>> "xen/pciback: Don't deadlock when unbinding." was using
>> the version of pci_reset_function which would lock the device lock.
>> That is no good as we can dead-lock. As such we swapped to using
>> the lock-less version and requiring that the callers
>> of 'pcistub_put_pci_dev' take the device lock. And as such
>> this bug got exposed.
>> 
>> Using the lock-less version is  OK, except that we tried to
>> use 'pci_restore_state' after the lock-less version of
>> __pci_reset_function_locked - which won't work as 'state_saved'
>> is set to false. Said 'state_saved' is a toggle boolean that
>> is to be used by the sequence of a) pci_save_state/pci_restore_state
>> or b) pci_load_and_free_saved_state/pci_restore_state. We don't
>> want to use a) as the guest might have messed up the PCI
>> configuration space and we want it to revert to the state
>> when the PCI device was binded to us. Therefore we pick
>> b) to restore the configuration space.
>> 
>> To still retain the PCI configuration space, we save it once
>> more and store it on our private copy to be restored when:
>>  - Device is unbinded from pciback
>>  - Device is detached from a guest.

> This should be folded into the original patch.

> [...]
>> --- a/drivers/xen/xen-pciback/pci_stub.c
>> +++ b/drivers/xen/xen-pciback/pci_stub.c
>> @@ -105,7 +105,7 @@ static void pcistub_device_release(struct kref *kref)
>>        */
>>       __pci_reset_function_locked(dev);
>>       if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))

> I dislike testing for errors like this as it looks like it's testing for
> a boolean success.  Use

>    ret = pci_load_and_free_saved_state(...);
>    if (ret < 0)
>       ...

> And similarly, below.

>> -             dev_dbg(&dev->dev, "Could not reload PCI state\n");
>> +             dev_info(&dev->dev, "Could not reload PCI state\n");

> This should be dev_warn().

> pci_load_and_free_saved_state() won't fail because we know the state is
> valid (since we saved it from the device originally).  Warning and
> skipping the restore is fine here (and below).

>>       else
>>               pci_restore_state(dev);
>>  
>> @@ -257,6 +257,7 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>>  {
>>       struct pcistub_device *psdev, *found_psdev = NULL;
>>       unsigned long flags;
>> +     struct xen_pcibk_dev_data *dev_data;
>>  
>>       spin_lock_irqsave(&pcistub_devices_lock, flags);
>>  
>> @@ -279,9 +280,25 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>>        * (so it's ready for the next domain)
>>        */
>>       device_lock_assert(&dev->dev);
>> -     __pci_reset_function_locked(dev);
>> -     pci_restore_state(dev);
>> -
>> +     dev_data = pci_get_drvdata(dev);
>> +     if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))

> This should be pci_load_saved_state() and then you can avoid the
> pci_save_state() below.

>> +             dev_info(&dev->dev, "Could not reload PCI state\n");

> dev_warn() also.

>> +     else {
>> +             __pci_reset_function_locked(dev);
>> +             /*
>> +              * The usual sequence is pci_save_state & pci_restore_state
>> +              * but the guest might have messed the configuration space up.
>> +              * Use the initial version (when device was binded to us).

> s/binded/bound/

>> +             pci_restore_state(dev);
>> +             /*
>> +              * The next steps are to reload the configuration for the
>> +              * next time we bind & unbind to a guest - or unload from
>> +              * pciback.
>> +              */
>> +             pci_save_state(dev);
>> +             dev_data->pci_saved_state = pci_store_saved_state(dev);

> You don't need this if you don't free the original state above.

>> +     }
>>       /* This disables the device. */
>>       xen_pcibk_reset_device(dev);

> David


