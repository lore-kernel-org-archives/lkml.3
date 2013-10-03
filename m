Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3JCUTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:19:55 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57267 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3JCUTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <20131002204141.GW12758@n2100.arm.linux.org.uk>
References: <1380189591-1368-1-git-send-email-vfalico@redhat.com>
 <20130928213727.GC32063@redhat.com> <20131001055346.GA4759@google.com> <20131002204141.GW12758@n2100.arm.linux.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Oct 2013 14:19:31 -0600
Message-ID: <CAErSpo4VOz=8EWPtzEDPnSt6kp77ZYptCahkDLkozcwzsgMaSw@mail.gmail.com>
Subject: Re: [PATCH v2] msi: free msi_desc entry only after we've released the kobject
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 2:41 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 30, 2013 at 10:53:46PM -0700, Bjorn Helgaas wrote:
>> I think the current kobject delayed release is too aggressive,
>
> I don't agree with that statement, but the rest of the sentence I do:

I think you're right.  I think we need to keep the delayed release the
way it is, and pay more attention to the way we remove things from
sysfs.

>> in the
>> sense that even after we've released all references, the object can
>> still be in sysfs, which causes future creates to fail.  E.g., this
>> fails:
>>
>>     kset = kset_create_and_add("kobj_test", NULL, NULL);
>>     kset_unregister(kset);
>>     kset = kset_create_and_add("kobj_test", NULL, NULL);  // FAILS
>>
>> when I think it should succeed.  We don't have a way for the caller to
>> determine when it's safe to do the second kset_create_and_add().
>
> The reason this happens is that for some reason I can't fathom, the
> sysfs cleanup is done when the release function is called, not when
> the object is unregistered.

Right.  I think we might want to have kset_unregister() call
kobject_del() explicitly.  That way the kset is removed from sysfs
immediately even if the release is delayed, and it is safe to create
another kset with the same name as soon as kset_register() returns.

Part of my confusion has been that I didn't connect "kobject_del()"
with the removal from sysfs (even though this is well-documented in
Documentation/kobject.txt).  I think using kobject_del()an important
part of fixing not only this MSI issue, but also races in the PCI
device removal path.  A name like "kobject_sysfs_unlink()" might be
more descriptive and help convey the idea that this is the point where
we prevent any future references via sysfs.

> I can see why that's done - it is so that when a kobject is unregistered,
> its sysfs entry hangs around until all the children have gone (and hence
> its reference count then hits zero.)
>
>> After we release all references, I think it's OK for the kobject
>> itself to continue to exist, i.e., we can delay calling t->release().
>> But it should be impossible to find a kobject with refcount == 0 via
>> sysfs, so we should be able to create a new one with the same name.
>>
>> In terms of code, I'm suggesting something like the following:
>
> I think I can give you an ack for this - it looks sensible enough, and
> should still have the intended debugging behaviour.  I haven't tested
> it though.
>
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.  I think I'm going to propose something like the patch below
instead.  It solves the kset_create_and_add(), kset_unregister(),
kset_create_and_add() problem as well.  I think we'll have to address
the MSI issue by adding kobject_del() in the appropriate places.

diff --git a/lib/kobject.c b/lib/kobject.c
index 9621751..9098992 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -753,6 +753,7 @@ void kset_unregister(struct kset *k)
 {
        if (!k)
                return;
+       kobject_del(&k->kobj);
        kobject_put(&k->kobj);
 }
