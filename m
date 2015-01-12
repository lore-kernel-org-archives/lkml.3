Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbbALTN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:13:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbbALSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 023/216] misc: genwqe: check for error from get_user_pages_fast()
Date: Mon, 12 Jan 2015 18:02:20 +0000
Message-Id: <1421085933-32536-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit cf35d6e0475982667b0d2d318fb27be4b8849827 upstream.

`genwqe_user_vmap()` calls `get_user_pages_fast()` and if the return
value is less than the number of pages requested, it frees the pages and
returns an error (`-EFAULT`).  However, it fails to consider a negative
error return value from `get_user_pages_fast()`.  In that case, the test
`if (rc < m->nr_pages)` will be false (due to promotion of `rc` to a
large `unsigned int`) and the code will continue on to call
`genwqe_map_pages()` with an invalid list of page pointers.  Fix it by
bailing out if `get_user_pages_fast()` returns a negative error value.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/genwqe/card_utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 62cc6bb3f62e..ded1c2507d3d 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -580,6 +580,8 @@ int genwqe_user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
 				 m->nr_pages,
 				 1,		/* write by caller */
 				 m->page_list);	/* ptrs to pages */
+	if (rc < 0)
+		goto fail_get_user_pages;
 
 	/* assumption: get_user_pages can be killed by signals. */
 	if (rc < m->nr_pages) {
-- 
2.1.4

