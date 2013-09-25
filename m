Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3IYXgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:36:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36575 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3IYXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:36:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130925232300.GA7368@neilslaptop.think-freely.org>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
 <1379382464-7920-2-git-send-email-vfalico@redhat.com> <CAErSpo6+AQhpO2WvoKCSw7WokDiex_E43oi9xpuka7biPEx=7Q@mail.gmail.com>
 <20130925232300.GA7368@neilslaptop.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Sep 2013 17:35:54 -0600
Message-ID: <CAErSpo6coKuf4f3j3zMwMNp7Uj3btN9UQyHpLPdq84aU-s=5UA@mail.gmail.com>
Subject: Re: [PATCH 1/3] msi: add forgotten pci_dev_put(pdev) to populate_msi_sysfs()
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 5:23 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Wed, Sep 25, 2013 at 03:08:05PM -0600, Bjorn Helgaas wrote:
>> [+cc Neil (he added this code in da8d1c8ba4), Greg]
>>
>> On Mon, Sep 16, 2013 at 7:47 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
>> > Before trying to kobject_init_and_add(), we add a reference to pdev via
>> > pci_dev_get(pdev). However, if it fails to init and/or add the kobject, we
>> > don't return it back - even on out_unroll.
>> >
>> > Fix this by adding pci_dev_put(pdev) before going to unrolling section.
>> >
>> > CC: Bjorn Helgaas <bhelgaas@google.com>
>> > CC: linux-pci@vger.kernel.org
>> > CC: linux-kernel@vger.kernel.org
>> > Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
>> > ---
>> >  drivers/pci/msi.c | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> > index d5f90d6..14bf578 100644
>> > --- a/drivers/pci/msi.c
>> > +++ b/drivers/pci/msi.c
>> > @@ -534,8 +534,10 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>> >                 pci_dev_get(pdev);
>> >                 ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
>> >                                      "%u", entry->irq);
>> > -               if (ret)
>> > +               if (ret) {
>> > +                       pci_dev_put(pdev);
>> >                         goto out_unroll;
>> > +               }
>> >
>> >                 count++;
>> >         }
>>
>> I don't understand why this code does the pci_dev_get() in the first
>> place.  The pdev->msi_list of msi_desc structs is private to the
>> pci_dev, and even without bumping the refcount, there should be no way
>> for the pci_dev to be freed before the msi_desc.
>>
> Its been a few years now, but IIRC I did the pci_dev_get/put here to ensure that
> people didn't try to remove the device prior to freeing all their interrupts
> (i.e I didn't want a broken driver to go through its remove routine without
> freeing all its irqs).  That might have been the wrong thing to do, but thats
> what bubbles to the front of my head when looking at this.

That sounds plausible, but I think I'd rather deal with that by having
the PCI core remove logic free all the interrupts.  I *think* that's
already in place, i.e., pci_free_resources() calls
msi_remove_pci_irq_vectors().  So I propose that we remove the
pci_dev_get()/put() unless we come up with a more compelling reason
for it.

>> I also don't understand this nearby code (the same pattern appears in
>> free_msi_irqs()):
>>
>>     out_unroll:
>>         list_for_each_entry(entry, &pdev->msi_list, list) {
>>                 if (!count)
>>                         break;
>>                 kobject_del(&entry->kobj);
>>                 kobject_put(&entry->kobj);
>>                 count--;
>>         }
>>
>> Why do we call kobject_del() here?  The kobject_put() will call
>> kobject_del() anyway, so it looks redundant.
>> Documentation/kobject.txt says kobject_del() must be called explicitly
>> to break a circular reference, but I don't think we have that here.
>>
>  I think thats exactly why I did it, because of the documentation.  I agree
> however, it does look redundant.  Harmless, but redundant.

OK, thanks.  I think we should remove it on the grounds that it's not
needed and removing it will make this code look more similar to other
callers of kobject_init_and_add(), which means bugs will have fewer
places to hide.

Thanks, Neil!

Bjorn
