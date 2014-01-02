Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaABRJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:09:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40411 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaABRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:06 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 69/91] ARM: OMAP2+: Disable POSTED mode for errata i103 and i767
Date: Thu,  2 Jan 2014 09:04:44 -0800
Message-Id: <1388682306-30859-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes <joelf@ti.com>

commit 912e663127c5f700da6805ce21635dce703cb2cc upstream.

Enabling of Posted mode is seen to cause problems on dmtimer modules on AM33xx
(much like other OMAPs).  Reference discussions on forums [1] [2]. Earlier
patch solving this on other OMAPs [3].

For OMAP SoCs with this errata, the fix has been to not enable Posted mode.
However, on some SoCs (atleast AM33xx) which carry this errata, Posted mode
is enabled on reset. So we not only need to ignore enabling of the POSTED bit
when the timer is requested, but also disable Posted mode if errata is present.

[1] http://e2e.ti.com/support/arm/sitara_arm/f/791/t/285744.aspx
[2] http://e2e.ti.com/support/arm/sitara_arm/f/791/t/270632.aspx
[3] http://www.spinics.net/lists/linux-omap/msg81770.html

Reported-by: Russ Dill <russ.dill@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/plat-omap/include/plat/dmtimer.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index a3fbc48..31e1715d 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -335,8 +335,11 @@ static inline void __omap_dm_timer_enable_posted(struct omap_dm_timer *timer)
 	if (timer->posted)
 		return;
 
-	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767)
+	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767) {
+		timer->posted = OMAP_TIMER_NONPOSTED;
+		__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG, 0, 0);
 		return;
+	}
 
 	__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG,
 			      OMAP_TIMER_CTRL_POSTED, 0);
-- 
1.8.3.2

