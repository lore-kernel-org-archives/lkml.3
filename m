Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3KFGkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 01:40:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:46523 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3KFGky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 01:40:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="430523999"
Subject: [PATCH] devres: Freeing the drs after all release() are called
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: dmitry.torokhov@gmail.com, tj@kernel.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Nov 2013 14:40:18 +0800
Message-ID: <1383720018.3650.37.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In release_nodes(), it will call dr->node.release() and kfree
dr one by one.

But sometimes the previous dr maybe be used by next .release(),
such as:
[50314.855534]  [<c12b172f>] ? synchronize_irq+0x3f/0xb0
[50314.861193]  [<c12b18e9>] __free_irq+0x149/0x200
[50314.866367]  [<c12b19e3>] free_irq+0x43/0xa0
[50314.871152]  [<c12b4864>] devm_irq_release+0x14/0x20
[50314.876713]  [<c169e806>] release_nodes+0x136/0x1b0
[50314.882178]  [<c169ee79>] devres_release_all+0x39/0x60
[50314.887935]  [<c169b411>] __device_release_driver+0x71/0xd0

the free_irq() will sync the last irq handling, which maybe use
freed dr, then it will cause memory corruption.

Here split the dr kfreeing actions after all dr->node.release().

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/devres.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 507379e..66ff0be 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -490,9 +490,11 @@ static int release_nodes(struct device *dev, struct list_head *first,
 	list_for_each_entry_safe_reverse(dr, tmp, &todo, node.entry) {
 		devres_log(dev, &dr->node, "REL");
 		dr->node.release(dev, dr->data);
-		kfree(dr);
 	}
 
+	list_for_each_entry_safe_reverse(dr, tmp, &todo, node.entry)
+		kfree(dr);
+
 	return cnt;
 }
 
-- 
1.7.9.5



