Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbaGRNOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:14:39 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17749 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030797AbaGRNOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 113/170] iio: of_iio_channel_get_by_name() returns non-null pointers for error legs
Date: Fri, 18 Jul 2014 14:11:58 +0200
Message-Id: <211eaf4d1e4b6dd187c5e1de42a927b39c05bcdf.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a2c12493ed7e63a18cef33a71686d12ffcd6600e upstream.

Currently in the inkern.c code for IIO framework, the function
of_iio_channel_get_by_name() will return a non-NULL pointer when
it cannot find a channel using of_iio_channel_get() and when it
tries to search for 'io-channel-ranges' property and fails. This
is incorrect behaviour as the function which calls this expects
a NULL pointer for failure. This patch rectifies the issue.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/inkern.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 0cf5f8e06cfc..1e8e94d4db7d 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -183,7 +183,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 		else if (name && index >= 0) {
 			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
 				np->full_name, name ? name : "", index);
-			return chan;
+			return NULL;
 		}
 
 		/*
@@ -193,8 +193,9 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 		 */
 		np = np->parent;
 		if (np && !of_get_property(np, "io-channel-ranges", NULL))
-			break;
+			return NULL;
 	}
+
 	return chan;
 }
 
@@ -317,6 +318,7 @@ struct iio_channel *iio_channel_get(struct device *dev,
 		if (channel != NULL)
 			return channel;
 	}
+
 	return iio_channel_get_sys(name, channel_name);
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);
-- 
2.0.0

