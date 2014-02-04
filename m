Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193AbaBDWLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:11:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbaBDVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.12 090/133] ext4: avoid clearing beyond i_blocks when truncating an inline data file
Date: Tue,  4 Feb 2014 13:08:11 -0800
Message-Id: <20140204210739.572316950@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 09c455aaa8f47a94d5bafaa23d58365768210507 upstream.

A missing cast means that when we are truncating a file which is less
than 60 bytes, we don't clear the correct area of memory, and in fact
we can end up truncating the next inode in the inode table, or worse
yet, some other kernel data structure.

Addresses-Coverity-Id: #751987

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inline.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1925,9 +1925,11 @@ void ext4_inline_data_truncate(struct in
 		}
 
 		/* Clear the content within i_blocks. */
-		if (i_size < EXT4_MIN_INLINE_DATA_SIZE)
-			memset(ext4_raw_inode(&is.iloc)->i_block + i_size, 0,
-					EXT4_MIN_INLINE_DATA_SIZE - i_size);
+		if (i_size < EXT4_MIN_INLINE_DATA_SIZE) {
+			void *p = (void *) ext4_raw_inode(&is.iloc)->i_block;
+			memset(p + i_size, 0,
+			       EXT4_MIN_INLINE_DATA_SIZE - i_size);
+		}
 
 		EXT4_I(inode)->i_inline_size = i_size <
 					EXT4_MIN_INLINE_DATA_SIZE ?


