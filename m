Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3ICQ1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:27:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46510 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3ICQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 53/58] of: fdt: fix memory initialization for expanded DT
Date: Tue,  3 Sep 2013 09:23:57 -0700
Message-Id: <1378225442-20654-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wladislav Wiebe <wladislav.kw@gmail.com>

commit 9e40127526e857fa3f29d51e83277204fbdfc6ba upstream.

Already existing property flags are filled wrong for properties created from
initial FDT. This could cause problems if this DYNAMIC device-tree functions
are used later, i.e. properties are attached/detached/replaced. Simply dumping
flags from the running system show, that some initial static (not allocated via
kzmalloc()) nodes are marked as dynamic.

I putted some debug extensions to property_proc_show(..) :
..
+       if (OF_IS_DYNAMIC(pp))
+               pr_err("DEBUG: xxx : OF_IS_DYNAMIC\n");
+       if (OF_IS_DETACHED(pp))
+               pr_err("DEBUG: xxx : OF_IS_DETACHED\n");

when you operate on the nodes (e.g.: ~$ cat /proc/device-tree/*some_node*) you
will see that those flags are filled wrong, basically in most cases it will dump
a DYNAMIC or DETACHED status, which is in not true.
(BTW. this OF_IS_DETACHED is a own define for debug purposes which which just
make a test_bit(OF_DETACHED, &x->_flags)

If nodes are dynamic kernel is allowed to kfree() them. But it will crash
attempting to do so on the nodes from FDT -- they are not allocated via
kzmalloc().

Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
Acked-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/of/fdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 808be06..1187737 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -392,6 +392,8 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 	mem = (unsigned long)
 		dt_alloc(size + 4, __alignof__(struct device_node));
 
+	memset((void *)mem, 0, size);
+
 	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
 
 	pr_debug("  unflattening %lx...\n", mem);
-- 
1.8.1.2

