Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaH1WLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:11:05 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42181 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaH1WLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:11:03 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: handle -EPROBE_DEFER in of_iio_channel_get_by_name
Date: Fri, 29 Aug 2014 00:13 +0200
Message-ID: <4420839.L1RSpT2Pjo@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Till now of_iio_channel_get_by_name always tried to find the channel without
evaluating the return code from of_iio_channel_get. This might include
-EPROBE_DEFER in which case the channel is present but its driver simply not
probed yet. Therefore simply return on -EPROBE_DEFER so that the driver
requesting the channel can also defer.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index c749700..f084610 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -178,7 +178,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 			index = of_property_match_string(np, "io-channel-names",
 							 name);
 		chan = of_iio_channel_get(np, index);
-		if (!IS_ERR(chan))
+		if (!IS_ERR(chan) || PTR_ERR(chan) == -EPROBE_DEFER)
 			break;
 		else if (name && index >= 0) {
 			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
-- 
2.0.1


