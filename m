Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaLJKXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:23:11 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49426
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaLJKXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:23:09 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, vkuznets@redhat.com,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Cc: haiyangz@microsoft.com
Subject: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
Date: Wed, 10 Dec 2014 03:33:20 -0800
Message-Id: <1418211200-1166-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case the host only injects an IPv6 address, the dhcp_enabled flag is
true (it's only for IPv4 according to Hyper-V host team), but we still need to
proceed to parse the IPv6 information.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

v2: removed the distro-specific logic as Vitaly suggested.

 tools/hv/hv_kvp_daemon.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6a6432a..4b3ee35 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1308,16 +1308,17 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error)
 		goto setval_error;
 
+	/*
+	 * The dhcp_enabled flag is only for IPv4. In the case the host only
+	 * injects an IPv6 address, the flag is true, but we still need to
+	 * proceed to parse and pass the IPv6 information to the
+	 * disto-specific script hv_set_ifconfig.
+	 */
 	if (new_val->dhcp_enabled) {
 		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
 		if (error)
 			goto setval_error;
 
-		/*
-		 * We are done!.
-		 */
-		goto setval_done;
-
 	} else {
 		error = kvp_write_file(file, "BOOTPROTO", "", "none");
 		if (error)
@@ -1345,7 +1346,6 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error)
 		goto setval_error;
 
-setval_done:
 	fclose(file);
 
 	/*
-- 
1.9.1

