Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3GHOOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:14:02 -0400
Received: from m59-178.qiye.163.com ([123.58.178.59]:57022 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3GHOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:14:00 -0400
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [RFC] Ceph: Kernel client part of inline data support
Date: Mon,  8 Jul 2013 22:13:51 +0800
Message-Id: <1373292831-25020-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372862768-8194-1-git-send-email-liwang@ubuntukylin.com>
References: <1372862768-8194-1-git-send-email-liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpOVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQVkoKz0kKzooKCQyNSQz
	Pjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz46Pz4pQUtVS0A4NC41
	LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41OjVBS1VLQD8iNTo2MjgkMisk
	NTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBSklVS0A2LjcvMiQpOCsv
	JD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0FLVUtAMiskSiQzNC4p
	JDg1LyRLJEpLS0FLVUtAMiskSiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEhLJDYyNS4vPiQ4NS8k
	SyROS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQCguOSQ#QUpVTk5APTUkKC45JD41LDQp
	PygkMzcxJEpLS0lLSkFLVUlDWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSExISUJJQ0hOTElLVTMWGhIX
	VRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHgY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the kernel client part of inline data support,
the algorithm is described below.

This is a preliminarly implementation based on Linux kernel 3.8.3.

State:
CEPH_INLINE_MIGRATION: The file size has exceeded the threshold of inline, but MDS has the newest inline data
CEPH_INLINE_DISABLED: The file is not inlined, and MDS does not have the inline data

Client:
Open, lookup, getattr, handle_cap_grant etc,
  MDS send inline data together with inode metadata to client

Read side:

if (hold CEPH_CAP_FILE_CACHE capability) // ceph_readpage()/ceph_readpages()
  if (state < CEPH_INLINE_MIGRATION)
    copy inline data from inode buffer into page cache 
  else 
    if (state == CEPH_INLINE_MIGRATION)
      read the data from the OSD
      replace the head of the first page with the inline data from inode buffer
else // ceph_sync_read()
  if (state != CEPH_INLINE_DISABLED)
    send GETATTR message to MDS to fetch inline data into inode buffer
    copy the inline data from inode buffer to user buffer directly
    if (state == CEPH_INLINE_MIGRATION and pos+len>CEPH_INLINE_SIZE)
      continue to read the remaning data from OSD to user buffer

Write side:

if (hold CEPH_CAP_FILE_CACHE capability) 
  if (state < CEPH_INLINE_MIGRATION) // ceph_write_end()
    if (pos < CEPH_INLINE_SIZE)
      if (pos + len > CEPH_INLINE_SIZE)
        let state = CEPH_INLINE_DISABLED
    else
      let state = CEPH_INLINE_MIGRATION
  else if (state == CEPH_INLINE_MIGRATION)
    if (pos < CEPH_INLINE_SIZE)
      let state = CEPH_INLINE_DISABLED;
 
  if (state < CEPH_INLINE_MIGRATION) // ceph_writepage/ceph_writepages_start()
    copy data from page cache into inode buffer
    mark cap and inode dirty to send inode buffer to MDS
  else
    do the normal write to OSD
else // ceph_sync_write()
  if (state != CEPH_INLINE_DISABLED) 
    if (pos < CEPH_INLINE_SIZE)
      copy the written data fit into [pos, min(pos+len, CEPH_INLINE_SIZE)) from user buffer directly to inode buffer
      let dirty_data_only=true, record the write pos as well as length // leave MDS to merge
      mark cap and inode dirty to send (maybe part of) written data to MDS
    if (pos + len >= CEPH_INLINE_SIZE)
      let state = CEPH_INLINE_MIGRATION
      write the remaining data to OSD
  else
    do the normal write to OSD

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/ceph/addr.c               |  186 ++++++++++++++++++++++++++++++++++--------
 fs/ceph/caps.c               |   61 ++++++++++++--
 fs/ceph/file.c               |   90 +++++++++++++++++++-
 fs/ceph/inode.c              |   19 ++++-
 fs/ceph/mds_client.c         |   14 ++--
 fs/ceph/mds_client.h         |    2 +
 fs/ceph/super.h              |   14 ++++
 include/linux/ceph/ceph_fs.h |    4 +
 net/ceph/messenger.c         |    2 +-
 9 files changed, 342 insertions(+), 50 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 064d1a6..033396c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -204,6 +204,18 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 
 	dout("readpage inode %p file %p page %p index %lu\n",
 	     inode, filp, page, page->index);
+
+	if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION && ci->i_inline_data.length) {
+		void *virt = kmap(page);
+		memcpy(virt, ci->i_inline_data.data, ci->i_inline_data.length);
+		kunmap(page);
+		zero_user_segment(page, ci->i_inline_data.length, PAGE_CACHE_SIZE);
+		flush_dcache_page(page);
+		SetPageUptodate(page);
+		err = 0;
+		goto out;
+	}
+	
 	err = ceph_osdc_readpages(osdc, ceph_vino(inode), &ci->i_layout,
 				  (u64) page_offset(page), &len,
 				  ci->i_truncate_seq, ci->i_truncate_size,
@@ -217,6 +229,13 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 		/* zero fill remainder of page */
 		zero_user_segment(page, err, PAGE_CACHE_SIZE);
 	}
