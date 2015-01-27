Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbbA0MsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:48:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308AbbA0MRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 022/126] rpc: fix xdr_truncate_encode to handle buffer ending on page boundary
Date: Tue, 27 Jan 2015 12:15:27 +0000
Message-Id: <1422361031-19364-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 49a068f82a1d30eb585d7804b05948376be6cf9a upstream.

A struct xdr_stream at a page boundary might point to the end of one
page or the beginning of the next, but xdr_truncate_encode isn't
prepared to handle the former.

This can cause corruption of NFSv4 READDIR replies in the case that a
readdir entry that would have exceeded the client's dircount/maxcount
limit would have ended exactly on a 4k page boundary.  You're more
likely to hit this case on large directories.

Other xdr_truncate_encode callers are probably also affected.

Reported-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Fixes: 3e19ce762b53 "rpc: xdr_truncate_encode"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/xdr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 23fb4e75e245..25ef792dfee6 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -605,7 +605,7 @@ void xdr_truncate_encode(struct xdr_stream *xdr, size_t len)
 	struct kvec *head = buf->head;
 	struct kvec *tail = buf->tail;
 	int fraglen;
-	int new, old;
+	int new;
 
 	if (len > buf->len) {
 		WARN_ON_ONCE(1);
@@ -627,8 +627,8 @@ void xdr_truncate_encode(struct xdr_stream *xdr, size_t len)
 	buf->len -= fraglen;
 
 	new = buf->page_base + buf->page_len;
-	old = new + fraglen;
-	xdr->page_ptr -= (old >> PAGE_SHIFT) - (new >> PAGE_SHIFT);
+
+	xdr->page_ptr = buf->pages + (new >> PAGE_SHIFT);
 
 	if (buf->page_len && buf->len == len) {
 		xdr->p = page_address(*xdr->page_ptr);
-- 
2.1.4

