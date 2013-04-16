Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab3DPSbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164Ab3DPS0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 13/28] airo: Use remove_proc_subtree() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-wireless@vger.kernel.org,
        viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:26:43 +0100
Message-ID: <20130416182643.27773.14779.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use remove_proc_subtree() to remove the airo device subdir and all its
children instead of doing it manually.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-wireless@vger.kernel.org
---

 drivers/net/wireless/airo.c |   49 +++++++++++--------------------------------
 1 file changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 21d0233..6125adb 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4506,98 +4506,75 @@ static int setup_proc_entry( struct net_device *dev,
 	apriv->proc_entry = proc_mkdir_mode(apriv->proc_name, airo_perm,
 					    airo_entry);
 	if (!apriv->proc_entry)
-		goto fail;
+		return -ENOMEM;
 	proc_set_user(apriv->proc_entry, proc_kuid, proc_kgid);
 
 	/* Setup the StatsDelta */
 	entry = proc_create_data("StatsDelta", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_statsdelta_ops, dev);
 	if (!entry)
-		goto fail_stats_delta;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the Stats */
 	entry = proc_create_data("Stats", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_stats_ops, dev);
 	if (!entry)
-		goto fail_stats;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the Status */
 	entry = proc_create_data("Status", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_status_ops, dev);
 	if (!entry)
-		goto fail_status;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the Config */
 	entry = proc_create_data("Config", proc_perm,
 				 apriv->proc_entry, &proc_config_ops, dev);
 	if (!entry)
-		goto fail_config;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the SSID */
 	entry = proc_create_data("SSID", proc_perm,
 				 apriv->proc_entry, &proc_SSID_ops, dev);
 	if (!entry)
-		goto fail_ssid;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the APList */
 	entry = proc_create_data("APList", proc_perm,
 				 apriv->proc_entry, &proc_APList_ops, dev);
 	if (!entry)
-		goto fail_aplist;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the BSSList */
 	entry = proc_create_data("BSSList", proc_perm,
 				 apriv->proc_entry, &proc_BSSList_ops, dev);
 	if (!entry)
-		goto fail_bsslist;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the WepKey */
 	entry = proc_create_data("WepKey", proc_perm,
 				 apriv->proc_entry, &proc_wepkey_ops, dev);
 	if (!entry)
-		goto fail_wepkey;
+		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 	return 0;
 
-fail_wepkey:
-	remove_proc_entry("BSSList", apriv->proc_entry);
-fail_bsslist:
-	remove_proc_entry("APList", apriv->proc_entry);
-fail_aplist:
-	remove_proc_entry("SSID", apriv->proc_entry);
-fail_ssid:
-	remove_proc_entry("Config", apriv->proc_entry);
-fail_config:
-	remove_proc_entry("Status", apriv->proc_entry);
-fail_status:
-	remove_proc_entry("Stats", apriv->proc_entry);
-fail_stats:
-	remove_proc_entry("StatsDelta", apriv->proc_entry);
-fail_stats_delta:
-	remove_proc_entry(apriv->proc_name, airo_entry);
 fail:
+	remove_proc_subtree(apriv->proc_name, airo_entry);
 	return -ENOMEM;
 }
 
 static int takedown_proc_entry( struct net_device *dev,
-				struct airo_info *apriv ) {
-	if ( !apriv->proc_entry->namelen ) return 0;
-	remove_proc_entry("Stats",apriv->proc_entry);
-	remove_proc_entry("StatsDelta",apriv->proc_entry);
-	remove_proc_entry("Status",apriv->proc_entry);
-	remove_proc_entry("Config",apriv->proc_entry);
-	remove_proc_entry("SSID",apriv->proc_entry);
-	remove_proc_entry("APList",apriv->proc_entry);
-	remove_proc_entry("BSSList",apriv->proc_entry);
-	remove_proc_entry("WepKey",apriv->proc_entry);
-	remove_proc_entry(apriv->proc_name,airo_entry);
+				struct airo_info *apriv )
+{
+	remove_proc_subtree(apriv->proc_name, airo_entry);
 	return 0;
 }
 

