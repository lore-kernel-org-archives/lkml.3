Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbaD1T5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:57:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28072 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933058AbaD1Tx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:28 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 01/10] of: Keep track of populated platform devices
Date: Mon, 28 Apr 2014 18:57:48 +0100
Message-Id: <1398707877-22596-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In "Device Tree powered" systems, platform devices are usually
massively populated with of_platform_populate() call, executed
at some level of initcalls, either by generic architecture
or by platform-specific code.

There are situations though where certain devices must be
created (and bound with drivers) before all the others.
This presents a challenge, as devices created explicitly
would be created again by of_platform_populate().

This patch tries to solve that issue in a generic way,
adding a "populated" flag for a DT node description.
Once set, this device will never be created again via
of_* API, so of_platform_populate() will skip such nodes
(and its children) in a similar way to the non-available
ones.

Cc: devicetree@vger.kernel.org
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/of/platform.c | 10 ++++++++--
 include/linux/of.h    |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..0ae757a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -204,7 +204,8 @@ static struct platform_device *of_platform_device_create_pdata(
 {
 	struct platform_device *dev;
 
-	if (!of_device_is_available(np))
+	if (!of_device_is_available(np) ||
+			of_node_check_flag(np, OF_POPULATED))
 		return NULL;
 
 	dev = of_device_alloc(np, bus_id, parent);
@@ -230,6 +231,8 @@ static struct platform_device *of_platform_device_create_pdata(
 		return NULL;
 	}
 
+	of_node_set_flag(np, OF_POPULATED);
+
 	return dev;
 }
 
@@ -262,7 +265,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 
 	pr_debug("Creating amba device %s\n", node->full_name);
 
-	if (!of_device_is_available(node))
+	if (!of_device_is_available(node) ||
+			of_node_check_flag(node, OF_POPULATED))
 		return NULL;
 
 	dev = amba_device_alloc(NULL, 0, 0);
@@ -305,6 +309,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 		goto err_free;
 	}
 
+	of_node_set_flag(node, OF_POPULATED);
+
 	return dev;
 
 err_free:
diff --git a/include/linux/of.h b/include/linux/of.h
index 3bad8d1..fd3aaee 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -197,6 +197,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 /* flag descriptions */
 #define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
 #define OF_DETACHED	2 /* node has been detached from the device tree */
+#define OF_POPULATED	3 /* device already created for the node */
 
 #define OF_IS_DYNAMIC(x) test_bit(OF_DYNAMIC, &x->_flags)
 #define OF_MARK_DYNAMIC(x) set_bit(OF_DYNAMIC, &x->_flags)
-- 
1.9.1

