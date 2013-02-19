Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab3BSIDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:03:15 -0500
Received: from ozlabs.org ([203.10.76.45]:48451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758269Ab3BSICu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 16/16] 9p/trans_virtio.c: use virtio_add_sgs[]
Date: Tue, 19 Feb 2013 18:26:34 +1030
Message-Id: <1361260594-601-17-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_add_buf() is going away, replaced with virtio_add_sgs() which
takes multiple terminated scatterlists.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 net/9p/trans_virtio.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index fd05c81..11d5f46 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -194,11 +194,14 @@ static int pack_sg_list(struct scatterlist *sg, int start,
 		if (s > count)
 			s = count;
 		BUG_ON(index > limit);
+		/* Make sure we don't terminate early. */
+		sg_unmark_end(&sg[index]);
 		sg_set_buf(&sg[index++], data, s);
 		count -= s;
 		data += s;
 	}
-
+	if (index-start)
+		sg_mark_end(&sg[index - 1]);
 	return index-start;
 }
 
@@ -236,12 +239,17 @@ pack_sg_list_p(struct scatterlist *sg, int start, int limit,
 		s = rest_of_page(data);
 		if (s > count)
 			s = count;
+		/* Make sure we don't terminate early. */
+		sg_unmark_end(&sg[index]);
 		sg_set_page(&sg[index++], pdata[i++], s, data_off);
 		data_off = 0;
 		data += s;
 		count -= s;
 		nr_pages--;
 	}
+
+	if (index-start)
+		sg_mark_end(&sg[index - 1]);
 	return index - start;
 }
 
@@ -256,9 +264,10 @@ static int
 p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 {
 	int err;
-	int in, out;
+	int in, out, out_sgs, in_sgs;
 	unsigned long flags;
 	struct virtio_chan *chan = client->trans;
+	struct scatterlist *sgs[2];
 
 	p9_debug(P9_DEBUG_TRANS, "9p debug: virtio request\n");
 
@@ -266,15 +275,21 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 req_retry:
 	spin_lock_irqsave(&chan->lock, flags);
 
+	out_sgs = in_sgs = 0;
 	/* Handle out VirtIO ring buffers */
 	out = pack_sg_list(chan->sg, 0,
 			   VIRTQUEUE_NUM, req->tc->sdata, req->tc->size);
+	if (out)
+		sgs[out_sgs++] = chan->sg;
 
 	in = pack_sg_list(chan->sg, out,
 			  VIRTQUEUE_NUM, req->rc->sdata, req->rc->capacity);
+	if (in)
+		sgs[out_sgs + in_sgs++] = chan->sg + out;
 
-	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc,
+	err = virtqueue_add_sgs(chan->vq, sgs, out_sgs, in_sgs, req->tc,
 				GFP_ATOMIC);
+
 	if (err < 0) {
 		if (err == -ENOSPC) {
 			chan->ring_bufs_avail = 0;
@@ -289,7 +304,7 @@ req_retry:
 		} else {
 			spin_unlock_irqrestore(&chan->lock, flags);
 			p9_debug(P9_DEBUG_TRANS,
-				 "virtio rpc add_buf returned failure\n");
+				 "virtio rpc add_sgs returned failure\n");
 			return -EIO;
 		}
 	}
@@ -351,11 +366,12 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 		     char *uidata, char *uodata, int inlen,
 		     int outlen, int in_hdr_len, int kern_buf)
 {
-	int in, out, err;
+	int in, out, err, out_sgs, in_sgs;
 	unsigned long flags;
 	int in_nr_pages = 0, out_nr_pages = 0;
 	struct page **in_pages = NULL, **out_pages = NULL;
 	struct virtio_chan *chan = client->trans;
+	struct scatterlist *sgs[4];
 
 	p9_debug(P9_DEBUG_TRANS, "virtio request\n");
 
@@ -396,13 +412,22 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	req->status = REQ_STATUS_SENT;
 req_retry_pinned:
 	spin_lock_irqsave(&chan->lock, flags);
+
+	out_sgs = in_sgs = 0;
+
 	/* out data */
 	out = pack_sg_list(chan->sg, 0,
 			   VIRTQUEUE_NUM, req->tc->sdata, req->tc->size);
 
-	if (out_pages)
+	if (out)
+		sgs[out_sgs++] = chan->sg + out;
+
+	if (out_pages) {
 		out += pack_sg_list_p(chan->sg, out, VIRTQUEUE_NUM,
 				      out_pages, out_nr_pages, uodata, outlen);
+		sgs[out_sgs++] = chan->sg + out;
+	}
+		
 	/*
 	 * Take care of in data
 	 * For example TREAD have 11.
@@ -412,11 +437,16 @@ req_retry_pinned:
 	 */
 	in = pack_sg_list(chan->sg, out,
 			  VIRTQUEUE_NUM, req->rc->sdata, in_hdr_len);
-	if (in_pages)
+	if (in)
+		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
+
+	if (in_pages) {
 		in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
 				     in_pages, in_nr_pages, uidata, inlen);
+		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
+	}
 
-	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc,
+	err = virtqueue_add_sgs(chan->vq, sgs, out_sgs, in_sgs, req->tc,
 				GFP_ATOMIC);
 	if (err < 0) {
 		if (err == -ENOSPC) {
@@ -432,7 +462,7 @@ req_retry_pinned:
 		} else {
 			spin_unlock_irqrestore(&chan->lock, flags);
 			p9_debug(P9_DEBUG_TRANS,
-				 "virtio rpc add_buf returned failure\n");
+				 "virtio rpc add_sgs returned failure\n");
 			err = -EIO;
 			goto err_out;
 		}
-- 
1.7.10.4

