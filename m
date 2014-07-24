Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbaGXKMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:12:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934488AbaGXJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/128] iio: of_iio_channel_get_by_name() returns non-null pointers for error legs
Date: Thu, 24 Jul 2014 10:45:05 +0100
Message-Id: <1406195177-8656-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>

commit a2c12493ed7e63a18cef33a71686d12ffcd6600e upstream.

Currently in the inkern.c code for IIO framework, the function
of_iio_channel_get_by_name() will return a non-NULL pointer when
it cannot find a channel using of_iio_channel_get() and when it
tries to search for 'io-channel-ranges' property and fails. This
is incorrect behaviour as the function which calls this expects
a NULL pointer for failure. This patch rectifies the issue.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

