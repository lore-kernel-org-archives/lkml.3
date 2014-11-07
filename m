Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaKGRJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:09:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaKGRJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:09:42 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 1/3] Tools: hv: vssdaemon: consult with errno in case of failure only
Date: Fri,  7 Nov 2014 18:09:28 +0100
Message-Id: <1415380170-641-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
References: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ioctl() return 0 there is no point in examining errno and
it can actually produce misleading output. In case there was
no failure errno will contain the error code for previous failure
so user will see the following in the log:
 Hyper-V VSS: VSS: freeze of /mnt/udf: Operation not supported
 Hyper-V VSS: VSS: freeze of /: Operation not supported

We should also log errors with LOG_ERR instead of LOG_INFO.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_vss_daemon.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 9ae2b6e..5f67858 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -52,7 +52,11 @@ static int vss_do_freeze(char *dir, unsigned int cmd, char *fs_op)
 	if (fd < 0)
 		return 1;
 	ret = ioctl(fd, cmd, 0);
-	syslog(LOG_INFO, "VSS: %s of %s: %s\n", fs_op, dir, strerror(errno));
+	if (ret)
+		syslog(LOG_ERR, "VSS: %s of %s: %s\n", fs_op, dir,
+		       strerror(errno));
+	else
+		syslog(LOG_INFO, "VSS: %s of %s succeeded\n", fs_op, dir);
 	close(fd);
 	return !!ret;
 }
-- 
1.9.3

