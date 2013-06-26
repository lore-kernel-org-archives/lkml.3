Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3FZByJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:54:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:59621 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab3FZBxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:53:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,940,1363158000"; 
   d="scan'208";a="360531378"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, dvhart@linux.intel.com
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/8] gpio-sch: Add sch_gpio_resume_set_enable()
Date: Tue, 25 Jun 2013 18:53:23 -0700
Message-Id: <ea9c188e8ed12eccb6807f975285fb6274b21de4.1372211451.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for enabling and disabling of the resume well GPIOs. The E6xx Atom
CPUs multiplex the resume GPIO 2:0 lines with LVDS and individual board
drivers need to be able to enable or disable the lines appropriately.

Unfortunately, the information regarding if the pins are being used for
LVDS or GPIO is board specific and may not be available to the gpio-sch
driver at probe time.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-sch.c  | 24 ++++++++++++++++++++++++
 include/linux/gpio-sch.h |  6 ++++++
 2 files changed, 30 insertions(+)
 create mode 100644 include/linux/gpio-sch.h

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 5af6571..90785f8 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -41,6 +41,30 @@ static DEFINE_SPINLOCK(gpio_lock);
 
 static unsigned short gpio_ba;
 
+void sch_gpio_resume_set_enable(unsigned gpio_num, int val)
+{
+	u8 curr_en;
+	unsigned short offset, bit;
+
+	spin_lock(&gpio_lock);
+
+	offset = RGEN + gpio_num / 8;
+	bit = gpio_num % 8;
+
+	curr_en = inb(gpio_ba + offset);
+
+	if (val) {
+		if (!(curr_en & (1 << bit)))
+			outb(curr_en | (1 << bit), gpio_ba + offset);
+	} else {
+		if ((curr_en & (1 << bit)))
+			outb(curr_en & ~(1 << bit), gpio_ba + offset);
+	}
+
+	spin_unlock(&gpio_lock);
+}
+EXPORT_SYMBOL_GPL(sch_gpio_resume_set_enable);
+
 static int sch_gpio_core_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
 {
 	u8 curr_dirs;
diff --git a/include/linux/gpio-sch.h b/include/linux/gpio-sch.h
new file mode 100644
index 0000000..79e042f
--- /dev/null
+++ b/include/linux/gpio-sch.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_GPIO_SCH_
+#define _LINUX_GPIO_SCH_
+
+void sch_gpio_resume_set_enable(unsigned gpio_num, int val);
+
+#endif /* _LINUX_GPIO_SCH_ */
-- 
1.8.1.2

