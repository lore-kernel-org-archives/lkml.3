Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaJIHln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:41:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15469 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIHld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:41:33 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-9a-54363c27f39d
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: f_fs: remove redundant ffs_data_get()
Date: Thu, 09 Oct 2014 09:41:16 +0200
Message-id: <1412840476-2767-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAV11G7MQg729WhazXrazWBy8X2/R
	vHg9m8XlXXPYLBYta2W2WHvkLrvFguMtrBYPDu9kd+Dw2D93DbvHuj+vmDz6tqxi9Dh+YzuT
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZK45EF8zhrLjct4a5gfEVexcjB4eEgInE5iajLkZOIFNM
	4sK99WxdjFwcQgKLGCUeH2hngXDamSRWf73MBlLFJqAjseX7BEYQW0RAQGL9i0vsIEXMAscZ
	JRZuOQBWJCzgLHFo0mVWEJtFQFVi25QZTCA2r4CLxP7LC9gg1slJnDw2mXUCI/cCRoZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHB8kx6B+OqBotDjAIcjEo8vA/+mYYIsSaWFVfmHmKU
	4GBWEuFV/QoU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnV
	wCjOPPtVV4GXwJfXOUGfNxb853qSeyNrerT+Q0GdXul1CQ6s/zlXWm7plf/nU1OwbWqJnH3I
	p0Uva76qKIR95j9/OXvF4qy7eS8iN/rr3zbWmWq8e3blEpsL+sf+1kT8b7qteP8zi+DiT853
	5CUZgmcJcop2xx07tY5/r1hH2fTPZ3+FXX94X0aJpTgj0VCLuag4EQAL77KSEgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During FunctionFS bind, ffs_data_get() function was called twice
(in functionfs_bind() and in ffs_do_functionfs_bind()), while on unbind
ffs_data_put() was called once (in functionfs_unbind() function).
In result refcount never reached value 0, and ffs memory resources has
been never released.

Since ffs_data_get() call in ffs_do_functionfs_bind() is redundant
and not neccessary, we remove it to have equal number of gets ans puts,
and free allocated memory after refcount reach 0.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/function/f_fs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 7c6771d..12dbdaf 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2663,8 +2663,6 @@ static inline struct f_fs_opts *ffs_do_functionfs_bind(struct usb_function *f,
 	func->conf = c;
 	func->gadget = c->cdev->gadget;
 
-	ffs_data_get(func->ffs);
-
 	/*
 	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
 	 * configurations are bound in sequence with list_for_each_entry,
-- 
1.9.1

