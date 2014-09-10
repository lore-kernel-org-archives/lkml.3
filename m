Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaIJK6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:58:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58760 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaIJK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:58:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 3/8] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Wed, 10 Sep 2014 12:58:23 +0200
Message-Id: <1410346708-5125-4-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de>
References: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decrementing the reference count of the previous endpoint node allows to
use the of_graph_get_next_endpoint function in a for_each_... style macro.
Prior to this patch, all current users of this function that actually pass
a non-NULL prev parameter should be changed to not decrement the passed
prev argument's refcount themselves.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d8574ad..a49b5628 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2058,8 +2058,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
  * @prev: previous endpoint node, or NULL to get first
  *
  * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
+ * of the passed @prev node is decremented.
  */
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *prev)
@@ -2095,12 +2094,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
 			      __func__, prev->full_name))
 			return NULL;
-
-		/*
-		 * Avoid dropping prev node refcount to 0 when getting the next
-		 * child below.
-		 */
-		of_node_get(prev);
 	}
 
 	while (1) {
-- 
2.1.0

