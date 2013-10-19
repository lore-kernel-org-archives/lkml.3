Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3JSOjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:39:25 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:34723 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab3JSOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org,>);
	Sat, 19 Oct 2013 10:39:21 -0400
X-RRZE-Submit-IP: 212.255.122.85
From: Dominik Paulus <dominik.paulus@fau.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, tobias.polzer@fau.de,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: [PATCHv4 03/16] staging: usbip: Add CIDR matching helper functions
Date: Sat, 19 Oct 2013 16:39:06 +0200
Message-Id: <1382193559-12549-4-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a few utility functions to match IP addresses against
CIDR masks.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/src/utils.c | 84 +++++++++++++++++++++++++++++
 drivers/staging/usbip/userspace/src/utils.h | 15 ++++++
 2 files changed, 99 insertions(+)

diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 2d4966e..df40817 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -74,3 +74,87 @@ int modify_match_busid(char *busid, int add)
 
 	return ret;
 }
+
+/*
+ * Parses a string of form "ip/prefix" into a subnet mask to dest.
+ * Returns -1 on error, 0 on success
+ */
+int parse_cidr(const char *src, struct subnet *dest)
+{
+	char *ip, *prefix, *saveptr;
+	char *endptr;
+	struct in6_addr ip6;
+	struct in_addr ip4;
+	int bits;
+	long int tmp;
+	char buf[128]; /* For strtok */
+
+	strncpy(buf, src, sizeof(buf));
+	buf[sizeof(buf)-1] = 0;
+
+	ip = strtok_r(buf, "/", &saveptr);
+	prefix = strtok_r(NULL, "/", &saveptr);
+	if (strtok_r(NULL, "/", &saveptr) || !ip ||
+			strlen(src) > sizeof(buf) - 1)
+		return -1;
+
+	if (inet_pton(AF_INET6, ip, &ip6) == 1) {
+		dest->ai_family = AF_INET6;
+		bits = 128;
+		dest->address.ip6 = ip6;
+	} else if (inet_pton(AF_INET, ip, &ip4) == 1) {
+		dest->ai_family = AF_INET;
+		bits = 32;
+		dest->address.ip4 = ip4;
+	} else {
+		return -1;
+	}
+
+	/*
+	 * We also accept single IPs without an explicitely
+	 * specified prefix
+	 */
+	if (prefix) {
+		tmp = strtol(prefix, &endptr, 10);
+		if (tmp < 0 || tmp > bits || *endptr != '\0')
+			return -1;
+		dest->prefix = tmp;
+	} else {
+		dest->prefix = bits;
+	}
+
+	return 0;
+}
+
+/*
+ * Checks if addr is in range. Expects addr to be a struct in6_addr* if
+ * ai_family == AF_INET6, else struct in_addr*.
+ * Returns 1 if in range, 0 otherwise.
+ */
+int in_range(struct sockaddr_storage *addr, struct subnet range)
+{
+	if (addr->ss_family != range.ai_family)
+		return 0;
+	if (addr->ss_family == AF_INET6) {
+		int i;
+		struct sockaddr_in6 *in6addr = (struct sockaddr_in6 *) addr;
+		unsigned char *ip = in6addr->sin6_addr.s6_addr;
+		for (i = 0; i < range.prefix; ++i) {
+			int idx = i/8, mask = 1 << (7 - i%8);
+			if ((ip[idx] & mask) != (range.address.ip6.s6_addr[idx]
+			  & mask))
+				return 0;
+		}
+	} else {
+		int i;
+		struct sockaddr_in *inaddr = (struct sockaddr_in *) addr;
+		uint32_t ip = ntohl(inaddr->sin_addr.s_addr);
+		uint32_t comp = ntohl(range.address.ip4.s_addr);
+		for (i = 0; i < range.prefix; ++i) {
+			int mask = 1 << (31-i);
+			if ((ip & mask) != (comp & mask))
+				return 0;
+		}
+	}
+	return 1;
+}
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
index 5916fd3..a3704ef 100644
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -19,7 +19,22 @@
 #ifndef __UTILS_H
 #define __UTILS_H
 
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <netinet/ip.h>
+
+struct subnet {
+	int ai_family;
+	int prefix;
+	union {
+		struct in6_addr ip6;
+		struct in_addr ip4;
+	} address;
+};
+
 int modify_match_busid(char *busid, int add);
+int parse_cidr(const char *src, struct subnet *dest);
+int in_range(struct sockaddr_storage *addr, struct subnet range);
 
 #endif /* __UTILS_H */
 
-- 
1.8.4.1