+
+	if (ci->i_inline_data.version == CEPH_INLINE_MIGRATION && ci->i_inline_data.length) {
+		void *virt = kmap(page);
+		memcpy(virt, ci->i_inline_data.data, ci->i_inline_data.length);
+		kunmap(page);
+		flush_dcache_page(page);
+	}
 	SetPageUptodate(page);
 
 out:
@@ -252,6 +271,15 @@ static void finish_read(struct ceph_osd_request *req, struct ceph_msg *msg)
 	for (i = 0; i < req->r_num_pages; i++, bytes -= PAGE_CACHE_SIZE) {
 		struct page *page = req->r_pages[i];
 
+		struct ceph_inode_info *ci = ceph_inode(inode);
+		if (ci->i_inline_data.version == CEPH_INLINE_MIGRATION && page->index == 0) {
+			if (ci->i_inline_data.length) {
+				void *virt = kmap(page);
+				memcpy(virt, ci->i_inline_data.data, ci->i_inline_data.length);
+				kunmap(page);
+			}
+		}
+
 		if (bytes < (int)PAGE_CACHE_SIZE) {
 			/* zero (remainder of) page */
 			int s = bytes < 0 ? 0 : bytes;
@@ -372,9 +400,28 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	int rc = 0;
 	int max = 0;
 
+	if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION) {
+		struct page *page = list_entry(page_list->prev, struct page, lru);
+		if (ci->i_inline_data.length) {
+			void *virt = kmap(page);
+			memcpy(virt, ci->i_inline_data.data, ci->i_inline_data.length);
+			kfree(tem);
+			kunmap(page);
+		}
+		zero_user_segment(page, ci->i_inline_data.length, PAGE_CACHE_SIZE);
+		flush_dcache_page(page);
+		SetPageUptodate(page);
+		list_del(&page->lru);		
+		add_to_page_cache_lru(page, &inode->i_data, page->index, GFP_NOFS);
+		unlock_page(page);
+		rc = 1;
+		goto out;
+	}
+
 	if (fsc->mount_options->rsize >= PAGE_CACHE_SIZE)
 		max = (fsc->mount_options->rsize + PAGE_CACHE_SIZE - 1)
 			>> PAGE_SHIFT;
@@ -488,12 +535,31 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 		set_bdi_congested(&fsc->backing_dev_info, BLK_RW_ASYNC);
 
 	set_page_writeback(page);
+	
+	if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION) {
+			if (ci->i_inline_data.data == NULL)
+				ci->i_inline_data.data = kmalloc(CEPH_INLINE_SIZE, GFP_NOFS);
+			ci->i_inline_data.length = inode->i_size < CEPH_INLINE_SIZE?inode->i_size:CEPH_INLINE_SIZE;
+			char *virt = kmap(page);
+			memcpy(ci->i_inline_data.data, virt, ci->i_inline_data.length);
+			kunmap(page);
+			spin_lock(&ci->i_ceph_lock);
+			int dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER);
+			spin_unlock(&ci->i_ceph_lock);
+			if (dirty)
+				__mark_inode_dirty(inode, dirty);
+			goto written;
+	}
+	
 	err = ceph_osdc_writepages(osdc, ceph_vino(inode),
 				   &ci->i_layout, snapc,
 				   page_off, len,
 				   ci->i_truncate_seq, ci->i_truncate_size,
 				   &inode->i_mtime,
 				   &page, 1, 0, 0, true);
