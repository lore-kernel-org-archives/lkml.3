Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3JILit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab3JILir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:38:47 -0400
Date: Wed, 9 Oct 2013 13:36:38 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] msi: free msi_desc entry only after we've released
 the kobject
Message-ID: <20131009113638.GA19020@redhat.com>
References: <1380189591-1368-1-git-send-email-vfalico@redhat.com>
 <20130928213727.GC32063@redhat.com>
 <CAErSpo67Uy0OZ+9jB6xvCwfjwh-NxX3FHuBnqdpWviJPVhG4dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAErSpo67Uy0OZ+9jB6xvCwfjwh-NxX3FHuBnqdpWviJPVhG4dQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:46:31AM -0600, Bjorn Helgaas wrote:
>On Sat, Sep 28, 2013 at 3:37 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
>> On Thu, Sep 26, 2013 at 11:59:51AM +0200, Veaceslav Falico wrote:
>>>
>>> Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
>>> however kobject_put() doesn't guarantee us that it was the last reference
>>> and that the kobj isn't used currently by someone else, so after we
>>> kfree(entry) with the struct kobject - other users will begin using the
>>> freed memory, instead of the actual kobject.
>>
>>
>> Hi Bjorn,
>>
>> I've seen that you've dropped this bugfix (and the 3 cleanup patches) with
>> "Changes Requested", however I don't recall any request to change this.
>
>I talked to Greg KH about this recently, and he said he might take a
>look at doing a more extensive cleanup of populate_msi_sysfs() using
>attribute groups, so I don't know if you want to wait and see whether
>he does anything, or go ahead on the path you were on.

Sorry for the delay, was sick. I'll continue going ahead, however if
Greg/you don't really need it or are working on it - please say now, so I'll
stop waisting your time.

>
>If you continue, my advice is:
>
>  - Put all these patches in a single series with a version number (I
>think the next posting would be v3) to help me keep track of them.

Will do, if/when there'll be next version. Now they're divided into 1
bugfix and 1 cleanup patchset.

>
>  - In populate_msi_sysfs(), drop the pci_dev_get() (or explain why
>it's needed).  My reasoning is that the "msi_irqs" kset should already
>hold a reference on the pdev (acquired in kset_create_and_add() ->
>kset_register() -> kobject_add_internal()), and each irq entry should
>hold a reference on the kset (see kobject_add_internal() again),  so
>it is redundant to acquire a reference on the pdev directly.  This
>means dropping the pci_dev_put() in msi_kobj_release(), of course.

It's done in my patch

     pci: remove redundant pci_dev_get/put() on kobject (un)register

http://patchwork.ozlabs.org/patch/278201/

>
>- Move the kfree(entry) from free_msi_irqs() to msi_kobj_release() (I
>think one of your patches already did this).

It's done in my patch

	    msi: free msi_desc entry only after we've released the kobject

http://patchwork.ozlabs.org/patch/278150/

>
>  - In populate_msi_sysfs(), drop the kobject_del() in the out_unroll
>loop.  I think we would only need that if there were a way to create a
>new irq entry in "msi_irqs" before the old irq entry was released.
>But I don't think that's possible.  We only create irq entries in
>populate_msi_sysfs(), which always starts with a fresh, empty
>"msi_irqs" kset.

It's done in my patch

     msi: free msi_desc entry only after we've released the kobject

http://patchwork.ozlabs.org/patch/278150/

>
>  - In free_msi_irqs(), similarly remove the kobject_del().

It's done in my patch

	    msi: remove useless kobject_del() in free_msi_irqs()

http://patchwork.ozlabs.org/patch/278202/

>
>  - Add a kobject_del() before each kset_unregister(dev->msi_kset)
>call.  This will remove "msi_irqs" from sysfs, so future creates will
>succeed even if somebody still has the old "msi_irqs" open.

I think it's done in your patch

	kobject: remove kset from sysfs immediately in kset_unregister()

http://patchwork.ozlabs.org/patch/281618/

So it'll collide and use kobject_del() twice.

Or did you actually drop your patch?

>
>  - Keep the msi_kset cleanup in populate_msi_sysfs() instead of
>relying on free_msi_irqs().  I think it's less error prone to keep the
>creation and error path cleanup in the same function.

It is less error prone, however the current design is that "once we fail
something while creating irqs, always call free_msi_irqs()", so, if we add
the msi_kset cleanup to populate_msi_sysfs() (it wasn't there before, so we
can't 'keep' it) - we'll have to verify if it was don in free_msi_irqs(),
cause free_msi_irqs() is being called not only on rollback in
msi_capability_init(), but also in pci_disable_msi() and friends.

>
>Bjorn
