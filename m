Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaKKCVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:21:07 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53235 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaKKCVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:21:06 -0500
From: David Fries <David@Fries.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] cn: verify msg->len before making callback
Date: Mon, 10 Nov 2014 20:19:36 -0600
Message-Id: <1415672377-18758-2-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415672377-18758-1-git-send-email-David@Fries.net>
References: <18541415578350@web5g.yandex.ru>
 <1415672377-18758-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Mon, 10 Nov 2014 20:20:55 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct cn_msg len field comes from userspace and needs to be
validated.  More logical to do so here where the cn_msg pointer is
pulled out of the sk_buff than the callback which is passed cn_msg *
and might assume no validation is needed.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: David Fries <David@Fries.net>
---
 drivers/connector/connector.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index f612d68..30f5228 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -141,12 +141,18 @@ EXPORT_SYMBOL_GPL(cn_netlink_send);
  */
 static int cn_call_callback(struct sk_buff *skb)
 {
+	struct nlmsghdr *nlh;
 	struct cn_callback_entry *i, *cbq = NULL;
 	struct cn_dev *dev = &cdev;
 	struct cn_msg *msg = nlmsg_data(nlmsg_hdr(skb));
 	struct netlink_skb_parms *nsp = &NETLINK_CB(skb);
 	int err = -ENODEV;
 
+	/* verify msg->len is within skb */
+	nlh = nlmsg_hdr(skb);
+	if (nlh->nlmsg_len < NLMSG_HDRLEN + sizeof(struct cn_msg) + msg->len)
+		return -EINVAL;
+
 	spin_lock_bh(&dev->cbdev->queue_lock);
 	list_for_each_entry(i, &dev->cbdev->queue_list, callback_entry) {
 		if (cn_cb_equal(&i->id.id, &msg->id)) {
-- 
1.7.10.4

