Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3CVBKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:10:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:19812 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab3CVBKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:10:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,888,1355126400"; 
   d="scan'208";a="283005984"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, <stable@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH][RESEND] gpio-sch: Allow for more than 8 lines in the resume well
Date: Thu, 21 Mar 2013 18:10:21 -0700
Message-Id: <4cbdc8777bbe14d4c8ea3b2124e9df57d497f066.1363914598.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The E6xx (TunnelCreek) CPUs have 9 GPIO lines in the resume well. Update
the resume functions to allow for more than 8 GPIO lines, using the core
functions as a template.

Cc: <stable@vger.kernel.org> # 3.4.x
Cc: <stable@vger.kernel.org> # 3.8.x
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 drivers/gpio/gpio-sch.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index edae963..7e7b52b 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -125,13 +125,17 @@ static int sch_gpio_resume_direction_in(struct gpio_chip *gc,
 					unsigned gpio_num)
 {
 	u8 curr_dirs;
+	unsigned short offset, bit;
 
 	spin_lock(&gpio_lock);
 
-	curr_dirs = inb(gpio_ba + RGIO);
+	offset = RGIO + gpio_num / 8;
+	bit = gpio_num % 8;
+
+	curr_dirs = inb(gpio_ba + offset);
 
-	if (!(curr_dirs & (1 << gpio_num)))
-		outb(curr_dirs | (1 << gpio_num) , gpio_ba + RGIO);
+	if (!(curr_dirs & (1 << bit)))
+		outb(curr_dirs | (1 << bit), gpio_ba + offset);
 
 	spin_unlock(&gpio_lock);
 	return 0;
@@ -139,22 +143,31 @@ static int sch_gpio_resume_direction_in(struct gpio_chip *gc,
 
 static int sch_gpio_resume_get(struct gpio_chip *gc, unsigned gpio_num)
 {
-	return !!(inb(gpio_ba + RGLV) & (1 << gpio_num));
+	unsigned short offset, bit;
+
+	offset = RGLV + gpio_num / 8;
+	bit = gpio_num % 8;
+
+	return !!(inb(gpio_ba + offset) & (1 << bit));
 }
 
 static void sch_gpio_resume_set(struct gpio_chip *gc,
 				unsigned gpio_num, int val)
 {
 	u8 curr_vals;
+	unsigned short offset, bit;
 
 	spin_lock(&gpio_lock);
 
-	curr_vals = inb(gpio_ba + RGLV);
+	offset = RGLV + gpio_num / 8;
+	bit = gpio_num % 8;
+
+	curr_vals = inb(gpio_ba + offset);
 
 	if (val)
-		outb(curr_vals | (1 << gpio_num), gpio_ba + RGLV);
+		outb(curr_vals | (1 << bit), gpio_ba + offset);
 	else
-		outb((curr_vals & ~(1 << gpio_num)), gpio_ba + RGLV);
+		outb((curr_vals & ~(1 << bit)), gpio_ba + offset);
 
 	spin_unlock(&gpio_lock);
 }
@@ -163,14 +176,18 @@ static int sch_gpio_resume_direction_out(struct gpio_chip *gc,
 					unsigned gpio_num, int val)
 {
 	u8 curr_dirs;
+	unsigned short offset, bit;
 
 	sch_gpio_resume_set(gc, gpio_num, val);
 
+	offset = RGIO + gpio_num / 8;
+	bit = gpio_num % 8;
+
 	spin_lock(&gpio_lock);
 
-	curr_dirs = inb(gpio_ba + RGIO);
-	if (curr_dirs & (1 << gpio_num))
-		outb(curr_dirs & ~(1 << gpio_num), gpio_ba + RGIO);
+	curr_dirs = inb(gpio_ba + offset);
+	if (curr_dirs & (1 << bit))
+		outb(curr_dirs & ~(1 << bit), gpio_ba + offset);
 
 	spin_unlock(&gpio_lock);
 	return 0;
-- 
1.8.1.2