+	
+	written:
+	
 	if (err < 0) {
 		dout("writepage setting page/mapping error %d %p\n", err, page);
 		SetPageError(page);
@@ -669,8 +735,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 	unsigned wsize = 1 << inode->i_blkbits;
 	struct ceph_osd_request *req = NULL;
 	int do_sync;
-	u64 snap_size = 0;
-
+	u64 snap_size = 0;	
+	bool written = false;
+	
 	/*
 	 * Include a 'sync' in the OSD request if this is a data
 	 * integrity write (e.g., O_SYNC write or fsync()), or if our
@@ -744,7 +811,7 @@ retry:
 		struct ceph_osd_request_head *reqhead;
 		struct ceph_osd_op *op;
 		long writeback_stat;
-
+		
 		next = 0;
 		locked_pages = 0;
 		max_pages = max_pages_ever;
@@ -761,7 +828,8 @@ get_more_pages:
 		dout("pagevec_lookup_tag got %d\n", pvec_pages);
 		if (!pvec_pages && !locked_pages)
 			break;
-		for (i = 0; i < pvec_pages && locked_pages < max_pages; i++) {
+		for (i = 0; i < pvec_pages && locked_pages < max_pages; i++) {			
+			written = false;
 			page = pvec.pages[i];
 			dout("? %p idx %lu\n", page, page->index);
 			if (locked_pages == 0)
@@ -823,12 +891,38 @@ get_more_pages:
 				break;
 			}
 
+			if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION && page->index == 0) {
+				if (ci->i_inline_data.data == NULL)
+					ci->i_inline_data.data = kmalloc(CEPH_INLINE_SIZE, GFP_NOFS);
+				char *virt = kmap(page);
+				ci->i_inline_data.length = inode->i_size < CEPH_INLINE_SIZE?inode->i_size:CEPH_INLINE_SIZE;
+				memcpy(ci->i_inline_data.data, virt, ci->i_inline_data.length);
+				kunmap(page);
+				spin_lock(&ci->i_ceph_lock);
+				int dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER);
+				spin_unlock(&ci->i_ceph_lock);
+				if (dirty)
+					__mark_inode_dirty(inode, dirty);
+				ceph_put_snap_context(page_snap_context(page));
+				page->private = 0;
+				ClearPagePrivate(page);
+				SetPageUptodate(page);
+				unsigned issued = ceph_caps_issued(ci);
+				if ((issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0)
+					generic_error_remove_page(inode->i_mapping, page);
+				unlock_page(page);				
+				ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
+				written = true;
+				rc = 0;
+			}
+
 			/* ok */
 			if (locked_pages == 0) {
 				/* prepare async write request */
 				offset = (u64) page_offset(page);
 				len = wsize;
-				req = ceph_osdc_new_request(&fsc->client->osdc,
+				if (written == false) {
+					req = ceph_osdc_new_request(&fsc->client->osdc,
 					    &ci->i_layout,
 					    ceph_vino(inode),
 					    offset, &len,
@@ -840,35 +934,40 @@ get_more_pages:
 					    ci->i_truncate_size,
 					    &inode->i_mtime, true, 1, 0);
 
-				if (IS_ERR(req)) {
-					rc = PTR_ERR(req);
-					unlock_page(page);
-					break;
-				}
+					if (IS_ERR(req)) {
+						rc = PTR_ERR(req);
+						unlock_page(page);
+						break;
+					}
 
-				max_pages = req->r_num_pages;
+					max_pages = req->r_num_pages;
 
-				alloc_page_vec(fsc, req);
-				req->r_callback = writepages_finish;
-				req->r_inode = inode;
-			}
+					alloc_page_vec(fsc, req);
+					req->r_callback = writepages_finish;
+					req->r_inode = inode;
+					} else { 
+						max_pages = calc_pages_for(0, len);
+					}
+				}
 
 			/* note position of first page in pvec */
 			if (first < 0)
 				first = i;
 			dout("%p will write page %p idx %lu\n",
 			     inode, page, page->index);
+			
 
-			writeback_stat =
+			if (written == false) {
+				writeback_stat =
 			       atomic_long_inc_return(&fsc->writeback_count);
 			if (writeback_stat > CONGESTION_ON_THRESH(
 				    fsc->mount_options->congestion_kb)) {
 				set_bdi_congested(&fsc->backing_dev_info,
 						  BLK_RW_ASYNC);
 			}
-
-			set_page_writeback(page);
-			req->r_pages[locked_pages] = page;
+				set_page_writeback(page);
+				req->r_pages[locked_pages] = page;
+			}
 			locked_pages++;
 			next = page->index + 1;
 		}
