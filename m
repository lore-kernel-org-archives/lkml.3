Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935934Ab3BOMpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935914Ab3BOMpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:18 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 01/13] edac: lock module owner to avoid error report conflicts
Date: Fri, 15 Feb 2013 10:44:49 -0200
Message-Id: <7bcfdab898ef7b1d24431ca01d5895f1d4659f89.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APEI GHES and i7core_edac/sb_edac currently can be loaded at
the same time, but those are Highlander modules:
	"There can be only one".

There are two reasons for that:

1) Each driver assumes that it is the only one registering at
   the EDAC core, as it is driver's responsibility to number
   the memory controllers, and all of them start from 0;

2) If BIOS is handling the memory errors, the OS can't also be
   doing it, as one will mangle with the other.

So, we need to add an module owner's lock at the EDAC core,
in order to avoid having two different modules handling memory
errors at the same time. The best way for doing this lock seems
to use the driver's name, as this is unique, and won't require
changes on every driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index fb219bc..8e58b1c 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -42,6 +42,12 @@
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
 
+/*
+ * Used to lock EDAC MC to just one module, avoiding two drivers e. g.
+ *	apei/ghes and i7core_edac to be used at the same time.
+ */
+static void const *edac_mc_owner;
+
 unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
 			         unsigned len)
 {
@@ -659,9 +665,9 @@ fail1:
 	return 1;
 }
 
-static void del_mc_from_global_list(struct mem_ctl_info *mci)
+static int del_mc_from_global_list(struct mem_ctl_info *mci)
 {
-	atomic_dec(&edac_handlers);
+	int handlers = atomic_dec_return(&edac_handlers);
 	list_del_rcu(&mci->link);
 
 	/* these are for safe removal of devices from global list while
@@ -669,6 +675,8 @@ static void del_mc_from_global_list(struct mem_ctl_info *mci)
 	 */
 	synchronize_rcu();
 	INIT_LIST_HEAD(&mci->link);
+
+	return handlers;
 }
 
 /**
@@ -712,6 +720,7 @@ EXPORT_SYMBOL(edac_mc_find);
 /* FIXME - should a warning be printed if no error detection? correction? */
 int edac_mc_add_mc(struct mem_ctl_info *mci)
 {
+	int ret = -EINVAL;
 	edac_dbg(0, "\n");
 
 #ifdef CONFIG_EDAC_DEBUG
@@ -742,6 +751,11 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 #endif
 	mutex_lock(&mem_ctls_mutex);
 
+	if (edac_mc_owner && edac_mc_owner != mci->mod_name) {
+		ret = -EPERM;
+		goto fail0;
+	}
+
 	if (add_mc_to_global_list(mci))
 		goto fail0;
 
@@ -768,6 +782,8 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to '%s' '%s':"
 		" DEV %s\n", mci->mod_name, mci->ctl_name, edac_dev_name(mci));
 
+	edac_mc_owner = mci->mod_name;
+
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
@@ -776,7 +792,7 @@ fail1:
 
 fail0:
 	mutex_unlock(&mem_ctls_mutex);
-	return 1;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
 
@@ -802,7 +818,9 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 		return NULL;
 	}
 
-	del_mc_from_global_list(mci);
+	if (!del_mc_from_global_list(mci)) {
+		edac_mc_owner = NULL;
+	}
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* flush workq processes */
-- 
1.8.1.2

