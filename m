Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaFKLRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:17:46 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:62806 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaFKLRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:17:44 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 07:17:43 EDT
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-6.tower-38.messagelabs.com!1402485087!17239968!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <0e7c03b0467ae1eace9dafebe6946d01d48e72f2.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 11 Jun 2014 12:11:25 +0100
Subject: [PATCH 3/8] iio: of_iio_channel_get_by_name() returns non-null
 pointers for error legs
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in the inkern.c code for IIO framework, the function
of_iio_channel_get_by_name() will return a non-NULL pointer when
it cannot find a channel using of_iio_channel_get() and when it
tries to search for 'io-channel-ranges' property and fails. This
is incorrect behaviour as the function which calls this expects
a NULL pointer for failure. This patch rectifies the issue.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
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
1.9.3

