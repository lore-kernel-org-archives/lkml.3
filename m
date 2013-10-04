Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3JDQqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:46:54 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:65223 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3JDQqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130928213727.GC32063@redhat.com>
References: <1380189591-1368-1-git-send-email-vfalico@redhat.com> <20130928213727.GC32063@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 10:46:31 -0600
Message-ID: <CAErSpo67Uy0OZ+9jB6xvCwfjwh-NxX3FHuBnqdpWviJPVhG4dQ@mail.gmail.com>
Subject: Re: [PATCH v2] msi: free msi_desc entry only after we've released the kobject
To: Veaceslav Falico <vfalico@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 3:37 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
> On Thu, Sep 26, 2013 at 11:59:51AM +0200, Veaceslav Falico wrote:
>>
>> Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
>> however kobject_put() doesn't guarantee us that it was the last reference
>> and that the kobj isn't used currently by someone else, so after we
>> kfree(entry) with the struct kobject - other users will begin using the
>> freed memory, instead of the actual kobject.
>
>
> Hi Bjorn,
>
> I've seen that you've dropped this bugfix (and the 3 cleanup patches) with
> "Changes Requested", however I don't recall any request to change this.

I talked to Greg KH about this recently, and he said he might take a
look at doing a more extensive cleanup of populate_msi_sysfs() using
attribute groups, so I don't know if you want to wait and see whether
he does anything, or go ahead on the path you were on.

If you continue, my advice is:

  - Put all these patches in a single series with a version number (I
think the next posting would be v3) to help me keep track of them.

  - In populate_msi_sysfs(), drop the pci_dev_get() (or explain why
it's needed).  My reasoning is that the "msi_irqs" kset should already
hold a reference on the pdev (acquired in kset_create_and_add() ->
kset_register() -> kobject_add_internal()), and each irq entry should
hold a reference on the kset (see kobject_add_internal() again),  so
it is redundant to acquire a reference on the pdev directly.  This
means dropping the pci_dev_put() in msi_kobj_release(), of course.

- Move the kfree(entry) from free_msi_irqs() to msi_kobj_release() (I
think one of your patches already did this).

  - In populate_msi_sysfs(), drop the kobject_del() in the out_unroll
loop.  I think we would only need that if there were a way to create a
new irq entry in "msi_irqs" before the old irq entry was released.
But I don't think that's possible.  We only create irq entries in
populate_msi_sysfs(), which always starts with a fresh, empty
"msi_irqs" kset.

  - In free_msi_irqs(), similarly remove the kobject_del().

  - Add a kobject_del() before each kset_unregister(dev->msi_kset)
call.  This will remove "msi_irqs" from sysfs, so future creates will
succeed even if somebody still has the old "msi_irqs" open.

  - Keep the msi_kset cleanup in populate_msi_sysfs() instead of
relying on free_msi_irqs().  I think it's less error prone to keep the
creation and error path cleanup in the same function.

Bjorn
