Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3FNQ1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:27:48 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50987 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3FNQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:27:47 -0400
Date: Fri, 14 Jun 2013 09:27:46 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Li Wang <liwang@ubuntukylin.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 2/2] Punch hole support against 3.10-rc5
In-Reply-To: <1371224340-4926-1-git-send-email-liwang@ubuntukylin.com>
Message-ID: <alpine.DEB.2.00.1306140902490.26467@cobra.newdream.net>
References: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com> <1371224340-4926-1-git-send-email-liwang@ubuntukylin.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Li Wang wrote:
> This patch implements punch hole (fallocate) support against
> Linux kernel 3.10-rc5.
> 
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> ---
>  fs/ceph/file.c        |  245 +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/ceph/osd_client.c |    8 +-
>  2 files changed, 251 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 656e169..e092b69 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -8,6 +8,7 @@
>  #include <linux/namei.h>
>  #include <linux/writeback.h>
>  #include <linux/aio.h>
> +#include <linux/falloc.h>
>  
>  #include "super.h"
>  #include "mds_client.h"
> @@ -882,6 +883,249 @@ out:
>  	return offset;
>  }
>  
> +static inline void ceph_zero_partial_page(struct inode *inode, pgoff_t index, unsigned start, unsigned size)
> +{
> +	struct page *page;
> +
> +	page = find_lock_page(inode->i_mapping, index);
> +	if (page) {
> +		zero_user(page, start, size);
> +		unlock_page(page);
> +		page_cache_release(page);
> +	}	
> +}
> +
> +static void ceph_truncate_and_zero_page_cache(struct inode *inode, loff_t offset, loff_t length)
> +{
> +	loff_t first_page;
> +	loff_t last_page;
> +	loff_t zero_len;
> +
> +	first_page =((offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;

whitespace

> +	last_page = ((offset + length) >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
> +	if (last_page > first_page) {
> +		truncate_pagecache_range(inode, first_page, last_page - 1);
> +	}
> +	if (first_page > last_page) {
> +		ceph_zero_partial_page(inode, offset >> PAGE_CACHE_SHIFT, offset & (PAGE_CACHE_SIZE - 1), length);
> +		return;
> +	}
> +	/*
> +	 * zero out the partial page that contains
> +	 * the start of the hole
> +	 */	
> +	zero_len  = first_page - offset;
here too
> +	if (zero_len > 0) {
> +		ceph_zero_partial_page(inode, offset >> PAGE_CACHE_SHIFT, offset & (PAGE_CACHE_SIZE -1), zero_len);
> +	}
> +	/*
> +	 * zero out the partial page that contains
> +	 * the end of the hole
> +	 */
> +	zero_len = offset + length - last_page;
> +	if (zero_len > 0) {
> +		ceph_zero_partial_page(inode, (offset + length) >> PAGE_CACHE_SHIFT, 0, zero_len);
> +	}
> +	/*
> +	 * If i_size is contained in the last page, we need to
> +	 * zero the partial page after i_size
> +	 */
> +	if (inode->i_size >> PAGE_CACHE_SHIFT == (offset + length) >> PAGE_CACHE_SHIFT && inode->i_size % PAGE_CACHE_SIZE != 0) {
> +		zero_len = PAGE_CACHE_SIZE -
> +			(inode->i_size & (PAGE_CACHE_SIZE - 1));
> +		if (zero_len > 0) {
> +			ceph_zero_partial_page(inode, inode->i_size >> PAGE_CACHE_SHIFT, inode->i_size & (PAGE_CACHE_SIZE -1), zero_len);
> +		}
> +	}
> +}
> +
> +static int ceph_delete_object_range(struct inode *inode, loff_t lstart, loff_t lend)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +    struct ceph_fs_client *fsc = ceph_inode_to_client(inode);	
> +	struct ceph_osd_request *req;
> +	u64 length = ceph_file_layout_object_size(ci->i_layout);
> +	loff_t offset;
> +	int ret = 0;
> +
> +	if (lstart > lend || length <= 0)
> +		goto out;
> +	for (offset = lstart; offset <= lend; offset += length) {		
> +		req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
> +                                    ceph_vino(inode), offset, &length,
> +                                    1, CEPH_OSD_OP_DELETE, CEPH_OSD_FLAG_ONDISK,
> +                                    NULL,
> +                                    ci->i_truncate_seq, ci->i_truncate_size,
> +                                    false);
> +		if (IS_ERR(req)) {
> +        	ret = PTR_ERR(req);
> +			goto out;
> +		}

One tweak here: for the very first object, we want to truncate it to 0 
instead of deleting it.  The object has some other metadata attached to 
it (the mds's backtrace structure is stored there as an attr) and we don't 
want to lose that.

> +
> +    	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> +    	if (!ret) {
> +        	ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +    	}
> +		ceph_osdc_put_request(req); 
> +		/* object deleted */
> +		if (ret == -ENOENT)
> +			ret = 0;
> +	}
> +
> +	out:
> +	return ret;
> +}
> +
> +static int ceph_zero_partial_object(struct file *file, loff_t offset, loff_t length)
> +{
> +	struct ceph_file_info *fi = file->private_data;	
> +	struct inode *inode = file->f_dentry->d_inode;
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);	
> +	struct ceph_osd_request *req;
> +	int want, got = 0, ret = 0;
> +	
> +	if (length <= 0)
> +		goto out;
> +
> +	
> +	if (fi->fmode & CEPH_FILE_MODE_LAZY)
> +			want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
> +		else
> +			want = CEPH_CAP_FILE_BUFFER;
> +	
> +	ret = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, &got, offset+length);
> +	if (ret < 0)
> +		goto out;
> +	if (!(got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO))) {
> +		ceph_put_cap_refs(ci, got);
> +		ret = -EAGAIN;
> +		goto out;
> +	}

