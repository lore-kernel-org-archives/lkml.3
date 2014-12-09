Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaLIKv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:51:29 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56775
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbaLIKv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:51:28 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com
Cc: haiyangz@microsoft.com
Subject: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Date: Tue,  9 Dec 2014 04:01:29 -0800
Message-Id: <1418126489-20627-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently IPv6-only-injection doesn't work because the daemon doesn't parse
any IPv6 information at all once it finds the dhcp_enabled flag is true.

But according to the Hyper-v host team, the flag is only for IPv4.
In the case the host only injects 1 IPv6 address, the dhcp flag is true, but
we shouldn't ignore the IPv6 address and we should pass BOOTPROTO=none
to the distro-specific script hv_set_ipconfig.

Tested in Ubuntu 14.10 and RHEL7.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6a6432a..6ef6c04 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1145,6 +1145,9 @@ static int kvp_write_file(FILE *f, char *s1, char *s2, char *s3)
 }
 
 
+/* How many ipv6 addresses the host is trying to inject? */
+static int num_ipv6_injected;
+
 static int process_ip_string(FILE *f, char *ip_string, int type)
 {
 	int error = 0;
@@ -1190,6 +1193,7 @@ static int process_ip_string(FILE *f, char *ip_string, int type)
 			switch (type) {
 			case IPADDR:
 				snprintf(str, sizeof(str), "%s", "IPV6ADDR");
+				num_ipv6_injected++;
 				break;
 			case NETMASK:
 				snprintf(str, sizeof(str), "%s", "IPV6NETMASK");
@@ -1308,27 +1312,12 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error)
 		goto setval_error;
 
-	if (new_val->dhcp_enabled) {
-		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
-		if (error)
-			goto setval_error;
-
-		/*
-		 * We are done!.
-		 */
-		goto setval_done;
-
-	} else {
-		error = kvp_write_file(file, "BOOTPROTO", "", "none");
-		if (error)
-			goto setval_error;
-	}
-
 	/*
 	 * Write the configuration for ipaddress, netmask, gateway and
 	 * name servers.
 	 */
 
+	num_ipv6_injected = 0;
 	error = process_ip_string(file, (char *)new_val->ip_addr, IPADDR);
 	if (error)
 		goto setval_error;
@@ -1345,6 +1334,32 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error)
 		goto setval_error;
 
+	/*
+	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host team.
+	 *
+	 * In the case the host only injects 1 IPv6 address:
+	 * new_val->dhcp_enabled is true, but we can't pass BOOTPROTO=dhcp to
+	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
+	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
+	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init program
+	 * ignores any static IP addr information once there is
+	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
+	 *
+	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
+	 * Ubuntu because it's ignored by the Ubuntu version of
+	 * hv_set_ifconfig and it doesn't seem to have special meaning in
+	 * Ubuntu.
+	 */
+	if (new_val->dhcp_enabled && num_ipv6_injected == 0) {
+		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
+		if (error)
+			goto setval_error;
+	} else {
+		error = kvp_write_file(file, "BOOTPROTO", "", "none");
+		if (error)
+			goto setval_error;
+	}
+
 setval_done:
 	fclose(file);
 
-- 
1.9.1

