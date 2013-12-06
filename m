Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3LFAiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:38:06 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54975 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3LFAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:38:04 -0500
Subject: [PATCH v2 2/2] kobject: remove kset from sysfs immediately in
 kset_unregister()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Date: Thu, 05 Dec 2013 17:38:00 -0700
Message-ID: <20131206003759.28684.63772.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131206003508.28684.1337.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131206003508.28684.1337.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no "unlink from sysfs" interface for ksets, so I think callers of
kset_unregister() expect the kset to be removed from sysfs immediately,
without waiting for the last reference to be released.

This patch makes the sysfs removal happen immediately, so the caller may
create a new kset with the same name as soon as kset_unregister() returns.
Without this, every caller has to call "kobject_del(&kset->kobj)" first
unless it knows it will never create a new kset with the same name.

This sometimes shows up on module unload and reload, where the reload fails
because it tries to create a kobject with the same name as one from the
original load that still exists.  CONFIG_DEBUG_KOBJECT_RELEASE=y makes this
problem easier to hit.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/kobject.txt |    5 ++++-
 lib/kobject.c             |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index c5182bb2c16c..f87241dfed87 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -342,7 +342,10 @@ kset use:
 
 When you are finished with the kset, call:
   void kset_unregister(struct kset *kset);
-to destroy it.
+to destroy it.  This removes the kset from sysfs and decrements its reference
+count.  When the reference count goes to zero, the kset will be released.
+Because other references to the kset may still exist, the release may happen
+after kset_unregister() returns.
 
 An example of using a kset can be seen in the
 samples/kobject/kset-example.c file in the kernel tree.
diff --git a/lib/kobject.c b/lib/kobject.c
index bc73312ac797..40e3b2c0abae 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -757,6 +757,7 @@ void kset_unregister(struct kset *k)
 {
 	if (!k)
 		return;
+	kobject_del(&k->kobj);
 	kobject_put(&k->kobj);
 }
 

