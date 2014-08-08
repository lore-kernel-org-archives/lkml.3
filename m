Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbaHHUr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbaHHUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 023/259] iio: of_iio_channel_get_by_name() returns non-null pointers for error legs
Date: Fri,  8 Aug 2014 13:37:26 -0700
Message-Id: <1407530482-4483-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/inkern.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 0cf5f8e..1e8e94d 100644
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

