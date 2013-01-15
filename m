Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab3AOWgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:44087 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932972Ab3AOWgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Zafman <david.zafman@inktank.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 218/221] libceph: Unlock unprocessed pages in start_read() error path
Date: Tue, 15 Jan 2013 10:52:25 -0800
Message-Id: <20130115185013.782642763@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: David Zafman <david.zafman@inktank.com>

(cherry picked from commit 8884d53dd63b1d9315b343564fcbe1ede004a99e)

Function start_read() can get an error before processing all pages.
It must not only release the remaining pages, but unlock them too.

This fixes http://tracker.newdream.net/issues/3370

Signed-off-by: David Zafman <david.zafman@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -267,6 +267,14 @@ static void finish_read(struct ceph_osd_
 	kfree(req->r_pages);
 }
 
+static void ceph_unlock_page_vector(struct page **pages, int num_pages)
+{
+	int i;
+
+	for (i = 0; i < num_pages; i++)
+		unlock_page(pages[i]);
+}
+
 /*
  * start an async read(ahead) operation.  return nr_pages we submitted
  * a read for on success, or negative error code.
@@ -347,6 +355,7 @@ static int start_read(struct inode *inod
 	return nr_pages;
 
 out_pages:
+	ceph_unlock_page_vector(pages, nr_pages);
 	ceph_release_page_vector(pages, nr_pages);
 out:
 	ceph_osdc_put_request(req);


