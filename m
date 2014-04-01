Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaDAKDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:03:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:52784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaDAKDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:03:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,771,1389772800"; 
   d="scan'208";a="504216614"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] gpio / ACPI: Prevent potential wrap of GPIO value on OpRegion read
Date: Tue,  1 Apr 2014 13:03:00 +0300
Message-Id: <1396346580-4857-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter's static code checker reports:

 The patch 473ed7be0da0: "gpio / ACPI: Add support for ACPI GPIO
 operation regions" from Mar 14, 2014, leads to the following static
 checker warning:

  drivers/gpio/gpiolib-acpi.c:454 acpi_gpio_adr_space_handler()
  warn: should 'gpiod_get_raw_value(desc) << i' be a 64 bit type?

This is due the fact that *value is of type u64 and gpiod_get_raw_value()
returns int. Since i can be larger than 31, it is possible that the value
returned gets wrapped.

Fix this by casting the return of gpiod_get_raw_value() to u64 first before
shift.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index d5be56fe689e..401add28933f 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -451,7 +451,7 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
 		if (function == ACPI_WRITE)
 			gpiod_set_raw_value(desc, !!((1 << i) & *value));
 		else
-			*value |= gpiod_get_raw_value(desc) << i;
+			*value |= (u64)gpiod_get_raw_value(desc) << i;
 	}
 
 out:
-- 
1.9.1

