Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaEHRgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:36:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46529 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaEHRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:36:01 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-25-536bc0807a7e
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 1/4] exynos4-is: Free FIMC-IS CPU memory only when allocated
Date: Thu, 08 May 2014 19:35:15 +0200
Message-id: <1399570516-29782-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t9jAd2GA9nBBtcnCljMP3KO1eJs0xt2
	i02Pr7FaXN41h82iZ8NWVovDb9pZHdg8Ni+p9+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
	+T83MhU8Z694tfoISwPjBbYuRk4OCQETiSU7WlkgbDGJC/fWA8W5OIQEFjFKXGltYQRJCAl0
	MEn0rQ8BsdkEDCV6j/aBxUUE5CWe9N4Aa2AWWMco8WtePzNIQljAX+LynVlgRSwCqhLvf88E
	inNw8Aq4Sdzd6w1iSggoSMyZZDOBkXsBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAQ
	eCa1g3Flg8UhRgEORiUe3hdTsoOFWBPLiitzDzFKcDArifC+WAYU4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwJh15JLsh0kOtmqW5oZZbItWX3Wdpnpn
	YcqRc7/Fs39Knn+nOFFf5IenfeeV/1kNLNv2Oaz/vWbKuZl8vvNbvtqprhPhPxF2cernc9uW
	5/e5s6/b0loQrfp66o0p99jfXGVefemts/Cfi6eKOvNiKpbtlVNd+2C59pZX8iaFrKnLGr7w
	PfKzYtNQYinOSDTUYi4qTgQApc7wTP0BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure dma_free_coherent() is not called with incorrect arguments
and only when the memory was actually allocated. This will prevent
possible crashes on error paths of the top level media device driver,
when fimc-is device gets unregistered and its driver detached.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 128b73b..5476dce 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -367,6 +367,9 @@ static void fimc_is_free_cpu_memory(struct fimc_is *is)
 {
 	struct device *dev = &is->pdev->dev;
 
+	if (is->memory.vaddr == NULL)
+		return;
+
 	dma_free_coherent(dev, is->memory.size, is->memory.vaddr,
 			  is->memory.paddr);
 }
-- 
1.7.9.5

