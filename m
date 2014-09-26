Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIZLuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:50:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16529 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaIZLut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:50:49 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-72-542553166c08
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC PATCH] extcon: Fix sleeping in atomic context
Date: Fri, 26 Sep 2014 13:50:40 +0200
Message-id: <1411732241-5212-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xa7piwaohBqd3yltsnLGe1eLg/XqL
	61+es1o0L17PZnF54SVWi9cvDC3ONr1ht7i8aw6bxdojd9ktbjeuYLNYsKfEgdtj/9w17B59
	W1Yxehy/sZ3J4/MmuQCWKC6blNSczLLUIn27BK6MI78PsxTs5arYsewEUwPjUo4uRk4OCQET
	iQO/9jJD2GISF+6tZ+ti5OIQEljKKPHhzEkmCKePSeL0uXtgVWwCxhKbly8BqxIROMgkMfvk
	ZrAqZoEpjBLNk5YygVQJC1hLfOx8wgJiswioSiye8wbI5uDgFXCTeLfFBWKdnMTJY5NZJzBy
	L2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREkBfdzAuPWZ1iFGAg1GJh/fGOpUQIdbE
	suLK3EOMEhzMSiK8l7xVQ4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwCvRV5R7yjWARTQ/Wcz1Q
	dP7qtu7//z0/H7dOU3hZXHe2Mqz7cWfOTFOW4L771u7h279d1xGdYrlTL1icacUajcM8Pzea
	WOxf2z4l/1Erx9ppjyb8/z/dn71DV777jvuejVLM3HwLtxwNvsnoKyWsx6Rz+2t//e6lLSXP
	BL+eWD43eIZa6sbZSizFGYmGWsxFxYkAi5uHOP4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When kernel was built with charger manager and extcon, I encountered
a sleep in atomic context after connecting USB cable to the device.

I found this on internal kernel 3.16 on Exynos3250 development board.
Unfortunately I could not reproduce it on mainline kernel because
none of my boards were able to bring up full charging stack
(fuel gauge, charger, charger-manager, extcon).

However, after looking at source code, this should happen also on
mainline kernel.

The fix for bug is simple - use mutexes instead of spin locks. It was
tested on 3.16 but *should* work on mainline.

My questions/request for comments are:
1. Could someone verify this on mainline (test it)?
2. Should I mark it cc-stable? I think yes *but* the patch changes
   few extcon functions from non-sleeping to might_sleep.
   On mainline these affected functions are not used in atomic
   contexts but I am not sure about older stable kernels.
   Applying this to older kernel could lead to another sleep-in-atomic
   issue...


Any comments?

Best regards,
Krzysztof

Krzysztof Kozlowski (1):
  extcon: Fix sleeping in atomic context after connecting USB cable

 drivers/extcon/extcon-class.c | 15 ++++++++-------
 include/linux/extcon.h        |  3 ++-
 2 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.9.1

