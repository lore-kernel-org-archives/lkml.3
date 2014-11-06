Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaKFQYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:24:13 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:59120 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbaKFQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:24:10 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        <stable@vger.kernel.org>
Subject: [PATCH] misc: genwqe: check for error from get_user_pages_fast()
Date: Thu,  6 Nov 2014 16:23:39 +0000
Message-Id: <1415291019-6178-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`genwqe_user_vmap()` calls `get_user_pages_fast()` and if the return
value is less than the number of pages requested, it frees the pages and
returns an error (`-EFAULT`).  However, it fails to consider a negative
error return value from `get_user_pages_fast()`.  In that case, the test
`if (rc < m->nr_pages)` will be false (due to promotion of `rc` to a
large `unsigned int`) and the code will continue on to call
`genwqe_map_pages()` with an invalid list of page pointers.  Fix it by
bailing out if `get_user_pages_fast()` returns a negative error value.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: <stable@vger.kernel.org> # 3.14.x # 3.15.x # 3.16.x # 3.17.x
---
 drivers/misc/genwqe/card_utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 7cb3b7e..1ca94e6 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -590,6 +590,8 @@ int genwqe_user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
 				 m->nr_pages,
 				 1,		/* write by caller */
 				 m->page_list);	/* ptrs to pages */
+	if (rc < 0)
+		goto fail_get_user_pages;
 
 	/* assumption: get_user_pages can be killed by signals. */
 	if (rc < m->nr_pages) {
-- 
2.1.1

