Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3JHUUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:20:22 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:58147 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3JHUUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:20:13 -0400
Subject: [PATCH 0/2] Remove ksets from sysfs eagerly
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Date: Tue, 08 Oct 2013 14:20:07 -0600
Message-ID: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUG_KOBJECT_RELEASE=y, kobject release is delayed even after
the last reference to the object is dropped.

With this turned on, Veaceslav and Zdenek noticed that when we enable,
disable, and re-enable MSIs, we often see errors like "sysfs: cannot create
duplicate filename '/devices/pci0000:00/.../msi_irqs'".  This happens
when we unload and reload drivers that use MSI.

The reason is that the MSI disable path uses kset_unregister(dev->msi_kset),
which doesn't remove the kset from sysfs until the the kobject release
function is called.  With CONFIG_DEBUG_KOBJECT_RELEASE, the release is
obviously delayed, but even without it, the release will be delayed if
somebody has the kset sysfs file open when kset_unregister() is called.

We could work around this by explicitly calling
"kobject_del(&dev->msi_kset->kobj)", but that seems clunky and other
kset_unregister() users are likely to have similar problems.

The idea of this patch is to make kset_unregister() unlink the kset from
sysfs immediately, before dropping the kset reference.

---

Bjorn Helgaas (2):
      kobject: remove kset from sysfs immediately in kset_unregister()
      kobject: fix kset sample error path


 Documentation/kobject.txt      |    3 ++-
 lib/kobject.c                  |    1 +
 samples/kobject/kset-example.c |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)
