Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3H0BE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:04:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3H0BCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:02:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wladislav Wiebe <wladislav.kw@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [ 3/9] of: fdt: fix memory initialization for expanded DT
Date: Mon, 26 Aug 2013 18:04:54 -0700
Message-Id: <20130827010251.895068360@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010251.636183797@linuxfoundation.org>
References: <20130827010251.636183797@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/fdt.c |    2 ++
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


