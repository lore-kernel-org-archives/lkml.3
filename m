Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab3GKEHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:07:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62616 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3GKEHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:07:42 -0400
X-Spam-Score: -100.8
Message-ID: <51DE2F55.2070109@asianux.com>
Date: Thu, 11 Jul 2013 12:06:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: khali@linux-fr.org, David.Woodhouse@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel/params.c: add/modify failure processing code when
 sysfs_create_file() fails.
References: <51DB8597.4090101@asianux.com> <87y59gcg17.fsf@rustcorp.com.au> <51DCC426.3010606@gmail.com> <87k3kx50bp.fsf@rustcorp.com.au>
In-Reply-To: <87k3kx50bp.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sysfs_create_file() fails, need consider about it. And process it
with BUG_ON(), because sysfs_create_file() can fail due to OOM (not at
boot) or name duplication (not here).

Also correct the error printing information when failure occurs.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/params.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 440e65d..3d70f90 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -745,12 +745,14 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
 					   "%s", name);
 #ifdef CONFIG_MODULES
-		if (!err)
+		if (!err) {
 			err = sysfs_create_file(&mk->kobj, &module_uevent.attr);
+			BUG_ON(err);
+		}
 #endif
 		if (err) {
 			kobject_put(&mk->kobj);
-			pr_crit("Adding module '%s' to sysfs failed (%d), the system may be unstable.\n",
+			pr_crit("Initializing and adding module '%s' failed (%d), the system may be unstable.\n",
 				name, err);
 			return NULL;
 		}
@@ -845,6 +847,7 @@ static void __init version_sysfs_builtin(void)
 		mk = locate_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
+			BUG_ON(err);
 			kobject_uevent(&mk->kobj, KOBJ_ADD);
 			kobject_put(&mk->kobj);
 		}
-- 
1.7.7.6
