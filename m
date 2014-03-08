Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaCHB0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:26:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaCHBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Evgeniy Polyakov <zbr@ioremap.net>,
        Matt Helsley <matthltc@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 49/99] proc connector: reject unprivileged listener bumps
Date: Fri,  7 Mar 2014 17:07:45 -0800
Message-Id: <20140308010613.180842254@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/connector/cn_proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -331,6 +331,12 @@ static void cn_proc_mcast_ctl(struct cn_
 	if (msg->len != sizeof(*mc_op))
 		return;
 
+	/* Can only change if privileged. */
+	if (!capable(CAP_NET_ADMIN)) {
+		err = EPERM;
+		goto out;
+	}
+
 	mc_op = (enum proc_cn_mcast_op*)msg->data;
 	switch (*mc_op) {
 	case PROC_CN_MCAST_LISTEN:
@@ -343,6 +349,8 @@ static void cn_proc_mcast_ctl(struct cn_
 		err = EINVAL;
 		break;
 	}
+
+out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 


