Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaFDXV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaFDXVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leon Yu <chianglungyu@gmail.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.14 043/228] aio: fix potential leak in aio_run_iocb().
Date: Wed,  4 Jun 2014 16:21:12 -0700
Message-Id: <20140604232349.464128345@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Yu <chianglungyu@gmail.com>

commit 754320d6e166d3a12cb4810a452bde00afbd4e9a upstream.

iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
but it doesn't hold when failure happens right after aio_setup_vectored_rw().

Fix that in a such way to avoid hairy goto.

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1299,10 +1299,8 @@ rw_common:
 						&iovec, compat)
 			: aio_setup_single_vector(req, rw, buf, &nr_segs,
 						  iovec);
-		if (ret)
-			return ret;
-
-		ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
+		if (!ret)
+			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
 		if (ret < 0) {
 			if (iovec != &inline_vec)
 				kfree(iovec);


