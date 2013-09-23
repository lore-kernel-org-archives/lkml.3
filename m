Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3IWIXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:23:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56993 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3IWIXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:23:00 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-c2-523ffa63fc34
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, minchan@kernel.org,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: [PATCH v3 3/3] mm/zswap: avoid unnecessary page scanning
Date: Mon, 23 Sep 2013 16:21:49 +0800
Message-id: <000101ceb836$1a4c0ee0$4ee42ca0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64Nezr30PgE+IxTv2LHEGZGi1jNQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQd3kX/ZBBp++ClrMWb+GzeJN6202
	i65TU1ksTlystbh6eRmjxcHZS5gszja9Ybe4vGsOm8W9Nf9ZLZZ9fc9u8fDpdXaLQ/tWsVss
	2PiI0eLJif8sDnweO2fdZffYtKqTzWPTp0nsHidm/GbxeHBoM4vHx6e3WDz6tqxi9Pi8SS6A
	I4rLJiU1J7MstUjfLoEro+fLN8aCbewVu5quMjYwTmDrYuTkkBAwkWh/vYsJwhaTuHBvPVCc
	i0NIYDqjxLlH19khnD+MEsdXzGUGqWIT0Ja427+RFcQWEZCVmPr3PAuIzSxwkEli7ib+LkYO
	DmEBR4nZJ+xBwiwCqhLz/u9iBLF5BewkPiz4wAZhC0r8mHyPBaScWUBdYsqUXIgp8hKb17xl
	BglLAIUf/dUFMUUE9CSu9vtBVIhLbDxyi2UCo8AsJHNmIcyZhWTOLCQdCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEx9Uz6R2MqxosDjEKcDAq8fBGJtoHCbEmlhVX5h5ilOBgVhLh
	beoECvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamCUnBTK
	lFh1uePu6TPf+o6b8kvLReuplKz/tmPhjxNpt3eL3jjqVbO2t3v9l+uHH6wzX3v4csgGvvW9
	izhjjGcVvLDPOS8cGSVnnnNGd92Mas95j52c+5prX/8XuPY9qLIvqd0gWOd4kuSVG29Mc7JO
	HbU8xFeru0i8uWPRAyNR7mC/6Nj/zXOVWIozEg21mIuKEwFKps04pwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add SetPageReclaim before __swap_writepage so that page can be moved to the
tail of the inactive list, which can avoid unnecessary page scanning as this
page was reclaimed by swap subsystem before.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1be7b90..cc40e6a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -556,6 +556,9 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 		SetPageUptodate(page);
 	}
 
+	/* move it to the tail of the inactive list after end_writeback */
+	SetPageReclaim(page);
+
 	/* start writeback */
 	__swap_writepage(page, &wbc, end_swap_bio_write);
 	page_cache_release(page);
-- 
1.7.10.4


