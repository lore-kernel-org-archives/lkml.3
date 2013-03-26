Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965Ab3CZQLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:11:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab3CZPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Evgeniy Polyakov <zbr@ioremap.net>,
        Matt Helsley <matthltc@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/150] proc connector: reject unprivileged listener bumps
Date: Tue, 26 Mar 2013 15:18:46 +0000
Message-Id: <1364311249-14454-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit e70ab977991964a5a7ad1182799451d067e62669 upstream.

While PROC_CN_MCAST_LISTEN/IGNORE is entirely advisory, it was possible
for an unprivileged user to turn off notifications for all listeners by
sending PROC_CN_MCAST_IGNORE. Instead, require the same privileges as
required for a multicast bind.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/connector/cn_proc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 77e1e6c..9d90e8c 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -303,7 +303,13 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	if (msg->len != sizeof(*mc_op))
 		return;
 
-	mc_op = (enum proc_cn_mcast_op*)msg->data;
+	/* Can only change if privileged. */
+	if (!capable(CAP_NET_ADMIN)) {
+		err = EPERM;
+		goto out;
+	}
+
+	mc_op = (enum proc_cn_mcast_op *)msg->data;
 	switch (*mc_op) {
 	case PROC_CN_MCAST_LISTEN:
 		atomic_inc(&proc_event_num_listeners);
@@ -315,6 +321,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		err = EINVAL;
 		break;
 	}
+
+out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
-- 
1.8.1.2

