Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3HGROq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:14:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:64314 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab3HGROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:14:45 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/UwZ9ieg==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: cache FQDN in kvp_daemon to avoid timeouts
Date: Wed,  7 Aug 2013 19:14:37 +0200
Message-Id: <1375895677-31757-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvp_daemon does some operations which take an unpredicable amount of
time. In addition the kernel driver gives the kvp_daemon a 5 second
timeout to respond to message from the host. If an operation such as
getaddrinfo takes a long time and the timeout triggers then netlink
errors occour. As a result of such errors the daemon just terminates and
the service becomes unavailable.

Idendifying and fixing these shortcomings in the kernel-userland
communication protocol will be done in separate patches. This change
fixes just one obvious timeout bug.

Update kvp_get_domain_name to not return a value, better diagnostic for
the consumer of the hostname string, remove trailing newline in error
case, use snprintf to not overrun output buffer, get hostname only once
and return the cached result.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 7c05f55..1bdf3c6 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -89,6 +89,7 @@ static char *processor_arch;
 static char *os_build;
 static char *os_version;
 static char *lic_version = "Unknown version";
+static char full_domain_name[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
 static struct utsname uts_buf;
 
 /*
@@ -1368,7 +1369,7 @@ setval_error:
 }
 
 
-static int
+static void
 kvp_get_domain_name(char *buffer, int length)
 {
 	struct addrinfo	hints, *info ;
@@ -1382,12 +1383,12 @@ kvp_get_domain_name(char *buffer, int length)
 
 	error = getaddrinfo(buffer, NULL, &hints, &info);
 	if (error != 0) {
-		strcpy(buffer, "getaddrinfo failed\n");
-		return error;
+		snprintf(buffer, length, "getaddrinfo failed: 0x%x %s",
+			error, gai_strerror(error));
+		return;
 	}
-	strcpy(buffer, info->ai_canonname);
+	snprintf(buffer, length, "%s", info->ai_canonname);
 	freeaddrinfo(info);
-	return error;
 }
 
 static int
@@ -1452,6 +1453,11 @@ int main(void)
 	 * Retrieve OS release information.
 	 */
 	kvp_get_os_info();
+	/*
+	 * Cache Fully Qualified Domain Name because getaddrinfo takes an
+	 * unpredictable amount of time to finish.
+	 */
+	kvp_get_domain_name(full_domain_name, sizeof(full_domain_name));
 
 	if (kvp_file_init()) {
 		syslog(LOG_ERR, "Failed to initialize the pools");
@@ -1670,8 +1676,7 @@ int main(void)
 
 		switch (hv_msg->body.kvp_enum_data.index) {
 		case FullyQualifiedDomainName:
-			kvp_get_domain_name(key_value,
-					HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
+			strcpy(key_value, full_domain_name);
 			strcpy(key_name, "FullyQualifiedDomainName");
 			break;
 		case IntegrationServicesVersion:
