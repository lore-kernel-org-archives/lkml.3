Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaIPWHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:07:15 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60279 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbaIPWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:07:11 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:41 +0000
Message-Id: <1410910735-27929-5-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 04/18] usbip: Add CIDR matching helper functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

This patch adds a few utility functions to match IP addresses against
CIDR masks.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/src/utils.c | 88 +++++++++++++++++++++++++++++++++++++++++++++
 tools/usb/usbip/src/utils.h | 15 ++++++++
 2 files changed, 103 insertions(+)

diff --git a/tools/usb/usbip/src/utils.c b/tools/usb/usbip/src/utils.c
index 2b3d6d2..8dae7aa 100644
--- a/tools/usb/usbip/src/utils.c
+++ b/tools/usb/usbip/src/utils.c
@@ -50,3 +50,91 @@ int modify_match_busid(char *busid, int add)
 
 	return 0;
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
+		     strlen(src) > sizeof(buf) - 1)
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
+
+		for (i = 0; i < range.prefix; ++i) {
+			int idx = i/8, mask = 1 << (7 - i%8);
+
+			if ((ip[idx] & mask) != (range.address.ip6.s6_addr[idx]
+			     & mask))
+				return 0;
+		}
+	} else {
+		int i;
+		struct sockaddr_in *inaddr = (struct sockaddr_in *) addr;
+		uint32_t ip = ntohl(inaddr->sin_addr.s_addr);
+		uint32_t comp = ntohl(range.address.ip4.s_addr);
+
+		for (i = 0; i < range.prefix; ++i) {
+			int mask = 1 << (31-i);
+
+			if ((ip & mask) != (comp & mask))
+				return 0;
+		}
+	}
+	return 1;
+}
diff --git a/tools/usb/usbip/src/utils.h b/tools/usb/usbip/src/utils.h
index 5916fd3..a3704ef 100644
--- a/tools/usb/usbip/src/utils.h
+++ b/tools/usb/usbip/src/utils.h
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
2.1.0

