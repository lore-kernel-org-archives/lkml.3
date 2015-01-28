Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbbA1CWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:22:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbA1B2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, GP Orcullo <kinsamanka@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3.10 15/32] clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write
Date: Tue, 27 Jan 2015 17:26:45 -0800
Message-Id: <20150128012629.356766970@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

commit 8c38d28ba8da98f7102c31d35359b4dbe9d1f329 upstream.

EXYNOS4_MCT_L_MASK is defined as 0xffffff00, so applying this bitmask
produces a number outside the range 0x00 to 0xff, which always results
in execution of the default switch statement.

Obviously this is wrong and git history shows that the bitmask inversion
was incorrectly set during a refactoring of the MCT code.

Fix this by putting the inversion at the correct position again.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Reported-by: GP Orcullo <kinsamanka@gmail.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/exynos_mct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -94,8 +94,8 @@ static void exynos4_mct_write(unsigned i
 	__raw_writel(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
-		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
-		switch (offset & EXYNOS4_MCT_L_MASK) {
+		stat_addr = (offset & EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
+		switch (offset & ~EXYNOS4_MCT_L_MASK) {
 		case MCT_L_TCON_OFFSET:
 			mask = 1 << 3;		/* L_TCON write status */
 			break;


