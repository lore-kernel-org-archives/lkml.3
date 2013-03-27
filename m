Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3C0CC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:02:26 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:37044 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3C0CCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:02:24 -0400
Message-ID: <51525328.2070407@gmail.com>
Date: Wed, 27 Mar 2013 10:02:16 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: miklos@szeredi.hu
CC: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fuse: Consider the ->big_writes for allocing fuse_req when
 do writing
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fc->big_writes == 0, for write-operation it only do 4k in func fuse_fill_write_pages.
So when alloc fuse_req,we should consider this restrict in order to
do additional operations.
The additional operations are memset-opeartion in func fuse_requenst_alloc and alloc more space if nr_pages is larger than FUSE_REQ_MIN_PAGES.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
fs/fuse/file.c | 7 ++++++-
1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 34b80ba..c584a31 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -912,8 +912,13 @@ static ssize_t fuse_perform_write(struct file *file,
do {
struct fuse_req *req;
ssize_t count;
- unsigned nr_pages = fuse_wr_pages(pos, iov_iter_count(ii));
+ unsigned nr_pages;

+ if (!fc->big_writes)
+ nr_pages = 1;
+ else
+ nr_pages = fuse_wr_pages(pos, iov_iter_count(ii));
+
req = fuse_get_req(fc, nr_pages);
if (IS_ERR(req)) {
err = PTR_ERR(req);
-- 
1.8.2.rc2.4.g7799588

