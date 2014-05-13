Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaEMTpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:45:17 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35464 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaEMTpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:45:13 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 11/9] dt: deps: dtc: introduce new (virtual) property no-dependencies
Date: Tue, 13 May 2014 21:27:17 +0200
Message-Id: <1400009237-5012-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some rare cases it might make sense for not wanting an automatic
dependency for some used phandles.

E.g. if a cpu depends on a regulator which depends on i2c which depends
on some bus and you want that the bus depends on the cpu. That would
end up in a cycle. Usually such doesn't make sense because the hw doesn't
support such circular dependencies too (you always have to start somewhere
with initializing things). But e.g. in the case of the regulator the cpu
depends on, it's very likely that the regulator was initialized
automatically (otherwise the cpu won't run), so there is no real need to
initialize the regulator before the cpu. But that's just an example for
one of such rare cases where it might make sense to avoid an otherwise
automatically added dependency.

The syntax is like

	bar: whatever {
		...
	};
	foo {
		my-option = <&bar 1 2 3>;
		no-dependencies = <&bar>;
	};

Without that 'no-dependencies' property dtc would automatically add a
dependency to bar to the property 'dependencies' of the node foo.
But with that 'no-dependencies' it will not automatically add the
listed dependencies.

The property 'no-dependencies' is virtual property and will not be added
to any output file.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 scripts/dtc/dependencies.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/scripts/dtc/dependencies.c b/scripts/dtc/dependencies.c
index 4579f6f..06f447b 100644
--- a/scripts/dtc/dependencies.c
+++ b/scripts/dtc/dependencies.c
@@ -73,6 +73,16 @@ static void add_deps(struct node *dt, struct node *node, struct property *prop)
 				is_parent_of(target, source))
 			continue;
 		phandle = get_node_phandle(dt, target);
+		prop_deps = get_property(node, "no-dependencies");
+		if (prop_deps) {
+			/* avoid adding non-dependencies */
+			cell = (cell_t *)prop_deps->val.val;
+			for (i = 0; i < prop_deps->val.len/4; ++i)
+				if (*cell++ == cpu_to_fdt32(phandle))
+					break;
+			if (i < prop_deps->val.len/4)
+				continue;
+		}
 		prop_deps = get_property(source, "dependencies");
 		if (!prop_deps) {
 			add_property(source,
@@ -102,9 +112,21 @@ static void process_nodes_props(struct node *dt, struct node *node)
 		process_nodes_props(dt, child);
 }
 
+static void del_prop_no_dependencies(struct node *node)
+{
+	struct node *child;
+
+	if (!node)
+		return;
+	delete_property_by_name(node, "no-dependencies");
+	for_each_child(node, child)
+		del_prop_no_dependencies(child);
+}
+
 void add_dependencies(struct boot_info *bi)
 {
 	process_nodes_props(bi->dt, bi->dt);
+	del_prop_no_dependencies(bi->dt);
 }
 
 /*
-- 
1.8.3.1

