Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaKGRJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:09:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaKGRJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:09:44 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 3/3] Tools: hv: vssdaemon: thaw everything in case of freeze failure
Date: Fri,  7 Nov 2014 18:09:30 +0100
Message-Id: <1415380170-641-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
References: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one or more filesystems failed to freeze we need to thaw everything as
host doing backup won't issue THAW request after we return HV_E_FAIL and our
system will remain with frozen filesystems for ever.

There is no track of filesystems we freeze so in case there is some external
tool doing freeze/thaw requests at the same time they will collide with vss
daemon. This issue can be addressed by introducing a freeze/thaw transaction
and keeping track of what was actually frozen

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_vss_daemon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 7be999a..e98c638 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -284,6 +284,12 @@ int main(int argc, char *argv[])
 			error = vss_operate(op);
 			if (error)
 				error = HV_E_FAIL;
+			if (error && op == VSS_OP_FREEZE) {
+				/* Need to thaw all frozen fylesystems */
+				syslog(LOG_ERR,
+				       "Freeze failed, thaw everything");
+				vss_operate(VSS_OP_THAW);
+			}
 			break;
 		default:
 			syslog(LOG_ERR, "Illegal op:%d\n", op);
-- 
1.9.3

