Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaIRNTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:19:10 -0400
Received: from ni.piap.pl ([195.187.100.4]:33766 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbaIRNTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:19:08 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 09:19:08 EDT
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 18 Sep 2014 15:12:02 +0200
MIME-Version: 1.0
Message-ID: <m3tx4513a5.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Fix unbalanced mutex in dma_pool_create().
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140401 #7726142, check: 20140918 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_pool_create() needs to unlock the mutex in error case.
The bug has been present starting with v3.16-rc1 (cc6b664a).

Signed-off-by: Krzysztof Hałasa <khc@piap.pl>
Cc: stable@vger.kernel.org

--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -174,11 +174,11 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 
 	mutex_lock(&pools_lock);
 	if (list_empty(&dev->dma_pools) &&
 	    device_create_file(dev, &dev_attr_pools)) {
 		kfree(retval);
-		return NULL;
+		retval = NULL;
 	} else
 		list_add(&retval->pools, &dev->dma_pools);
 	mutex_unlock(&pools_lock);
 
 	return retval;

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
