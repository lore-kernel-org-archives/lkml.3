Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3IZM1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab3IZM1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:27:53 -0400
Date: Thu, 26 Sep 2013 14:25:52 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] msi: add forgotten pci_dev_put(pdev) to
 populate_msi_sysfs()
Message-ID: <20130926122552.GB4783@redhat.com>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
 <1379382464-7920-2-git-send-email-vfalico@redhat.com>
 <CAErSpo6+AQhpO2WvoKCSw7WokDiex_E43oi9xpuka7biPEx=7Q@mail.gmail.com>
 <20130925232300.GA7368@neilslaptop.think-freely.org>
 <CAErSpo6coKuf4f3j3zMwMNp7Uj3btN9UQyHpLPdq84aU-s=5UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAErSpo6coKuf4f3j3zMwMNp7Uj3btN9UQyHpLPdq84aU-s=5UA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 05:35:54PM -0600, Bjorn Helgaas wrote:
>On Wed, Sep 25, 2013 at 5:23 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Wed, Sep 25, 2013 at 03:08:05PM -0600, Bjorn Helgaas wrote:
>>> [+cc Neil (he added this code in da8d1c8ba4), Greg]
>>>
>>> On Mon, Sep 16, 2013 at 7:47 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
>>> > Before trying to kobject_init_and_add(), we add a reference to pdev via
>>> > pci_dev_get(pdev). However, if it fails to init and/or add the kobject, we
>>> > don't return it back - even on out_unroll.
>>> >
>>> > Fix this by adding pci_dev_put(pdev) before going to unrolling section.
>>> >
>>> > CC: Bjorn Helgaas <bhelgaas@google.com>
>>> > CC: linux-pci@vger.kernel.org
>>> > CC: linux-kernel@vger.kernel.org
>>> > Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
>>> > ---
>>> >  drivers/pci/msi.c | 4 +++-
>>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>>> >
>>> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>>> > index d5f90d6..14bf578 100644
>>> > --- a/drivers/pci/msi.c
>>> > +++ b/drivers/pci/msi.c
>>> > @@ -534,8 +534,10 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>>> >                 pci_dev_get(pdev);
>>> >                 ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
>>> >                                      "%u", entry->irq);
>>> > -               if (ret)
>>> > +               if (ret) {
>>> > +                       pci_dev_put(pdev);
>>> >                         goto out_unroll;
>>> > +               }
>>> >
>>> >                 count++;
>>> >         }
>>>
>>> I don't understand why this code does the pci_dev_get() in the first
>>> place.  The pdev->msi_list of msi_desc structs is private to the
>>> pci_dev, and even without bumping the refcount, there should be no way
>>> for the pci_dev to be freed before the msi_desc.
>>>
>> Its been a few years now, but IIRC I did the pci_dev_get/put here to ensure that
>> people didn't try to remove the device prior to freeing all their interrupts
>> (i.e I didn't want a broken driver to go through its remove routine without
>> freeing all its irqs).  That might have been the wrong thing to do, but thats
>> what bubbles to the front of my head when looking at this.
>
>That sounds plausible, but I think I'd rather deal with that by having
>the PCI core remove logic free all the interrupts.  I *think* that's
>already in place, i.e., pci_free_resources() calls
>msi_remove_pci_irq_vectors().  So I propose that we remove the
>pci_dev_get()/put() unless we come up with a more compelling reason
>for it.

As an update - I've found an interesting case why exactly that
kobject_del() might be needed:

in kobject_del() it removes instantly the link to kset - via
kobj_kset_leave(), so that our kset remains without links and, thus, might
be instantly removed.

So, with kobject_del(), our kset (msi_irqs sysfs dir) remains instantly
without any links (i.e. other kobjects) and, when we call kset_unregister()
- it exits instantly (if it's not being hold somewhere elsewhere...).

Without it, kset_unregister() will wait till all the kobjects will be gone.

Now, the fun part starts - if we quickly call pci_disable_msi() and,
afterwards, pci_enable_msi() - we might fail because the msi_irqs kset is
still there, waiting to unregister, and the sysfs dir is still active.

It's used, for example, in tg3_open/tg3_close, which are ndo_open/close,
and are called on enslave/deslave in bonding.

What I get:
[   60.458319] WARNING: CPU: 0 PID: 5552 at fs/sysfs/dir.c:526 sysfs_add_one+0xbb/0xe0()
[   60.458350] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.5/0000:3f:00.0/msi_irqs'

I'll take a deeper look at the issue, though any feedback/advise is
welcome. And I'll hold on with the patchset that removes pci_dev_get/put
and kobject_del.


>
>>> I also don't understand this nearby code (the same pattern appears in
>>> free_msi_irqs()):
>>>
>>>     out_unroll:
>>>         list_for_each_entry(entry, &pdev->msi_list, list) {
>>>                 if (!count)
>>>                         break;
>>>                 kobject_del(&entry->kobj);
>>>                 kobject_put(&entry->kobj);
>>>                 count--;
>>>         }
>>>
>>> Why do we call kobject_del() here?  The kobject_put() will call
>>> kobject_del() anyway, so it looks redundant.
>>> Documentation/kobject.txt says kobject_del() must be called explicitly
>>> to break a circular reference, but I don't think we have that here.
>>>
>>  I think thats exactly why I did it, because of the documentation.  I agree
>> however, it does look redundant.  Harmless, but redundant.
>
>OK, thanks.  I think we should remove it on the grounds that it's not
>needed and removing it will make this code look more similar to other
>callers of kobject_init_and_add(), which means bugs will have fewer
>places to hide.
>
>Thanks, Neil!
>
>Bjorn
