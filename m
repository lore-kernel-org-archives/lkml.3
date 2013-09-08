Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab3IHDqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:46:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56083 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab3IHDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Alexander Sverdlin" <alexander.sverdlin@nsn.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Wladislav Wiebe" <wladislav.kw@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.145739295@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [084/121] of: fdt: fix memory initialization for expanded DT
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/of/fdt.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -389,6 +389,8 @@ static void __unflatten_device_tree(stru
 	mem = (unsigned long)
 		dt_alloc(size + 4, __alignof__(struct device_node));
 
+	memset((void *)mem, 0, size);
+
 	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
 
 	pr_debug("  unflattening %lx...\n", mem);

