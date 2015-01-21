Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbbAUJJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:09:54 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38758 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbAUJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:09:37 -0500
From: Li Bin <huawei.libin@huawei.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Miroslav Benes <mbenes@suse.cz>
CC: <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <xiexiuqi@huawei.com>
Subject: [PATCH 1/2] livepatch: Revert "livepatch: enforce patch stacking semantics"
Date: Wed, 21 Jan 2015 17:07:41 +0800
Message-ID: <1421831262-27869-2-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 83a90bb1345767f0cb96d242fd8b9db44b2b0e17.

The method that only allowing the topmost patch on the stack to be
enabled or disabled is unreasonable. Such as the following case:

	- do live patch1
	- disable patch1
	- do live patch2 //error

Now, we will never be able to do new live patch unless disabing the
patch1 although there is no dependencies.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/livepatch/core.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc05d39..7861ed2 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -468,11 +468,6 @@ static int __klp_disable_patch(struct klp_patch *patch)
 	struct klp_object *obj;
 	int ret;
 
-	/* enforce stacking: only the last enabled patch can be disabled */
-	if (!list_is_last(&patch->list, &klp_patches) &&
-	    list_next_entry(patch, list)->state == KLP_ENABLED)
-		return -EBUSY;
-
 	pr_notice("disabling patch '%s'\n", patch->mod->name);
 
 	for (obj = patch->objs; obj->funcs; obj++) {
@@ -529,11 +524,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	if (WARN_ON(patch->state != KLP_DISABLED))
 		return -EINVAL;
 
-	/* enforce stacking: only the first disabled patch can be enabled */
-	if (patch->list.prev != &klp_patches &&
-	    list_prev_entry(patch, list)->state == KLP_DISABLED)
-		return -EBUSY;
-
 	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
 	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
 
-- 
1.7.1