@@ -897,31 +996,33 @@ get_more_pages:
 			pvec.nr -= i-first;
 		}
 
+		if (written == false) {
 		/* submit the write */
-		offset = req->r_pages[0]->index << PAGE_CACHE_SHIFT;
-		len = min((snap_size ? snap_size : i_size_read(inode)) - offset,
+			offset = req->r_pages[0]->index << PAGE_CACHE_SHIFT;
+			len = min((snap_size ? snap_size : i_size_read(inode)) - offset,
 			  (u64)locked_pages << PAGE_CACHE_SHIFT);
-		dout("writepages got %d pages at %llu~%llu\n",
+			dout("writepages got %d pages at %llu~%llu\n",
 		     locked_pages, offset, len);
 
-		/* revise final length, page count */
-		req->r_num_pages = locked_pages;
-		reqhead = req->r_request->front.iov_base;
-		op = (void *)(reqhead + 1);
-		op->extent.length = cpu_to_le64(len);
-		op->payload_len = cpu_to_le32(len);
-		req->r_request->hdr.data_len = cpu_to_le32(len);
-
-		rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
-		BUG_ON(rc);
+			/* revise final length, page count */
+			req->r_num_pages = locked_pages;
+			reqhead = req->r_request->front.iov_base;
+			op = (void *)(reqhead + 1);
+			op->extent.length = cpu_to_le64(len);
+			op->payload_len = cpu_to_le32(len);
+			req->r_request->hdr.data_len = cpu_to_le32(len);
+
+			rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
+			BUG_ON(rc);
+		}		
 		req = NULL;
-
+		
 		/* continue? */
 		index = next;
 		wbc->nr_to_write -= locked_pages;
 		if (wbc->nr_to_write <= 0)
-			done = 1;
-
+			done = 1;		
+		
 release_pvec_pages:
 		dout("pagevec_release on %d pages (%p)\n", (int)pvec.nr,
 		     pvec.nr ? pvec.pages[0] : NULL);
@@ -945,6 +1046,7 @@ release_pvec_pages:
 out:
 	if (req)
 		ceph_osdc_put_request(req);
+	
 	ceph_put_snap_context(snapc);
 	dout("writepages done, rc = %d\n", rc);
 	return rc;
@@ -1164,6 +1266,20 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
 	if (pos+copied > inode->i_size)
 		check_cap = ceph_inode_set_size(inode, pos+copied);
 
+	if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION) {
+		if (pos >= CEPH_INLINE_SIZE) {
+			ci->i_inline_data.version = CEPH_INLINE_MIGRATION;
+		} else {
+			if (pos + copied > CEPH_INLINE_SIZE) {
+				ci->i_inline_data.version = CEPH_INLINE_DISABLED;
+			}
+		}
+	}
+	if (ci->i_inline_data.version == CEPH_INLINE_MIGRATION) {
+		if (pos < CEPH_INLINE_SIZE)
+				ci->i_inline_data.version = CEPH_INLINE_DISABLED;
+	}
+	
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a1d9bb3..124ba52 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -933,7 +933,9 @@ static int send_cap_msg(struct ceph_mds_session *session,
 			uid_t uid, gid_t gid, umode_t mode,
 			u64 xattr_version,
 			struct ceph_buffer *xattrs_buf,
-			u64 follows)
+			u64 follows,
+			struct ceph_inline_data_info *inline_data
+			)
 {
 	struct ceph_mds_caps *fc;
 	struct ceph_msg *msg;
@@ -946,15 +948,15 @@ static int send_cap_msg(struct ceph_mds_session *session,
 	     seq, issue_seq, mseq, follows, size, max_size,
 	     xattr_version, xattrs_buf ? (int)xattrs_buf->vec.iov_len : 0);
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc), GFP_NOFS, false);
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc)+
+		                 inline_data->length+(inline_data->dirty_data_only?12:4), GFP_NOFS, false);
 	if (!msg)
 		return -ENOMEM;
 
 	msg->hdr.tid = cpu_to_le64(flush_tid);
 
 	fc = msg->front.iov_base;
