Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbbAUJJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:09:32 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:44829 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbAUJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:09:17 -0500
From: Li Bin <huawei.libin@huawei.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Miroslav Benes <mbenes@suse.cz>
CC: <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <xiexiuqi@huawei.com>
Subject: [PATCH 2/2] livepatch: disable/enable_patch manners for interdependent patches
Date: Wed, 21 Jan 2015 17:07:42 +0800
Message-ID: <1421831262-27869-3-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54BF6CAB.0016,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 407262236e2ec464e5924ea714205ce5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for disable_patch:
The patch is unallowed to be disabled if one patch after has
dependencies with it and has been enabled.

for enable_patch:
The patch is unallowed to be enabled if one patch before has
dependencies with it and has been disabled.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/livepatch/core.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 7861ed2..a12a31c 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -114,6 +114,21 @@ static bool klp_is_patch_registered(struct klp_patch *patch)
 	return false;
 }
 
+static bool klp_func_in_patch(struct klp_func *kfunc, struct klp_patch *patch)
+{
+	struct klp_object *obj;
+	struct klp_func *func;
+
+	for (obj = patch->objs; obj->funcs; obj++) {
+		for (func = obj->funcs; func->old_name; func++) {
+			if (kfunc->old_addr == func->old_addr) {
+				return true;
+			}
+		}
+	}
+	return false;
+}
+
 static bool klp_initialized(void)
 {
 	return klp_root_kobj;
@@ -466,8 +481,31 @@ unregister:
 static int __klp_disable_patch(struct klp_patch *patch)
 {
 	struct klp_object *obj;
+	struct klp_patch *temp;
+	struct klp_func *func;
 	int ret;
 
+	/*
+	 * the patch is unallowed to be disabled if one patch
+	 * after has dependencies with it and has been enabled.
+	 */
+	for (temp = list_next_entry(patch, list);
+			&temp->list != &klp_patches;
+			temp = list_next_entry(temp, list)) {
+		if (temp->state != KLP_ENABLED)
+			continue;
+
+		for (obj = patch->objs; obj->funcs; obj++) {
+			for (func = obj->funcs; func->old_name; func++) {
+				if (klp_func_in_patch(func, temp)) {
+					pr_err("this patch depends on '%s', please disable it firstly\n",
+						   temp->mod->name);
+					return -EBUSY;
+				}
+			}
+		}
+	}
+
 	pr_notice("disabling patch '%s'\n", patch->mod->name);
 
 	for (obj = patch->objs; obj->funcs; obj++) {
@@ -519,11 +557,33 @@ EXPORT_SYMBOL_GPL(klp_disable_patch);
 static int __klp_enable_patch(struct klp_patch *patch)
 {
 	struct klp_object *obj;
+	struct klp_patch *temp;
+	struct klp_func *func;
 	int ret;
 
 	if (WARN_ON(patch->state != KLP_DISABLED))
 		return -EINVAL;
 
+	/*
+	 * the patch is unallowed to be enabled if one patch
+	 * before has dependencies with it and has been disabled.
+	 */
+	for (temp = list_first_entry(&klp_patches, struct klp_patch, list);
+			temp != patch; temp = list_next_entry(temp, list)) {
+		if (temp->state != KLP_DISABLED)
+			continue;
+
+		for (obj = patch->objs; obj->funcs; obj++) {
+			for (func = obj->funcs; func->old_name; func++) {
+				if (klp_func_in_patch(func, temp)) {
+					pr_err("this patch depends on '%s', please enable it firstly\n",
+						   temp->mod->name);
+					return -EBUSY;
+				}
+			}
+		}
+	}
+
 	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
 	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
 
-- 
1.7.1

