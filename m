Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab3E1GZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:25:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51618 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab3E1GZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:25:23 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: OMAP2+: timer: initialize before using oh_name
Date: Tue, 28 May 2013 11:54:48 +0530
Message-ID: <1369722288-15592-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_property_read_string_index(...,&oh_name) in omap_dm_timer_init_one
does not alter the value of 'oh_name' even if the relevant function
fails and as 'oh_name' in stack may have a non-zero value, it would
be misunderstood by timer code that DT has specified "ti,hwmod"
property for timer. 'oh_name' in this scenario would be a junk value,
this would result in module not being enabled by hwmod API's for
timer, and in turn crash.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index f8b23b8..8e0c390 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -220,7 +220,7 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 					 int posted)
 {
 	char name[10]; /* 10 = sizeof("gptXX_Xck0") */
-	const char *oh_name;
+	const char *oh_name = NULL;
 	struct device_node *np;
 	struct omap_hwmod *oh;
 	struct resource irq, mem;
-- 
1.7.12