-	memset(fc, 0, sizeof(*fc));
-
+	memset(fc, 0, sizeof(*fc)+inline_data->length+(inline_data->dirty_data_only?12:4));
 	fc->cap_id = cpu_to_le64(cid);
 	fc->op = cpu_to_le32(op);
 	fc->seq = cpu_to_le32(seq);
@@ -979,12 +981,38 @@ static int send_cap_msg(struct ceph_mds_session *session,
 	fc->mode = cpu_to_le32(mode);
 
 	fc->xattr_version = cpu_to_le64(xattr_version);
+
+	struct ceph_mds_caps *s = fc + 1;	
+	u32 *p = (u32 *)s;
+	if ((dirty & CEPH_CAP_FILE_WR) && (dirty & CEPH_CAP_FILE_BUFFER)) {
+		fc->inline_version = inline_data->dirty_data_only?0:cpu_to_le32(inline_data->version);
+		if (inline_data->dirty_data_only == false) {			
+			*p = cpu_to_le32(inline_data->length);
+			p++;
+			if (inline_data->length)
+				memcpy(p, inline_data->data, inline_data->length);
+		} else {
+			*p = cpu_to_le32(inline_data->length)+8;
+			p++;
+			*p = cpu_to_le32(inline_data->offset);
+			p++;
+			*p = cpu_to_le32(inline_data->length);
+			if (inline_data->length)
+				memcpy(p, inline_data->data, inline_data->length);
+			inline_data->length = 0;
+			inline_data->dirty_data_only = false;
+			inline_data->offset = 0;
+		} 	
+	} else {
+		fc->inline_version = cpu_to_le32(0);
+		*p = cpu_to_le32(0);
+	}
 	if (xattrs_buf) {
 		msg->middle = ceph_buffer_get(xattrs_buf);
 		fc->xattr_len = cpu_to_le32(xattrs_buf->vec.iov_len);
 		msg->hdr.middle_len = cpu_to_le32(xattrs_buf->vec.iov_len);
 	}
-
+	
 	ceph_con_send(&session->s_con, msg);
 	return 0;
 }
@@ -1179,7 +1207,9 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 		op, keep, want, flushing, seq, flush_tid, issue_seq, mseq,
 		size, max_size, &mtime, &atime, time_warp_seq,
 		uid, gid, mode, xattr_version, xattr_blob,
-		follows);
+		follows,
+		&ci->i_inline_data
+		);
 	if (ret < 0) {
 		dout("error sending cap msg, must requeue %p\n", inode);
 		delayed = 1;
@@ -1300,7 +1330,9 @@ retry:
 			     capsnap->time_warp_seq,
 			     capsnap->uid, capsnap->gid, capsnap->mode,
 			     capsnap->xattr_version, capsnap->xattr_blob,
-			     capsnap->follows);
+			     capsnap->follows,
+			     &ci->i_inline_data
+			     );
 
 		next_follows = capsnap->follows + 1;
 		ceph_put_cap_snap(capsnap);
@@ -2386,6 +2418,20 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 	ceph_fill_file_size(inode, issued,
 			    le32_to_cpu(grant->truncate_seq),
 			    le64_to_cpu(grant->truncate_size), size);