I think we should do all of the cap checks in the outer caller, so that it 
happens only once for the entire hole punch operation... not on every 
object.

> +	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
> +                                    ceph_vino(inode), offset, &length, 1,
> +                                    CEPH_OSD_OP_ZERO, CEPH_OSD_FLAG_WRITE | CEPH_OSD_FLAG_ONDISK,
> +                                    NULL,
> +                                    ci->i_truncate_seq, ci->i_truncate_size,
> +                                    false);
> +	if (IS_ERR(req)) {
> +    	ret = PTR_ERR(req);
> +		goto out;
> +	}
> +
> +    ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> +    if (!ret) {
> +        ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +    }
> +	ceph_osdc_put_request(req); 	
> +	ceph_put_cap_refs(ci, got);
> +
> +	out:
> +	return ret;
> +}
> +
> +static int ceph_delete_and_zero_objects(struct file *file, loff_t offset, loff_t length)
> +{
> +	unsigned long first_object;
> +	unsigned long last_object;
> +	struct inode *inode = file->f_dentry->d_inode;
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	__s32 object_size;
> +	__u32 object_shift;	
> +	loff_t zero_len;
> +	int ret = 0;
> +	
> +	if (!(object_size = ceph_file_layout_object_size(ci->i_layout)))
> +		goto out;
> +	if (object_size == 1) {
> +		object_shift = 0;
> +	} else {
> +		for (object_shift = 0; ;object_shift++) {
> +			if (2 << object_shift == object_size)
> +				break;
> +		}
> +		object_shift++;
> +	}

Hmm, ok, here is where we run into a problem.  The default striping 
strategy is very simple: 4 MB objects.  But the layout can support more 
complicated layouts, like:

 obj0  obj1  obj2  obj3  obj4  ...
   0     1    8      9    16   ...
   2     3   10     11    ...
   4     5   12     13
   6     7   14     15

which means that a hole punch (say, from 4-14) may end up truncating 
several objects (obj0 and obj1) and zeroing ranges in several others (obj2 
and obj3).  The read/write path keep things simple by just writing a 
stripe unit at a time.  That's not efficient for these types of layouts, 
but we haven't bothered to do anything more complicated since nobody 
really uses these weird layouts.  The hole punch needs to at least be 
correct, however, even if it isn't efficient.  Zeroing in pieces will get 
the right result, but won't be storage efficient because you may zero 
several pieces of an object instead of just deleting it.  So this may be 
the time to solve that particular problem.

At a high level, what we need is a way to map a file range onto a vector 
of objects and ranges within those objects.  We can do this in "period" 
increments (where period is object_size * stripe_count bytes) so that the 
array/vector sizes are known in advance ((object_size / stripe_unit) * 
stripe_count cells).  Probably a helper that calculates the mapping onto 
objects, so that zero can zero several stripe units/cells at at once, or 
remove entire objects.

Then in the future we can make the read/write path also make use of it.  
For the IO case we also will need to know how file offsets map to object 
offsets, but for the zero case that's not needed, so you could ignore it 
fore now (eventually it should probably be an optional output 
argument/pointer).

Does that make sense?

> +	
> +	first_object =((offset + object_size - 1) >> object_shift) << object_shift;
whitespace

> +	last_object = ((offset + length) >> object_shift) << object_shift;
> +	if (last_object > first_object) {
> +		ret = ceph_delete_object_range(inode, first_object, last_object - 1);
> +		if (ret)
> +			goto out;
> +	}
> +	if (first_object > last_object) {
> +		ret = ceph_zero_partial_object(file, offset, length);
> +		goto out;
> +	}
> +	/*
> +	 * zero out the partial object that contains
> +	 * the start of the hole
> +	 */	
> +	zero_len  = first_object - offset;
> +	if (zero_len > 0) {
> +		ret = ceph_zero_partial_object(file, offset, zero_len);
> +		if (ret)
> +			goto out;
> +	}
> +	/*
> +	 * zero out the partial object that contains
> +	 * the end of the hole
> +	 */
> +	zero_len = offset + length - last_object;
> +	if (zero_len > 0) {
> +		ret = ceph_zero_partial_object(file, last_object, zero_len);
> +	}
> +
> +	out:
> +	return ret;
> +}
> +
> +static int ceph_punch_hole(struct file *file, loff_t offset, loff_t length)
> +{
> +	struct inode *inode = file->f_dentry->d_inode;
> +	int ret = 0;
> +
> +    if (!S_ISREG(inode->i_mode)) {
> +        return -EOPNOTSUPP;
> +	}
> +	if (IS_SWAPFILE(inode)) {
> +		return -ETXTBSY;
> +	}
> +	mutex_lock(&inode->i_mutex);
> +
> +	/* No need to punch hole beyond i_size */
> +	if (offset >= inode->i_size)
> +		goto out_unlock;
> +
> +	/*
> +	 * If the hole extends beyond i_size, set the hole
> +	 * to end after the page that contains i_size
> +	 */
> +	if (offset + length > inode->i_size) {
> +		length = inode->i_size +
> +		   PAGE_CACHE_SIZE - (inode->i_size & (PAGE_CACHE_SIZE - 1)) -
> +		   offset;
> +	}

I think we should do teh caps stuff here.

> +
> +	ceph_truncate_and_zero_page_cache(inode, offset, length);
> +	ret = ceph_delete_and_zero_objects(file, offset, length);
> +	
> +	out_unlock:
> +	mutex_unlock(&inode->i_mutex);
> +	return ret;
> +}
> +
> +static long ceph_fallocate(struct file *file, int mode, loff_t offset, loff_t length)
> +{
> +	/* FALLOC_FL_PUNCH_HOLE must be used with FALLOC_FL_KEEP_SIZE */

That is just to simplify the implementation, right?

> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +		return -EOPNOTSUPP;
> +	if (mode & FALLOC_FL_PUNCH_HOLE)
> +		return ceph_punch_hole(file, offset, length);
> +	return -EOPNOTSUPP;
> +}
> +
>  const struct file_operations ceph_file_fops = {
>  	.open = ceph_open,
>  	.release = ceph_release,
> @@ -898,5 +1142,6 @@ const struct file_operations ceph_file_fops = {
>  	.splice_write = generic_file_splice_write,
>  	.unlocked_ioctl = ceph_ioctl,
>  	.compat_ioctl	= ceph_ioctl,
> +	.fallocate = ceph_fallocate,
>  };
>  
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 3a246a6..a6d9671 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -503,7 +503,8 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
>  	struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which, opcode);
>  	size_t payload_len = 0;
>  
> -	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE);
> +	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> +			opcode != CEPH_OSD_OP_DELETE && opcode != CEPH_OSD_OP_ZERO);
>  
>  	op->extent.offset = offset;
>  	op->extent.length = length;
> @@ -631,6 +632,8 @@ static u64 osd_req_encode_op(struct ceph_osd_request *req,
>  		break;
>  	case CEPH_OSD_OP_READ:
>  	case CEPH_OSD_OP_WRITE:
> +	case CEPH_OSD_OP_DELETE:
> +	case CEPH_OSD_OP_ZERO:
>  		if (src->op == CEPH_OSD_OP_WRITE)
>  			request_data_len = src->extent.length;
>  		dst->extent.offset = cpu_to_le64(src->extent.offset);
> @@ -715,7 +718,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
>  	u64 object_base;
>  	int r;
>  
> -	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE);
> +	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> +			opcode != CEPH_OSD_OP_DELETE && opcode != CEPH_OSD_OP_ZERO);
>  
>  	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
>  					GFP_NOFS);
> -- 
> 1.7.9.5
> 
> 
> 
