Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3JHUUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:20:45 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:52730 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3JHUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:20:20 -0400
Subject: [PATCH 1/2] kobject: remove kset from sysfs immediately in
 kset_unregister()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Date: Tue, 08 Oct 2013 14:20:16 -0600
Message-ID: <20131008202016.19377.17182.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no explicit "unlink from sysfs" interface for ksets, so I think
callers of kset_unregister() expect the kset to be removed from sysfs
immediately, without waiting for the last reference to be released.

This patch makes the sysfs removal happen immediately, so the caller may
create a new kset with the same name as soon as kset_unregister() returns.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/kobject.txt |    3 ++-
 lib/kobject.c             |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index c5182bb..8e8b501 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -342,7 +342,8 @@ kset use:
 
 When you are finished with the kset, call:
   void kset_unregister(struct kset *kset);
-to destroy it.
+to destroy it.  This removes the kset from sysfs and, after the kset
+reference count goes to zero, releases it.
 
 An example of using a kset can be seen in the
 samples/kobject/kset-example.c file in the kernel tree.
diff --git a/lib/kobject.c b/lib/kobject.c
index 9621751..9098992 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -753,6 +753,7 @@ void kset_unregister(struct kset *k)
 {
 	if (!k)
 		return;
+	kobject_del(&k->kobj);
 	kobject_put(&k->kobj);
 }
 

