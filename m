Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaAGAKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:10:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbaAFWiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.12 033/144] aio: fix kioctx leak introduced by "aio: Fix a trinity splat"
Date: Mon,  6 Jan 2014 14:36:34 -0800
Message-Id: <20140106223746.274506932@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit 1881686f842065d2f92ec9c6424830ffc17d23b0 upstream.

e34ecee2ae791df674dfb466ce40692ca6218e43 reworked the percpu reference
counting to correct a bug trinity found.  Unfortunately, the change lead
to kioctxes being leaked because there was no final reference count to
put.  Add that reference count back in to fix things.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -652,7 +652,8 @@ static struct kioctx *ioctx_alloc(unsign
 	aio_nr += ctx->max_reqs;
 	spin_unlock(&aio_nr_lock);
 
-	percpu_ref_get(&ctx->users); /* io_setup() will drop this ref */
+	percpu_ref_get(&ctx->users);	/* io_setup() will drop this ref */
+	percpu_ref_get(&ctx->reqs);	/* free_ioctx_users() will drop this */
 
 	err = ioctx_add_table(ctx, mm);
 	if (err)


