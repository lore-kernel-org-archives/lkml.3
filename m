Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbbAJFGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:06:49 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36768
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbbAJFGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:06:48 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 3/5] Tools: hv: address compiler warnings for hv_kvp_daemon.c
Date: Fri,  9 Jan 2015 22:18:53 -0800
Message-Id: <1420870735-2265-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420870735-2265-1-git-send-email-kys@microsoft.com>
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
 <1420870735-2265-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

This patch addresses two types of compiler warnings:
... warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
and
... warning: pointer targets in passing argument N of .kvp_.... differ in signedness [-Wpointer-sign]

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 5a274ca..48a95f9 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -308,7 +308,7 @@ static int kvp_file_init(void)
 	return 0;
 }
 
-static int kvp_key_delete(int pool, const char *key, int key_size)
+static int kvp_key_delete(int pool, const __u8 *key, int key_size)
 {
 	int i;
 	int j, k;
@@ -351,8 +351,8 @@ static int kvp_key_delete(int pool, const char *key, int key_size)
 	return 1;
 }
 
-static int kvp_key_add_or_modify(int pool, const char *key, int key_size, const char *value,
-			int value_size)
+static int kvp_key_add_or_modify(int pool, const __u8 *key, int key_size,
+				 const __u8 *value, int value_size)
 {
 	int i;
 	int num_records;
@@ -405,7 +405,7 @@ static int kvp_key_add_or_modify(int pool, const char *key, int key_size, const
 	return 0;
 }
 
-static int kvp_get_value(int pool, const char *key, int key_size, char *value,
+static int kvp_get_value(int pool, const __u8 *key, int key_size, __u8 *value,
 			int value_size)
 {
 	int i;
@@ -437,8 +437,8 @@ static int kvp_get_value(int pool, const char *key, int key_size, char *value,
 	return 1;
 }
 
-static int kvp_pool_enumerate(int pool, int index, char *key, int key_size,
-				char *value, int value_size)
+static int kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
+				__u8 *value, int value_size)
 {
 	struct kvp_record *record;
 
@@ -659,7 +659,7 @@ static char *kvp_if_name_to_mac(char *if_name)
 	char    *p, *x;
 	char    buf[256];
 	char addr_file[256];
-	int i;
+	unsigned int i;
 	char *mac_addr = NULL;
 
 	snprintf(addr_file, sizeof(addr_file), "%s%s%s", "/sys/class/net/",
@@ -698,7 +698,7 @@ static char *kvp_mac_to_if_name(char *mac)
 	char    buf[256];
 	char *kvp_net_dir = "/sys/class/net/";
 	char dev_id[256];
-	int i;
+	unsigned int i;
 
 	dir = opendir(kvp_net_dir);
 	if (dir == NULL)
@@ -748,7 +748,7 @@ static char *kvp_mac_to_if_name(char *mac)
 
 
 static void kvp_process_ipconfig_file(char *cmd,
-					char *config_buf, int len,
+					char *config_buf, unsigned int len,
 					int element_size, int offset)
 {
 	char buf[256];
@@ -766,7 +766,7 @@ static void kvp_process_ipconfig_file(char *cmd,
 	if (offset == 0)
 		memset(config_buf, 0, len);
 	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
-		if ((len - strlen(config_buf)) < (element_size + 1))
+		if (len < strlen(config_buf) + element_size + 1)
 			break;
 
 		x = strchr(p, '\n');
@@ -914,7 +914,7 @@ static int kvp_process_ip_address(void *addrp,
 
 static int
 kvp_get_ip_info(int family, char *if_name, int op,
-		 void  *out_buffer, int length)
+		 void  *out_buffer, unsigned int length)
 {
 	struct ifaddrs *ifap;
 	struct ifaddrs *curp;
@@ -1017,8 +1017,7 @@ kvp_get_ip_info(int family, char *if_name, int op,
 					weight += hweight32(&w[i]);
 
 				sprintf(cidr_mask, "/%d", weight);
-				if ((length - sn_offset) <
-					(strlen(cidr_mask) + 1))
+				if (length < sn_offset + strlen(cidr_mask) + 1)
 					goto gather_ipaddr;
 
 				if (sn_offset == 0)
-- 
1.7.4.1

