Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3IYWOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:14:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab3IYWOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:14:41 -0400
Date: Thu, 26 Sep 2013 00:12:50 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 3/3] msi: free msi_desc entry only after we've released
 the kobject
Message-ID: <20130925221250.GB26965@redhat.com>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
 <1379382464-7920-4-git-send-email-vfalico@redhat.com>
 <CAErSpo77PrKi9nwBada444TOA5vwjWdt06Qv+GZLreh61kNH6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAErSpo77PrKi9nwBada444TOA5vwjWdt06Qv+GZLreh61kNH6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 03:34:58PM -0600, Bjorn Helgaas wrote:
>On Mon, Sep 16, 2013 at 7:47 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
>> Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
>> however kobject_put() doesn't guarantee us that it was the last reference
>> and that the kobj isn't used currently by someone else, so after we
>> kfree(entry) with the struct kobject - other users will begin using the
>> freed memory, instead of the actual kobject.
>>
>> Fix this by using the kobject->release callback, which is called last when
>> the kobject is indeed not used and is cleaned up - it's msi_kobj_release(),
>> which can do the kfree(entry) safely (kobject_put/cleanup doesn't use the
>> kobj itself after ->release() was called, so we're safe).
>>
>> In case we've failed to create the sysfs directories - just kfree()
>> it - cause we don't have the kobjects attached.
>>
>> Also, remove the same functionality from populate_msi_sysfs(), cause on
>> failure we anyway call free_msi_irqs(), which will take care of all the
>> kobjects properly.
>
>I agree; it looks like populate_msi_sysfs() doesn't need to have the
>cleanup in it.  Can you split that into a separate patch, since I
>don't think it depends on the kfree() fix?

Yep, will do and re-send in two patchsets.

Thank you!

>
>Bjorn
>
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>> CC: linux-pci@vger.kernel.org
>> CC: linux-kernel@vger.kernel.org
>> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
>> ---
>>  drivers/pci/msi.c | 27 +++++++++------------------
>>  1 file changed, 9 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index 68da921..c9236e4 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -374,19 +374,22 @@ static void free_msi_irqs(struct pci_dev *dev)
>>                                 iounmap(entry->mask_base);
>>                 }
>>
>> +               list_del(&entry->list);
>> +
>>                 /*
>>                  * Its possible that we get into this path
>>                  * When populate_msi_sysfs fails, which means the entries
>>                  * were not registered with sysfs.  In that case don't
>> -                * unregister them.
>> +                * unregister them, and just free. Otherwise the
>> +                * kobject->release will take care of freeing the entry via
>> +                * msi_kobj_release().
>>                  */
>>                 if (entry->kobj.parent) {
>>                         kobject_del(&entry->kobj);
>>                         kobject_put(&entry->kobj);
>> +               } else {
>> +                       kfree(entry);
>>                 }
>> -
>> -               list_del(&entry->list);
>> -               kfree(entry);
>>         }
>>
>>         kset_unregister(dev->msi_kset);
>> @@ -512,6 +515,7 @@ static void msi_kobj_release(struct kobject *kobj)
>>         struct msi_desc *entry = to_msi_desc(kobj);
>>
>>         pci_dev_put(entry->dev);
>> +       kfree(entry);
>>  }
>>
>>  static struct kobj_type msi_irq_ktype = {
>> @@ -525,7 +529,6 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>>         struct msi_desc *entry;
>>         struct kobject *kobj;
>>         int ret;
>> -       int count = 0;
>>
>>         pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
>>         if (!pdev->msi_kset)
>> @@ -539,23 +542,11 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>>                                      "%u", entry->irq);
>>                 if (ret) {
>>                         pci_dev_put(pdev);
>> -                       goto out_unroll;
>> +                       return ret;
>>                 }
>> -
>> -               count++;
>>         }
>>
>>         return 0;
>> -
>> -out_unroll:
>> -       list_for_each_entry(entry, &pdev->msi_list, list) {
>> -               if (!count)
>> -                       break;
>> -               kobject_del(&entry->kobj);
>> -               kobject_put(&entry->kobj);
>> -               count--;
>> -       }
>> -       return ret;
>>  }
>>
>>  /**
>> --
>> 1.8.4
>>
