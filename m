Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab3JNOvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:51:03 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49766 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab3JNOuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:50:32 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lars-Peter Clausen <lars@metafoo.de>, Lv Zheng <lv.zheng@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the pm tree
Date: Mon, 14 Oct 2013 16:48:07 +0200
Message-Id: <1381762088-18880-7-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the pm tree (5d5e5df) got conflicts in

	drivers/i2c/i2c-core.c

caused by commits 0acc2b3 (i2c: Remove redundant 'driver' field from the
i2c_client struct) and a76e9bd (i2c: attach/detach I2C client device to
the ACPI power domain).

I fixed them up (see below). Please verify that the resolution looks
good.

Thanks,
Thierry
---
diff --cc drivers/i2c/i2c-core.c
index 111b2c6,03a8ae6..5923cfa
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@@ -254,10 -254,13 +254,12 @@@ static int i2c_device_probe(struct devi
  					client->flags & I2C_CLIENT_WAKE);
  	dev_dbg(dev, "probe\n");
  
+ 	acpi_dev_pm_attach(&client->dev, true);
  	status = driver->probe(client, i2c_match_id(driver->id_table, client));
- 	if (status)
+ 	if (status) {
 -		client->driver = NULL;
  		i2c_set_clientdata(client, NULL);
- 
+ 		acpi_dev_pm_detach(&client->dev, true);
+ 	}
  	return status;
  }
  
@@@ -278,9 -281,11 +280,9 @@@ static int i2c_device_remove(struct dev
  		dev->driver = NULL;
  		status = 0;
  	}
 -	if (status == 0) {
 -		client->driver = NULL;
 +	if (status == 0)
  		i2c_set_clientdata(client, NULL);
- 
 -	}
+ 	acpi_dev_pm_detach(&client->dev, true);
  	return status;
  }
  