+	
+	if ((newcaps & CEPH_CAP_FILE_CACHE) &&
+      (le32_to_cpu(grant->inline_version) >= ci->i_inline_data.version)) {
+    	ci->i_inline_data.version = le32_to_cpu(grant->inline_version);
+		struct ceph_mds_caps *s = grant+1;
+		u32 *p = (u32 *)s;
+		ci->i_inline_data.length = le32_to_cpu(*p);
+		if (ci->i_inline_data.length) {
+			if (ci->i_inline_data.data == NULL)
+				ci->i_inline_data.data = kmalloc(CEPH_INLINE_SIZE, GFP_NOFS);
+			p++;
+			memcpy(ci->i_inline_data.data, p, ci->i_inline_data.length);  
+		}
+  	}
 	ceph_decode_timespec(&mtime, &grant->mtime);
 	ceph_decode_timespec(&atime, &grant->atime);
 	ceph_decode_timespec(&ctime, &grant->ctime);
@@ -3092,3 +3138,4 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	spin_unlock(&dentry->d_lock);
 	return ret;
 }
+
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e51558f..1b46147 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -421,6 +421,45 @@ static ssize_t ceph_sync_read(struct file *file, char __user *data,
 	if (ret < 0)
 		goto done;
 
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_request *req;
+	
+	if ((ci->i_inline_data.version != CEPH_INLINE_DISABLED) && 
+			(ceph_caps_issued(ci) & CEPH_CAP_FILE_CACHE) == 0) {
+			req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
+			if (IS_ERR(req))
+				return PTR_ERR(req);
+			req->r_inode = inode;
+			ihold(inode);
+			req->r_num_caps = 1;
+			req->r_args.getattr.mask = cpu_to_le32(CEPH_STAT_CAP_INLINE);
+			ret = ceph_mdsc_do_request(mdsc, NULL, req);
+			ceph_mdsc_put_request(req);
+			if (off >= inode->i_size) {
+				*checkeof = 1;
+				return 0;
+			}
+			if (off < ci->i_inline_data.length) {
+				ret = ci->i_inline_data.length - off;
+				if (len < ret)
+					ret = len;
+				copy_to_user(data, ci->i_inline_data.data+off, ret);
+				off = off + ret;				
+				*poff = off;
+				if (off < ci->i_inline_data.length) {
+					return ret;
+				}
+				if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION) {						
+					*checkeof = 1;						
+					return ret;
+				}
+				len = len - ret;
+				data = data + ret;
+			}
+	}
+	
 	ret = striped_read(inode, off, len, pages, num_pages, checkeof,
 			   file->f_flags & O_DIRECT,
 			   (unsigned long)data & ~PAGE_MASK);
