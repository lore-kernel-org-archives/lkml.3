Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbbAIUDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:03:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbbAIUDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:03:12 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] livepatch: fix deferred module patching order
Date: Fri,  9 Jan 2015 14:03:04 -0600
Message-Id: <47ab47fd3a2e7794edfe9b45b163582eee0a925c.1420833475.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When applying multiple patches to a module, if the module is loaded
after the patches are loaded, the patches are applied in reverse order:

  $ insmod patch1.ko
  [   43.172992] livepatch: enabling patch 'patch1'

  $ insmod patch2.ko
  [   46.571563] livepatch: enabling patch 'patch2'

  $ modprobe nfsd
  [   52.888922] livepatch: applying patch 'patch2' to loading module 'nfsd'
  [   52.899847] livepatch: applying patch 'patch1' to loading module 'nfsd'

Fix the loading order by storing the klp_patches list in queue order.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ce42d3b..3d9c00b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -739,7 +739,7 @@ static int klp_init_patch(struct klp_patch *patch)
 			goto free;
 	}
 
-	list_add(&patch->list, &klp_patches);
+	list_add_tail(&patch->list, &klp_patches);
 
 	mutex_unlock(&klp_mutex);
 
-- 
2.1.0

