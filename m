Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598Ab3GSF0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965444Ab3GSF0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
Subject: [ 10/72] ext4: check error return from ext4_write_inline_data_end()
Date: Thu, 18 Jul 2013 22:25:27 -0700
Message-Id: <20130719052600.563480015@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 42c832debbbf819f6c4ad8601baa559c44105ba4 upstream.

The function ext4_write_inline_data_end() can return an error.  So we
need to assign it to a signed integer variable to check for an error
return (since copied is an unsigned int).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1118,10 +1118,13 @@ static int ext4_write_end(struct file *f
 		}
 	}
 
-	if (ext4_has_inline_data(inode))
-		copied = ext4_write_inline_data_end(inode, pos, len,
-						    copied, page);
-	else
+	if (ext4_has_inline_data(inode)) {
+		ret = ext4_write_inline_data_end(inode, pos, len,
+						 copied, page);
+		if (ret < 0)
+			goto errout;
+		copied = ret;
+	} else
 		copied = block_write_end(file, mapping, pos,
 					 len, copied, page, fsdata);
 


