Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaAFXIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:08:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbaAFWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>
Subject: [PATCH 3.10 110/129] ceph: allow sync_read/write return partial successed size of read/write.
Date: Mon,  6 Jan 2014 14:38:59 -0800
Message-Id: <20140106223902.743832765@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit ee7289bfadda5f4ef60884547ebc9989c8fb314a upstream.

For sync_read/write, it may do multi stripe operations.If one of those
met erro, we return the former successed size rather than a error value.
There is a exception for write-operation met -EOLDSNAPC.If this occur,we
retry the whole write again.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -373,7 +373,7 @@ more:
 			goto more;
 	}
 
-	if (ret >= 0) {
+	if (read > 0) {
 		ret = read;
 		/* did we bounce off eof? */
 		if (pos + left > inode->i_size)
@@ -611,6 +611,8 @@ out:
 		if (check_caps)
 			ceph_check_caps(ceph_inode(inode), CHECK_CAPS_AUTHONLY,
 					NULL);
+	} else if (ret != -EOLDSNAPC && written > 0) {
+		ret = written;
 	}
 	return ret;
 }


