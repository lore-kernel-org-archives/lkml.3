Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbaDIX3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:29:45 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41218
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804AbaDIX3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:29:43 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        "[3.14]"@linuxonhyperv.com
Subject: [PATCH 1/1] Tools: hv: Handle the case when the target file exists correctly
Date: Wed,  9 Apr 2014 17:24:16 -0700
Message-Id: <1397089456-18450-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the appropriate error code and handle the case when the target
file exists correctly. This fixes a bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org> [3.14]
---
 include/uapi/linux/hyperv.h |    1 +
 tools/hv/hv_fcopy_daemon.c  |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 9beb7c9..78e4a86 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -305,6 +305,7 @@ enum hv_kvp_exchg_pool {
 #define HV_ERROR_DEVICE_NOT_CONNECTED	0x8007048F
 #define HV_INVALIDARG			0x80070057
 #define HV_GUID_NOTFOUND		0x80041002
+#define HV_ERROR_ALREADY_EXISTS		0x80070050
 
 #define ADDR_FAMILY_NONE	0x00
 #define ADDR_FAMILY_IPV4	0x01
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 4ecc4fd..fba1c75 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -82,8 +82,10 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
 
 	if (!access(target_fname, F_OK)) {
 		syslog(LOG_INFO, "File: %s exists", target_fname);
-		if (!smsg->copy_flags & OVER_WRITE)
+		if (!(smsg->copy_flags & OVER_WRITE)) {
+			error = HV_ERROR_ALREADY_EXISTS;
 			goto done;
+		}
 	}
 
 	target_fd = open(target_fname, O_RDWR | O_CREAT | O_CLOEXEC, 0744);
-- 
1.7.4.1