@@ -512,6 +551,41 @@ static ssize_t ceph_sync_write(struct file *file, const char __user *data,
 	else
 		do_sync = 1;
 
+	if ((ci->i_inline_data.version != CEPH_INLINE_DISABLED) &&
+			(ceph_caps_issued(ci) & CEPH_CAP_FILE_CACHE) == 0) {
+			if (pos < CEPH_INLINE_SIZE) {
+					ret = CEPH_INLINE_SIZE - pos;
+					if (left < ret)
+						ret = left;
+					if (ci->i_inline_data.data == NULL) {
+						ci->i_inline_data.data = kmalloc(CEPH_INLINE_SIZE, GFP_NOFS);
+					}
+					copy_from_user(ci->i_inline_data.data, data, ret);
+					ci->i_inline_data.offset = pos;
+					ci->i_inline_data.length = ret;
+					ci->i_inline_data.dirty_data_only = true;
+					spin_lock(&ci->i_ceph_lock);
+					int dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER);
+					spin_unlock(&ci->i_ceph_lock);
+					if (dirty)
+						__mark_inode_dirty(inode, dirty);
+					pos = pos + ret;
+					if (pos < CEPH_INLINE_SIZE) {
+						*offset = pos;
+						return ret;
+					}
+					if (ci->i_inline_data.version < CEPH_INLINE_MIGRATION) {						
+						*offset = pos;
+						left = left - ret;
+						data = data + ret;
+						written = ret;
+						ci->i_inline_data.version = CEPH_INLINE_MIGRATION;
+					}
+				}else {
+					ci->i_inline_data.version = CEPH_INLINE_MIGRATION;
+				}
+	}
+	
 	/*
 	 * we may need to do multiple writes here if we span an object
 	 * boundary.  this isn't atomic, unfortunately.  :(
@@ -724,6 +798,19 @@ retry_snap:
 		return -ENOSPC;
 	__ceph_do_pending_vmtruncate(inode);
 
+	int want;
+	int have;
+	if (ci->i_inline_data.version != CEPH_INLINE_DISABLED) {
+    	want = 0;
+    	if (pos < CEPH_INLINE_SIZE)
+      		want |= CEPH_CAP_FILE_CACHE;
+    	if (endoff > CEPH_INLINE_SIZE)
+      		want |= CEPH_CAP_FILE_BUFFER;
+  	} else {
+    	want = CEPH_CAP_FILE_BUFFER;
+  	}
+  	ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, &have, endoff);
+
 	/*
 	 * try to do a buffered write.  if we don't have sufficient
 	 * caps, we'll get -EAGAIN from generic_file_aio_write, or a
@@ -732,7 +819,7 @@ retry_snap:
 	if (!(iocb->ki_filp->f_flags & O_DIRECT) &&
 	    !(inode->i_sb->s_flags & MS_SYNCHRONOUS) &&
 	    !(fi->flags & CEPH_F_SYNC)) {
-		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);		
 		if (ret >= 0)
 			written = ret;
 
@@ -747,6 +834,7 @@ retry_snap:
 			goto out;
 	}
 
+
 	dout("aio_write %p %llx.%llx %llu~%u getting caps. i_size %llu\n",
 	     inode, ceph_vinop(inode), pos + written,
 	     (unsigned)iov->iov_len - written, inode->i_size);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2971eaa..0259be1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -376,6 +376,12 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	INIT_WORK(&ci->i_vmtruncate_work, ceph_vmtruncate_work);
 
+	ci->i_inline_data.version = 1;
+	ci->i_inline_data.length = 0;
+	ci->i_inline_data.data = NULL;
+	ci->i_inline_data.dirty_data_only = false;
+	ci->i_inline_data.offset = 0;
+	
 	return &ci->vfs_inode;
 }
 
@@ -629,6 +635,17 @@ static int fill_inode(struct inode *inode,
 					  le32_to_cpu(info->truncate_seq),
 					  le64_to_cpu(info->truncate_size),
 					  le64_to_cpu(info->size));
+	
+	u32 inline_version = le32_to_cpu(info->inline_version);
+	if (inline_version) {
+		ci->i_inline_data.version = le32_to_cpu(info->inline_version);
+		ci->i_inline_data.length = le32_to_cpu(iinfo->inline_len);
+		if (ci->i_inline_data.length) {
+			ci->i_inline_data.data = kmalloc(CEPH_INLINE_SIZE, GFP_NOFS);
+			memcpy(ci->i_inline_data.data, iinfo->inline_data, ci->i_inline_data.length);			
+		}
+	}
+	
 	ceph_fill_file_time(inode, issued,
 			    le32_to_cpu(info->time_warp_seq),
 			    &ctime, &mtime, &atime);
@@ -944,7 +961,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 	int i = 0;
 	int err = 0;
-
+	
 	dout("fill_trace %p is_dentry %d is_target %d\n", req,
 	     rinfo->head->is_dentry, rinfo->head->is_target);
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9165eb8..ff96d51 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -70,9 +70,9 @@ static int parse_reply_info_in(void **p, void *end,
 	*p += sizeof(struct ceph_mds_reply_inode) +
 		sizeof(*info->in->fragtree.splits) *
 		le32_to_cpu(info->in->fragtree.nsplits);
-
+	
 	ceph_decode_32_safe(p, end, info->symlink_len, bad);
-	ceph_decode_need(p, end, info->symlink_len, bad);
+	ceph_decode_need(p, end, info->symlink_len, bad);	
 	info->symlink = *p;
 	*p += info->symlink_len;
 
@@ -82,10 +82,14 @@ static int parse_reply_info_in(void **p, void *end,
 	else
 		memset(&info->dir_layout, 0, sizeof(info->dir_layout));
 
-	ceph_decode_32_safe(p, end, info->xattr_len, bad);
-	ceph_decode_need(p, end, info->xattr_len, bad);
+	ceph_decode_32_safe(p, end, info->xattr_len, bad);	
+	ceph_decode_need(p, end, info->xattr_len, bad);	
 	info->xattr_data = *p;
 	*p += info->xattr_len;
+	ceph_decode_32_safe(p, end, info->inline_len, bad);
+	ceph_decode_need(p, end, info->inline_len, bad);
+	info->inline_data = *p;
+	*p += info->inline_len;
 	return 0;
 bad:
 	return err;
@@ -273,7 +277,7 @@ static int parse_reply_info(struct ceph_msg *msg,
 	ceph_decode_32_safe(&p, end, len, bad);
 	if (len > 0) {
 		ceph_decode_need(&p, end, len, bad);
-		err = parse_reply_info_extra(&p, p+len, info, features);
+		err = parse_reply_info_extra(&p, p+len, info, features);		
 		if (err < 0)
 			goto out_bad;
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index dd26846..846759b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -41,6 +41,8 @@ struct ceph_mds_reply_info_in {
 	char *symlink;
 	u32 xattr_len;
 	char *xattr_data;
+	u32 inline_len;
+	char *inline_data;
 };
 
 /*
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 66ebe72..cfb5ad6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -245,6 +245,18 @@ struct ceph_inode_xattrs_info {
 	u64 version, index_version;
 };
 
+#define CEPH_INLINE_SIZE       (1 << 8)
+#define CEPH_INLINE_DISABLED   ((__u32)-1)
+#define CEPH_INLINE_MIGRATION  (CEPH_INLINE_DISABLED >> 1)
+
+struct ceph_inline_data_info {
+	u32 version;
+	u32 length;
+	char *data;
+	bool dirty_data_only;
+	u32 offset;
+};
+
 /*
  * Ceph inode.
  */
