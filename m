Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3GPK6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:58:16 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:53241 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3GPK6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:58:15 -0400
Date: Tue, 16 Jul 2013 12:58:01 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Sasha Levin <sasha.levin@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] FMC: fix locking in sample chardev driver
Message-ID: <20130716105801.GA25488@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fmc-chardev module was over-locking, by calling misc
register/unregister while holding its spinlock.  This reported a
"scheduling while atomic" error.

Since the misc driver already serializes operations internally, this
commit downgrades the fmc-chardev lock to just cover its own list.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
---
 drivers/fmc/fmc-chardev.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/fmc/fmc-chardev.c b/drivers/fmc/fmc-chardev.c
index cc031db..ace6ef2 100644
--- a/drivers/fmc/fmc-chardev.c
+++ b/drivers/fmc/fmc-chardev.c
@@ -143,18 +143,17 @@ static int fc_probe(struct fmc_device *fmc)
 	fc->misc.fops = &fc_fops;
 	fc->misc.name = kstrdup(dev_name(&fmc->dev), GFP_KERNEL);
 
-	spin_lock(&fc_lock);
 	ret = misc_register(&fc->misc);
 	if (ret < 0)
-		goto err_unlock;
+		goto out;
+	spin_lock(&fc_lock);
 	list_add(&fc->list, &fc_devices);
 	spin_unlock(&fc_lock);
 	dev_info(&fc->fmc->dev, "Created misc device \"%s\"\n",
 		 fc->misc.name);
 	return 0;
 
-err_unlock:
-	spin_unlock(&fc_lock);
+out:
 	kfree(fc->misc.name);
 	kfree(fc);
 	return ret;
@@ -174,10 +173,10 @@ static int fc_remove(struct fmc_device *fmc)
 
 	spin_lock(&fc_lock);
 	list_del(&fc->list);
+	spin_unlock(&fc_lock);
 	misc_deregister(&fc->misc);
 	kfree(fc->misc.name);
 	kfree(fc);
-	spin_unlock(&fc_lock);
 
 	return 0;
 }
-- 
1.7.7.2
