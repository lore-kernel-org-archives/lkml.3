Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaFFVZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:25:18 -0400
Received: from mx1.scotdoyle.com ([69.85.92.149]:54697 "EHLO mx1.scotdoyle.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaFFVZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:25:17 -0400
Date: Fri, 6 Jun 2014 23:25:14 +0100 (BST)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] platform/chrome: Probe multiple i2c adapters of the same
 name
In-Reply-To: <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com>
Message-ID: <alpine.DEB.2.02.1406062316230.32568@scotdoyle.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com> <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com> <20140604083726.GN1730@lahna.fi.intel.com> <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
 <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chromeos_laptop module probes the first i2c adapter with a specific 
name for expected hardware. However, the Acer C720 Chromebook has two i2c 
adapters with the same name. This patch probes each i2c adapter with a 
specific name in turn, until locating the expected hardware.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
CC: Benson Leung <bleung@chromium.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>
---
diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 7f3aad0..3a3382e 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -173,7 +173,7 @@ static struct i2c_client *__add_probed_i2c_device(
  	/* add the i2c device */
  	client = i2c_new_probed_device(adapter, info, addrs, NULL);
  	if (!client)
-		pr_err("%s failed to register device %d-%02x\n",
+		pr_debug("%s did not add i2c device %d-%02x\n",
  		       __func__, bus, info->addr);
  	else
  		pr_debug("%s added i2c device %d-%02x\n",
@@ -194,13 +194,14 @@ static int __find_i2c_adap(struct device *dev, void *data)
  	return (strncmp(adapter->name, name, strlen(name)) == 0);
  }

-static int find_i2c_adapter_num(enum i2c_adapter_type type)
+static int find_i2c_next_adapter_num(enum i2c_adapter_type type,
+		struct device *start)
  {
  	struct device *dev = NULL;
  	struct i2c_adapter *adapter;
  	const char *name = i2c_adapter_names[type];
-	/* find the adapter by name */
-	dev = bus_find_device(&i2c_bus_type, NULL, (void *)name,
+	/* find the next adapter by name */
+	dev = bus_find_device(&i2c_bus_type, start, (void *)name,
  			      __find_i2c_adap);
  	if (!dev) {
  		/* Adapters may appear later. Deferred probing will retry */
@@ -226,10 +227,17 @@ static struct i2c_client *add_probed_i2c_device(
  		struct i2c_board_info *info,
  		const unsigned short *addrs)
  {
-	return __add_probed_i2c_device(name,
-				       find_i2c_adapter_num(type),
-				       info,
-				       addrs);
+	struct i2c_client *client = NULL;
+	struct device *start = NULL;
+	int adapter_num = 0;
+	while (!client && adapter_num > -1) {
+		adapter_num = find_i2c_next_adapter_num(type, start);
+		client = __add_probed_i2c_device(name,
+						 adapter_num,
+						 info,
+						 addrs);
+	}
+	return client;
  }

  /*
@@ -242,10 +250,10 @@ static struct i2c_client *add_i2c_device(const char *name,
  						struct i2c_board_info *info)
  {
  	const unsigned short addr_list[] = { info->addr, I2C_CLIENT_END };
-	return __add_probed_i2c_device(name,
-				       find_i2c_adapter_num(type),
-				       info,
-				       addr_list);
+	return add_probed_i2c_device(name,
+				     type,
+				     info,
+				     addr_list);
  }

  static int setup_cyapa_tp(enum i2c_adapter_type type)
