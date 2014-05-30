Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbaE3Udg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:33:36 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51120 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaE3Udf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:33:35 -0400
Date: Sat, 31 May 2014 00:33:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH -next] fs: pipe -- Take into account requested @len in
 iter_file_splice_write
Message-ID: <20140530203332.GA23463@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently iter_file_splice_write pushes into the output IOVs as much
as it can, so that if one previously pushed into pipe 8K of data and
then try to fetch 4K -- he get the complete 8K instead.

Lest count how many bytes were requested by a caller and
stop looping once request is complete.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Pavel Emelyanov <xemul@parallels.com>
---

Al, take a look please, hope I didn't do something stupid.
Here was a testcase https://lkml.org/lkml/2014/5/27/167

 fs/splice.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.git/fs/splice.c
===================================================================
--- linux-2.6.git.orig/fs/splice.c
+++ linux-2.6.git/fs/splice.c
@@ -979,14 +979,14 @@ iter_file_splice_write(struct pipe_inode
 				break;
 			}
 		}
-				
+
 		/* build the vector */
-		for (n = 0, idx = pipe->curbuf; n < pipe->nrbufs; n++, idx++) {
+		for (n = 0, idx = pipe->curbuf; count < sd.total_len && n < pipe->nrbufs; n++, idx++) {
 			struct pipe_buffer *buf = pipe->bufs + idx;
 			size_t this_len = buf->len;
 
-			if (this_len > sd.total_len)
-				this_len = sd.total_len;
+			if (this_len + count > sd.total_len)
+				this_len = sd.total_len - count;
 
 			if (idx == pipe->buffers - 1)
 				idx = -1;
