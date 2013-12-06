Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3LFAiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:38:00 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39313 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab3LFAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:37:55 -0500
Subject: [PATCH v2 1/2] kobject: delay kobject release for random time
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Date: Thu, 05 Dec 2013 17:37:51 -0700
Message-ID: <20131206003751.28684.32460.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131206003508.28684.1337.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131206003508.28684.1337.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_DEBUG_KOBJECT_RELEASE=y, delay kobject release functions for a
random time between 1 and 8 seconds, which effectively changes the order in
which they're called.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 lib/kobject.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 962175134702..bc73312ac797 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 
 /*
  * populate_dir - populate directory with attributes.
@@ -592,10 +593,13 @@ static void kobject_release(struct kref *kref)
 {
 	struct kobject *kobj = container_of(kref, struct kobject, kref);
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-	pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
-		 kobject_name(kobj), kobj, __func__, kobj->parent);
+	unsigned long delay = HZ + HZ * (get_random_int() & 0x3);
+
+	pr_debug("kobject: '%s' (%p): %s, parent %p (delayed %ld)\n",
+		 kobject_name(kobj), kobj, __func__, kobj->parent, delay);
 	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
-	schedule_delayed_work(&kobj->release, HZ);
+
+	schedule_delayed_work(&kobj->release, delay);
 #else
 	kobject_cleanup(kobj);
 #endif

