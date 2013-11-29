Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3K2Bjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:39:32 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43304 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3K2Bj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:26 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 06/12] thunderbolt: Add thunderbolt capability handling
Date: Fri, 29 Nov 2013 02:35:43 +0100
Message-Id: <1385688949-7101-7-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt config areas contain capability lists similar to those found
on pci devices. This patch introduces a tb_find_cap utility method to search
for capabilities.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h |   2 +
 2 files changed, 105 insertions(+)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index d2df3be..943842b 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -89,6 +89,109 @@ static int tb_route_length(u64 route)
 	return (fls64(route) + TB_ROUTE_SHIFT - 1) / TB_ROUTE_SHIFT;
 }
 
+
+/* thunderbolt capability lookup */
+
+struct tb_cap_any {
+	union {
+		struct tb_cap_basic basic;
+		struct tb_cap_extended_short extended_short;
+		struct tb_cap_extended_long extended_long;
+	};
+} __packed;
+
+static bool tb_cap_is_basic(struct tb_cap_any *cap)
+{
+	/* basic.cap is u8. This checks only the lower 8 bit of cap. */
+	return cap->basic.cap != 5;
+}
+
+static bool tb_cap_is_long(struct tb_cap_any *cap)
+{
+	return !tb_cap_is_basic(cap)
+	       && cap->extended_short.next == 0
+	       && cap->extended_short.length == 0;
+}
+
+static enum tb_cap tb_cap(struct tb_cap_any *cap)
+{
+	if (tb_cap_is_basic(cap))
+		return cap->basic.cap;
+	else
+		/* extended_short/long have cap at the same position. */
+		return cap->extended_short.cap;
+}
+
+static u32 tb_cap_next(struct tb_cap_any *cap, u32 offset)
+{
+	int next;
+	if (offset == 1) {
+		/*
+		 * The first pointer is part of the switch header and always
+		 * a simple pointer.
+		 */
+		next = cap->basic.next;
+	} else {
+		if (tb_cap_is_basic(cap))
+			next = cap->basic.next;
+		/* "255 byte config areas should be enough for anybody." */
+		else if (!tb_cap_is_long(cap))
+			next = cap->extended_short.next;
+		/*
+		 * "Also we should have at least three types of capability
+		 *  headers in version 1."
+		 */
+		else
+			next = cap->extended_long.next;
+	}
+	/*
+	 * "Hey, we could terminate some capability lists with a null offset
+	 *  and others with a pointer to the last element." - "Great idea!"
+	 */
+	if (next == offset)
+		return 0;
+	return next;
+}
+
+/**
+ * tb_find_cap() - find a capability
+ *
+ * Return: Returns a positive offset if the capability was found and 0 if not.
+ * Returns an error code on failure.
+ */
+int tb_find_cap(struct tb_port *port, enum tb_cfg_space space, enum tb_cap cap)
+{
+	u32 offset = 1;
+	struct tb_cap_any header;
+	int res;
+	int retries = 10;
+	while (retries--) {
+		res = tb_port_read(port, &header, space, offset, 1);
+		if (res) {
+			/* Intel needs some help with linked lists. */
+			if (space == TB_CFG_PORT
+			    && offset == 0xa
+			    && port->config.type == TB_TYPE_DP_HDMI_OUT) {
+				offset = 0x39;
+				continue;
+			}
+			return res;
+		}
+		if (offset != 1 && tb_cap(&header) == cap)
+			return offset;
+		offset = tb_cap_next(&header, offset);
+		if (!offset)
+			return 0;
+		continue;
+	}
+	tb_port_WARN(port,
+		     "could not find cap %#x in config space %d, last offset: %#x\n",
+		     cap,
+		     space,
+		     offset);
+	return -EIO;
+}
+
 /* switch/port allocation & initialization */
 
 /**
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 4000f2b..e81c63a 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -144,4 +144,6 @@ static inline int tb_port_write(struct tb_port *port, void *buffer,
 struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi);
 void thunderbolt_shutdown_and_free(struct tb *tb);
 
+int tb_find_cap(struct tb_port *port, enum tb_cfg_space space, u32 value);
+
 #endif
-- 
1.8.4.2

