Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3IKE6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3IKE4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:55 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nF_q0J2ESrQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yZjuEEt36nsA:10 a=pGLkceISAAAA:8 a=02K0Y2VpAAAA:8 a=VwQbUJbxAAAA:8 a=tJ25mWANAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=MSl-tDqOz04A:10 a=zwC7bnKO5xoA:10 a=LLeF4spgIVoA:10 a=jeBq3FmKZ4MA:10 a=GED_LIiEBe0A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042929.513749552@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [224/251] of: fdt: fix memory initialization for expanded DT
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0224-of-fdt-fix-memory-initialization-for-expanded-DT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wladislav Wiebe <wladislav.kw@gmail.com>

[ Upstream commit 9e40127526e857fa3f29d51e83277204fbdfc6ba ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/of/fdt.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..17fad3b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -390,6 +390,8 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 	mem = (unsigned long)
 		dt_alloc(size + 4, __alignof__(struct device_node));
 
+	memset((void *)mem, 0, size);
+
 	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
 
 	pr_debug("  unflattening %lx...\n", mem);
-- 
1.7.10.4


