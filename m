Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3CREbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33407 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab3CREaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:05 -0400
Message-Id: <20130318042145.447908587@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>,
        Evgeniy Polyakov <zbr@ioremap.net>, Matt Helsley <matthltc@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/82] proc connector: reject unprivileged listener bumps
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/connector/cn_proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -303,6 +303,12 @@ static void cn_proc_mcast_ctl(struct cn_
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
@@ -315,6 +321,8 @@ static void cn_proc_mcast_ctl(struct cn_
 		err = EINVAL;
 		break;
 	}
+
+out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 


