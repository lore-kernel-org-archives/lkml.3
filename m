Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbbANHed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:34:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbbANHe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.14 37/77] misc: genwqe: check for error from get_user_pages_fast()
Date: Tue, 13 Jan 2015 23:23:17 -0800
Message-Id: <20150114072226.264475958@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/misc/genwqe/card_utils.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -490,6 +490,8 @@ int genwqe_user_vmap(struct genwqe_dev *
 				 m->nr_pages,
 				 1,		/* write by caller */
 				 m->page_list);	/* ptrs to pages */
+	if (rc < 0)
+		goto fail_get_user_pages;
 
 	/* assumption: get_user_pages can be killed by signals. */
 	if (rc < m->nr_pages) {


