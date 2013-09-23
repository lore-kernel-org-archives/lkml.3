Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3IWIZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:25:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57746 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3IWIZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:25:39 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-2e-523ffb02529e
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, minchan@kernel.org,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: [PATCH v3 1/3] mm/zswap: bugfix: memory leak when re-swapon
Date: Mon, 23 Sep 2013 16:21:49 +0800
Message-id: <000301ceb836$7b4a1340$71de39c0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64Ncdf6viaRotNRdCWZDvQC+JGkQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQV2m3/ZBBitXcVrMWb+GzeJN6202
	i65TU1ksTlystbh6eRmjxcHZS5gszja9Ybe4vGsOm8W9Nf9ZLZZ9fc9u8fDpdXaLQ/tWsVss
	2PiI0eLJif8sDnweO2fdZffYtKqTzWPTp0nsHidm/GbxeHBoM4vHx6e3WDz6tqxi9Pi8SS6A
	I4rLJiU1J7MstUjfLoEr48WO08wFN9gqDv9wamA8xtrFyMEhIWAicX2/YhcjJ5ApJnHh3nq2
	LkYuDiGB6YwSZ66eY4Zw/jBK3J02iRmkik1AW+Ju/0ZWEFtEQFZi6t/zLCA2s8BBJom5m/hB
	bGEBF4neF22MIDaLgKrEvP+7wGxeATuJPzv/sULYghI/Jt9jATmCWUBdYsqUXIgx8hKb17xl
	hrhNXeLRX12ITXoSuzesY4QoEZfYeOQWywRGgVlIBs1CGDQLyaBZSDoWMLKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAiOq2dSOxhXNlgcYhTgYFTi4Y1ItA8SYk0sK67MPcQowcGsJMLb
	1AkU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwDh9dXDm
	iwqPN7rhdu0P1FavNPrBF7hH3bqr7PuK+iVzHh7/zrRgs6H7dBXeV7unfuoI4rgav88iK/5X
	4u1TGwKrJTwDZ29Tf3Fj82XWsIhclr5v/f3H7szrM9h8LtFAIKOH9V7Y+ieRMRFe0wQuWR4u
	63Bf+Fjj72HdltMTz5xYy7jcveJUToYSS3FGoqEWc1FxIgBYHxSfpwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap_tree is not freed when swapoff, and it got re-kmalloc in swapon,
so memory-leak occurs.

Modify: free memory of zswap_tree in zswap_frontswap_invalidate_area().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 mm/zswap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index deda2b6..cbd9578 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -816,6 +816,10 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 	}
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
+
+	zbud_destroy_pool(tree->pool);
+	kfree(tree);
+	zswap_trees[type] = NULL;
 }
 
 static struct zbud_ops zswap_zbud_ops = {
-- 
1.7.10.4


