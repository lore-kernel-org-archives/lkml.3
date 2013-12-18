Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3LRBZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:25:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3LRBZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:25:36 -0500
X-IronPort-AV: E=Sophos;i="4.95,504,1384272000"; 
   d="scan'208";a="9279270"
Message-ID: <52B0F7D0.2020506@cn.fujitsu.com>
Date: Wed, 18 Dec 2013 09:18:08 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: wsa@the-dreams.de
CC: linux-i2c@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c: fix a potential kmemleak of adapter device
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/18 09:24:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/18 09:25:05,
	Serialize complete at 2013/12/18 09:25:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running with the latest kernel, we get the following kmemleak message:
unreferenced object 0xffff8800c2a36100 (size 256):
  comm "modprobe", pid 629, jiffies 4294676002 (age 1531.115s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 78 21 85 82 ff ff ff ff  ........x!......
  backtrace:
    [<ffffffff815449ce>] kmemleak_alloc+0x73/0x98
    [<ffffffff8113fa2b>] slab_post_alloc_hook+0x28/0x2a
    [<ffffffff81142004>] __kmalloc+0x12c/0x158
    [<ffffffff8134c60b>] kzalloc.constprop.6+0xe/0x10
    [<ffffffff8134cb71>] device_private_init+0x18/0x66
    [<ffffffff8134f1e8>] dev_set_drvdata+0x1e/0x34
    [<ffffffffa01e643e>] i801_probe+0x5d/0x447 [i2c_i801]
    [<ffffffff812a78be>] local_pci_probe+0x41/0x84
    [<ffffffff812a7feb>] pci_device_probe+0xdf/0x10c
    [<ffffffff8134f90d>] driver_probe_device+0x12f/0x2ee
    [<ffffffff8134fb2b>] __driver_attach+0x5f/0x83
    [<ffffffff8134de28>] bus_for_each_dev+0x64/0x90
    [<ffffffff8134f36b>] driver_attach+0x1e/0x20
    [<ffffffff8134ef34>] bus_add_driver+0xf2/0x1f0
    [<ffffffff8135013e>] driver_register+0x8c/0xc3
    [<ffffffff812a7bb4>] __pci_register_driver+0x62/0x67
According to the backtrace, it seems that we do not release the
device_private field of adapter device in the fail path of i801_probe
or the flow of i2c_del_adapter, so add the cleanup step to fix it.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/i2c/busses/i2c-i801.c |    1 +
 drivers/i2c/i2c-core.c        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 737e298..4bd4fba 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1246,6 +1246,7 @@ exit_free_irq:
 exit_release:
 	pci_release_region(dev, SMBBAR);
 exit:
+	kfree(priv->adapter.dev.p);
 	kfree(priv);
 	return err;
 }
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b3..a7bab9a 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1491,6 +1491,7 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 	idr_remove(&i2c_adapter_idr, adap->nr);
 	mutex_unlock(&core_lock);
 
+	kfree(adap->dev.p);
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));
-- 
1.7.7

