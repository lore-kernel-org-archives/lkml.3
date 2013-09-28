Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3I1Vja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab3I1Vj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:39:28 -0400
Date: Sat, 28 Sep 2013 23:37:27 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] msi: free msi_desc entry only after we've released
 the kobject
Message-ID: <20130928213727.GC32063@redhat.com>
References: <1380189591-1368-1-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1380189591-1368-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:59:51AM +0200, Veaceslav Falico wrote:
>Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
>however kobject_put() doesn't guarantee us that it was the last reference
>and that the kobj isn't used currently by someone else, so after we
>kfree(entry) with the struct kobject - other users will begin using the
>freed memory, instead of the actual kobject.

Hi Bjorn,

I've seen that you've dropped this bugfix (and the 3 cleanup patches) with
"Changes Requested", however I don't recall any request to change this.

I'm really sorry for bugging - but I need this fix to get included for my
testing to work :(.

This fix fixes the critical bug when we free the entry with the kobject
.../msi_irqs/IRQ_NR still being used, however the issue with msi_irqs kset
itself still exists, and really is a different issue - and I'm trying to
find a fix for it.

Thank you, and sorry for the mess and the noise.

>
>Fix this by using the kobject->release callback, which is called last when
>the kobject is indeed not used and is cleaned up - it's msi_kobj_release(),
>which can do the kfree(entry) safely (kobject_put/cleanup doesn't use the
>kobj itself after ->release() was called, so we're safe).
>
>In case we've failed to create the sysfs directories - just kfree()
>it - cause we don't have the kobjects attached.
>
>Also, remove the same functionality from populate_msi_sysfs(), cause on
>failure we anyway call free_msi_irqs(), which will take care of all the
>kobjects properly.
>
>And add the forgotten pci_dev_put(pdev) in case of failure to register the
>kobject in populate_msi_sysfs().
>
>CC: Bjorn Helgaas <bhelgaas@google.com>
>CC: Neil Horman <nhorman@tuxdriver.com>
>CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>CC: linux-pci@vger.kernel.org
>CC: linux-kernel@vger.kernel.org
>Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
>---
>
>Notes:
>    v1  -> v2:
>    Make it as a standalone patch, which is a bugfix, and add the forgotten
>    pci_dev_put() so that it won't break bisecting. The pci_dev_put() will
>    go away anyway in the following patchset, which cleans removes
>    kobject_del and useless pci_dev_get/put().  Rebased on linux-pci/next.
>
> drivers/pci/msi.c | 31 ++++++++++++-------------------
> 1 file changed, 12 insertions(+), 19 deletions(-)
>
>diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>index d5f90d6..5d70f49 100644
>--- a/drivers/pci/msi.c
>+++ b/drivers/pci/msi.c
>@@ -374,19 +374,22 @@ static void free_msi_irqs(struct pci_dev *dev)
> 				iounmap(entry->mask_base);
> 		}
>
>+		list_del(&entry->list);
>+
> 		/*
> 		 * Its possible that we get into this path
> 		 * When populate_msi_sysfs fails, which means the entries
> 		 * were not registered with sysfs.  In that case don't
>-		 * unregister them.
>+		 * unregister them, and just free. Otherwise the
>+		 * kobject->release will take care of freeing the entry via
>+		 * msi_kobj_release().
> 		 */
> 		if (entry->kobj.parent) {
> 			kobject_del(&entry->kobj);
> 			kobject_put(&entry->kobj);
>+		} else {
>+			kfree(entry);
> 		}
>-
>-		list_del(&entry->list);
>-		kfree(entry);
> 	}
> }
>
>@@ -509,6 +512,7 @@ static void msi_kobj_release(struct kobject *kobj)
> 	struct msi_desc *entry = to_msi_desc(kobj);
>
> 	pci_dev_put(entry->dev);
>+	kfree(entry);
> }
>
> static struct kobj_type msi_irq_ktype = {
>@@ -522,7 +526,6 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
> 	struct msi_desc *entry;
> 	struct kobject *kobj;
> 	int ret;
>-	int count = 0;
>
> 	pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
> 	if (!pdev->msi_kset)
>@@ -534,23 +537,13 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
> 		pci_dev_get(pdev);
> 		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
> 				     "%u", entry->irq);
>-		if (ret)
>-			goto out_unroll;
>-
>-		count++;
>+		if (ret) {
>+			pci_dev_put(pdev);
>+			return ret;
>+		}
> 	}
>
> 	return 0;
>-
>-out_unroll:
>-	list_for_each_entry(entry, &pdev->msi_list, list) {
>-		if (!count)
>-			break;
>-		kobject_del(&entry->kobj);
>-		kobject_put(&entry->kobj);
>-		count--;
>-	}
>-	return ret;
> }
>
> /**
>-- 
>1.8.4
>
