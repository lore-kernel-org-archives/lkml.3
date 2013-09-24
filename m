Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3IXJYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:24:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62260 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3IXJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:24:48 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-24-52415a5f7be8
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] USB: gadget: s3c-hsotg: fix can_write limit for non-periodic
 endpoints
Date: Tue, 24 Sep 2013 11:24:28 +0200
Message-id: <1380014668-19597-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd34KMcgg+nLNCxmvWxnsdg4Yz2r
	xcH79RbNi9ezWZxtesNucXnXHDaLRctamS3WHrnLbvHg8E52B06P/XPXsHv0bVnF6HH8xnYm
	j8+b5AJYorhsUlJzMstSi/TtErgybjetYynYwVnRvWkHcwPjU/YuRk4OCQETid0f9rNA2GIS
	F+6tZ+ti5OIQEpjOKPFt9y9WCKedSeLJnhVgHWwCOhJbvk9gBLFFBAQk1r+4xA5SxCzwl1Hi
	9sNONpCEsECkxJz2RcwgNouAqsS7zxOAijg4eAVcJe5fFAUxJQQUJOZMsgGp4BRwk5h4/jXY
	EUJAFY83fWGbwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwcD2T2sG4ssHiEKMA
	B6MSD+8Ob4cgIdbEsuLK3EOMEhzMSiK8N2wdg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwbmM/5CWyLdS2sMeJt7t4Yvvsw7JmszbnuYeaxVzwyXcX
	Zr71xMD/utoKH6+Y2F3X/iqd6ixWOpz15n2jPZvrv6qXv9l+7Hmpl6goWrvMpmirTuq+fyoB
	mu9OL9HmkM5P/qhgsHTBjOfmZ++X+4j25omtmj1Rp27l3duX9vPrr96hJ+l1fku0EktxRqKh
	FnNRcSIAYkh5QSoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Value of can_write variable in s3c_hsotg_write_fifo function should be limited
to 512 only for non-periodic endpoints. There was some discrepancy between
comment and code, becouse comment suggests correct behavior, but in the code
limit was applied to periodic endpoints too. So there is additional check
causing the limitation concerns only non-periodic endpoints.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I have found one small bug in s3c_hsotg_write_fifo function which doesn't
allow to perform transfers greater than 512 bytes. 

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index d5d951d..2b9c446 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -542,7 +542,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	 * FIFO, requests of >512 cause the endpoint to get stuck with a
 	 * fragment of the end of the transfer in it.
 	 */
-	if (can_write > 512)
+	if (can_write > 512 && !periodic)
 		can_write = 512;
 
 	/*
-- 
1.7.9.5

