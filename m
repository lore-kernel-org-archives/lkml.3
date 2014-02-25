Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaBYO7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:59:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59509 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaBYO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:58:56 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 3/3] Documentation: of: Document graph bindings
Date: Tue, 25 Feb 2014 15:58:24 +0100
Message-Id: <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree graph bindings as used by V4L2 and documented in
Documentation/device-tree/bindings/media/video-interfaces.txt contain
generic parts that are not media specific but could be useful for any
subsystem with data flow between multiple devices. This document
describe the generic bindings.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/devicetree/bindings/graph.txt | 98 +++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/graph.txt

diff --git a/Documentation/devicetree/bindings/graph.txt b/Documentation/devicetree/bindings/graph.txt
new file mode 100644
index 0000000..97c877e
--- /dev/null
+++ b/Documentation/devicetree/bindings/graph.txt
@@ -0,0 +1,98 @@
+Common bindings for device graphs
+
+General concept
+---------------
+
+The hierarchical organisation of the device tree is well suited to describe
+control flow to devices, but data flow between devices that work together to
+form a logical compound device can follow arbitrarily complex graphs.
+The device tree graph bindings allow to describe data bus connections between
+individual devices, that can not be inferred from device tree parent-child
+relationships. The common bindings do not contain any information about the
+direction or type of data flow, they just map connections. Specific properties
+of the connections are described by specialized bindings depending on the type
+of connection. To see how this binding applies to video pipelines, see for
+example Documentation/device-tree/bindings/media/video-interfaces.txt.
+
+Devices can have multiple data interfaces, each of which can be connected to
+the data interfaces of one or more remote devices via a data bus.
+Data interfaces are described by the device nodes' child 'port' nodes. A port
+node contains an 'endpoint' subnode for each remote device port connected to
+this port via a bus. If a port is connected to more than one remote device on
+the same bus, an 'endpoint' child node must be provided for each of them. If
+more than one port is present in a device node or there is more than one
+endpoint at a port, or port node needs to be associated with a selected
+hardware interface, a common scheme using '#address-cells', '#size-cells'
+and 'reg' properties is used.
+
+device {
+        ...
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port@0 {
+                ...
+                endpoint@0 { ... };
+                endpoint@1 { ... };
+        };
+
+        port@1 { ... };
+};
+
+All 'port' nodes can be grouped under optional 'ports' node, which allows to
+specify #address-cells, #size-cells properties independently for the 'port'
+and 'endpoint' nodes and any child device nodes a device might have.
+
+device {
+        ...
+        ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                        ...
+                        endpoint@0 { ... };
+                        endpoint@1 { ... };
+                };
+
+                port@1 { ... };
+        };
+};
+
+Each endpoint can contain a 'remote-endpoint' phandle property that points to
+the corresponding endpoint in the port of the remote device. Two 'endpoint'
+nodes are linked with each other through their 'remote-endpoint' phandles.
+
+device_1 {
+        port {
+                device_1_output: endpoint {
+                        remote-endpoint = <&device_2_input>;
+                };
+        };
+};
+
+device_1 {
+        port {
+                device_2_input: endpoint {
+                        remote-endpoint = <&device_1_output>;
+                };
+        };
+};
+
+
+Required properties
+-------------------
+
+If there is more than one 'port' or more than one 'endpoint' node or 'reg'
+property is present in port and/or endpoint nodes the following properties
+are required in a relevant parent node:
+
+ - #address-cells : number of cells required to define port/endpoint
+                    identifier, should be 1.
+ - #size-cells    : should be zero.
+
+Optional endpoint properties
+----------------------------
+
+- remote-endpoint: phandle to an 'endpoint' subnode of a remote device node.
+
-- 
1.8.5.3

