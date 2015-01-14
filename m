Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbbANGeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:34:50 -0500
Received: from smtp.ispras.ru ([83.149.199.79]:54775 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbbANGet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:34:49 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 01:34:48 EST
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
Date: Wed, 14 Jan 2015 09:25:08 +0300
Message-Id: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_args call module parameters' .set handlers, which may use locks defined in the module.
So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).

Signed-off-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
---
 kernel/module.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 3965511..2b44de4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3311,6 +3311,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	module_bug_cleanup(mod);
 	mutex_unlock(&module_mutex);
 
+	/* Free lock-classes: */
+	lockdep_free_key_range(mod->module_core, mod->core_size);
+
 	/* we can't deallocate the module until we clear memory protection */
 	unset_module_init_ro_nx(mod);
 	unset_module_core_ro_nx(mod);
-- 
1.8.3.1