@@ -331,6 +343,8 @@ struct ceph_inode_info {
 
 	struct work_struct i_vmtruncate_work;
 
+	struct ceph_inline_data_info i_inline_data;
+
 	struct inode vfs_inode; /* at end */
 };
 
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index cf6f4d9..6554d77 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -457,6 +457,7 @@ struct ceph_mds_reply_inode {
 	struct ceph_file_layout layout;
 	struct ceph_timespec ctime, mtime, atime;
 	__le32 time_warp_seq;
+	__le32 inline_version;
 	__le64 size, max_size, truncate_size;
 	__le32 truncate_seq;
 	__le32 mode, uid, gid;
@@ -563,6 +564,7 @@ int ceph_flags_to_mode(int flags);
 #define CEPH_STAT_CAP_MTIME    CEPH_CAP_FILE_SHARED
 #define CEPH_STAT_CAP_SIZE     CEPH_CAP_FILE_SHARED
 #define CEPH_STAT_CAP_ATIME    CEPH_CAP_FILE_SHARED  /* fixme */
+#define CEPH_STAT_CAP_INLINE   CEPH_CAP_FILE_SHARED
 #define CEPH_STAT_CAP_XATTR    CEPH_CAP_XATTR_SHARED
 #define CEPH_STAT_CAP_INODE_ALL (CEPH_CAP_PIN |			\
 				 CEPH_CAP_AUTH_SHARED |	\
@@ -640,6 +642,8 @@ struct ceph_mds_caps {
 	struct ceph_timespec mtime, atime, ctime;
 	struct ceph_file_layout layout;
 	__le32 time_warp_seq;
+
+	__le32 inline_version;
 } __attribute__ ((packed));
 
 /* cap release msg head */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5ccf87e..a0e836d 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1914,7 +1914,7 @@ static int read_partial_message(struct ceph_connection *con)
 	}
 
 	/* (page) data */
-	while (con->in_msg_pos.data_pos < data_len) {
+    	while (con->in_msg_pos.data_pos < data_len) {	
 		if (m->pages) {
 			ret = read_partial_message_pages(con, m->pages,
 						 data_len, do_datacrc);
-- 
1.7.9.5


