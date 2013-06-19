Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab3FSQbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:31:23 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52424 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3FSQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:31:21 -0400
Date: Wed, 19 Jun 2013 09:31:21 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Li Wang <liwang@ubuntukylin.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] Ceph: Punch hole support
In-Reply-To: <51C1DB17.6040803@ubuntukylin.com>
Message-ID: <alpine.DEB.2.00.1306190929350.27900@cobra.newdream.net>
References: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com> <1371224340-4926-1-git-send-email-liwang@ubuntukylin.com> <alpine.DEB.2.00.1306140902490.26467@cobra.newdream.net> <51C1DB17.6040803@ubuntukylin.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

There is a version of fsx.c floating around that tests hole punching... 
have you tried running that on top of this patch?  Ideally, we should 
build a test (ceph.git/qa/workunits/rbd/hole_punch.sh or similar) that 
tests the hole punch both with a default file layout and with a more 
complicated striping pattern (e.g. object_size=1048576 stripe_unit=65536 
stripe_count=7).

sage

On Thu, 20 Jun 2013, Li Wang wrote:

> This patch implements punch hole (fallocate) support for Ceph.
> 
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <wenyunchuan@ubuntukylin.com>
> ---
>  fs/ceph/file.c        |  313
> +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/ceph/osd_client.c |    8 +-
>  2 files changed, 319 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 656e169..578e5fd 100644
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
> @@ -882,6 +883,317 @@ out:
>  	return offset;
>  }
> 
> +static inline void ceph_zero_partial_page(struct inode *inode, pgoff_t index,
> unsigned start, unsigned size)
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
> +static void ceph_truncate_and_zero_page_cache(struct inode *inode, loff_t
> offset, loff_t length)
> +{
> +	loff_t first_page;
> +	loff_t last_page;
> +	loff_t zero_len;
> +
> +	first_page =((offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) <<
> PAGE_CACHE_SHIFT;
> +	last_page = ((offset + length) >> PAGE_CACHE_SHIFT) <<
> PAGE_CACHE_SHIFT;
> +	if (last_page > first_page) {
> +		truncate_pagecache_range(inode, first_page, last_page - 1);
> +	}
> +	if (first_page > last_page) {
> +		ceph_zero_partial_page(inode, offset >> PAGE_CACHE_SHIFT,
> offset & (PAGE_CACHE_SIZE - 1), length);
> +		return;
> +	}
> +	/*
> +	 * zero out the partial page that contains
> +	 * the start of the hole
> +	 */	
> +	zero_len  = first_page - offset;
> +	if (zero_len > 0) {
> +		ceph_zero_partial_page(inode, offset >> PAGE_CACHE_SHIFT,
> offset & (PAGE_CACHE_SIZE -1), zero_len);
> +	}
> +	/*
> +	 * zero out the partial page that contains
> +	 * the end of the hole
> +	 */
> +	zero_len = offset + length - last_page;
> +	if (zero_len > 0) {
> +		ceph_zero_partial_page(inode, (offset + length) >>
> PAGE_CACHE_SHIFT, 0, zero_len);
> +	}
> +	/*
> +	 * If i_size is contained in the last page, we need to
> +	 * zero the partial page after i_size
> +	 */
> +	if (inode->i_size >> PAGE_CACHE_SHIFT == (offset + length) >>
> PAGE_CACHE_SHIFT && inode->i_size % PAGE_CACHE_SIZE != 0) {
> +		zero_len = PAGE_CACHE_SIZE -
> +			(inode->i_size & (PAGE_CACHE_SIZE - 1));
> +		if (zero_len > 0) {
> +			ceph_zero_partial_page(inode, inode->i_size >>
> PAGE_CACHE_SHIFT, inode->i_size & (PAGE_CACHE_SIZE -1), zero_len);
> +		}
> +	}
> +}
> +
> +static inline __u32 ceph_calculate_shift(__s64 size)
> +{
> +	int shift;
> +	
> +	if (size <= 0)
> +		return -1;
> +	if (size == 1)
> +		return 0;
> +	for (shift = 0; ;shift++) {
> +		if (2 << shift == size)
> +			break;
> +	}
> +	shift++;
> +	
> +	return shift;
> +}
> +
> +static int ceph_delete_object(struct inode *inode, u64 offset, u64 *length)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +    struct ceph_fs_client *fsc = ceph_inode_to_client(inode);	
> +	struct ceph_osd_request *req;
> +	int ret = 0;
> +	
> +	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
> +                                    ceph_vino(inode), offset, length, 1,
> +                                    CEPH_OSD_OP_DELETE, CEPH_OSD_FLAG_ONDISK,
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
> +
> +	out:
> +	return ret;
> +}
> +
> +static int ceph_zero_partial_object(struct inode *inode, loff_t offset,
> loff_t *length)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_osd_request *req;
> +	int ret = 0;
> +	
> +	if (length <= 0)
> +		goto out;
> +
> +	
> +	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
> +                                    ceph_vino(inode), offset, length, 1,
> +                                    CEPH_OSD_OP_ZERO, CEPH_OSD_FLAG_WRITE |
> CEPH_OSD_FLAG_ONDISK,
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
> +
> +	out:
> +	return ret;
> +}
> +
> +static int ceph_zero_partial_object_set(struct inode *inode, loff_t start,
> loff_t end)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	__s32 stripe_unit_size = ceph_file_layout_su(ci->i_layout);	
> +	__u32 stripe_unit_shift = ceph_calculate_shift(stripe_unit_size);
> +	loff_t first_stripe_unit = ((start + stripe_unit_size -1 ) >>
> stripe_unit_shift) << stripe_unit_shift;
> +	loff_t last_stripe_unit = ((end + 1) >> stripe_unit_shift) <<
> stripe_unit_shift;
> +	u64 i;
> +	loff_t length;
> +	int ret = 0;
> +
> +	if (last_stripe_unit > first_stripe_unit) {
> +		for (i = first_stripe_unit; i < last_stripe_unit; i +=
> stripe_unit_size) {
> +			length = (u64) stripe_unit_size;
> +			ret = ceph_zero_partial_object(inode, i, &length);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +	if (first_stripe_unit > last_stripe_unit) {
> +			length = end - start + 1;			
> +			ret = ceph_zero_partial_object(inode, start, &length);
> +			goto out;
> +	}
> +	length = first_stripe_unit - start;
> +	if (length > 0) {			
> +		ret = ceph_zero_partial_object(inode, start, &length);
> +		if (ret)
> +			goto out;
> +	}
> +	length =  end - last_stripe_unit + 1;
> +	if (length > 0) {			
> +		ret = ceph_zero_partial_object(inode, last_stripe_unit,
> &length);
> +	}
> +
> +	out:
> +	return ret;
> +}
> +
> +static int ceph_delete_and_zero_objects(struct file *file, loff_t offset,
> loff_t length)
> +{
> +	struct ceph_file_info *fi = file->private_data;	
> +	struct inode *inode = file->f_dentry->d_inode;
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	__s32 stripe_unit_size = ceph_file_layout_su(ci->i_layout);
> +	__s32 stripe_count = ceph_file_layout_stripe_count(ci->i_layout);
> +	unsigned stripe_width = ceph_file_layout_stripe_width(&ci->i_layout);
> +	__s32 object_size = ceph_file_layout_object_size(ci->i_layout);
> +	__s32 object_set_size = object_size * stripe_count;
> +	__u32 object_set_shift = ceph_calculate_shift(object_set_size);
> +	__u32 stripe_unit_count_per_object = object_size / stripe_unit_size;
> +	loff_t first_object_set = ((offset + object_set_size - 1) >>
> object_set_shift) << object_set_shift;
> +	loff_t last_object_set = ((offset + length) >> object_set_shift) <<
> object_set_shift;
> +	loff_t i, j;	
> +	int want, got = 0;
> +	int dirty;
> +	u64 len;
> +	int ret = 0;
> +
> +	if (fi->fmode & CEPH_FILE_MODE_LAZY)
> +		want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
> +	else
> +		want = CEPH_CAP_FILE_BUFFER;
> +		
> +	ret = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, &got, offset +
> length);
> +	if (ret < 0)
> +		return ret;
> +	if (!(got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO))) {
> +		ret = -EAGAIN;
> +		goto out;
> +	}
> +
> +	/* [offset, offset+length] does not across object set bundary.
> +	  * Yes, there are possibilities to delete some objects within
> +	  * a object set, however, we want to keep it simple, not to incur
> +	  * comprehensive calculation, so for a partial hole within a object
> +	  * set, we zero only
> +	  */
> +	if (first_object_set > last_object_set) {
> +		ret = ceph_zero_partial_object_set(inode, offset, offset +
> length - 1);
> +		goto out;
> +	}
> +	/* [offset, offset+length] contains at least one complete object set
> */
> +	if (last_object_set > first_object_set) {		
> +		len = (u64)stripe_unit_size;
> +		/*
> +		  * For the very first object, zero it instead of deleting it,
> +		  * since there are attached metada on it
> +		  */
> +		if (first_object_set == 0) {
> +			for (i = 0; i < stripe_unit_count_per_object; i++) {
> +				ret = ceph_zero_partial_object(inode,
> first_object_set + i*stripe_width, &len);
> +				if (ret)
> +					goto out;
> +			}
> +		}
> +		for (i = first_object_set; i < last_object_set; i +=
> object_set_size) {
> +			for (j = i; j < i + stripe_width; j +=
> stripe_unit_size) {
> +				/* skip the very first object */
> +				if (j == 0)
> +					continue;
> +				ret = ceph_delete_object(inode, j, &len);
> +				/* object already deleted */
> +				if (ret == -ENOENT)
> +					ret = 0;
> +				if (ret)
> +					goto out;
> +			}
> +		}
> +	}
> +
> +	/* deal with the object set contains the start or the end of the hole
> */
> +	if (first_object_set - offset > 0) {
> +		ret = ceph_zero_partial_object_set(inode, offset,
> first_object_set - 1);
> +		if (ret)
> +			goto out;
> +	}
> +	if (offset + length - last_object_set > 0) {
> +		ret = ceph_zero_partial_object_set(inode, last_object_set,
> offset + length - 1);
> +	}
> +	
> +	out:
> +	if (ret == 0) {
> +		spin_lock(&ci->i_ceph_lock);
> +		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR);
> +		spin_unlock(&ci->i_ceph_lock);
> +		if (dirty)
> +			__mark_inode_dirty(inode, dirty);
> +	}
> +	ceph_put_cap_refs(ci, got);
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
> +
> +	ceph_truncate_and_zero_page_cache(inode, offset, length);
> +	ret = ceph_delete_and_zero_objects(file, offset, length);
> +	
> +	out_unlock:
> +	mutex_unlock(&inode->i_mutex);
> +	return ret;
> +}
> +
> +static long ceph_fallocate(struct file *file, int mode, loff_t offset, loff_t
> length)
> +{
> +	/* FALLOC_FL_PUNCH_HOLE must be used with FALLOC_FL_KEEP_SIZE */
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
> @@ -898,5 +1210,6 @@ const struct file_operations ceph_file_fops = {
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
> @@ -503,7 +503,8 @@ void osd_req_op_extent_init(struct ceph_osd_request
> *osd_req,
>  	struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which, opcode);
>  	size_t payload_len = 0;
> 
> -	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE);
> +	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> +			opcode != CEPH_OSD_OP_DELETE && opcode !=
> CEPH_OSD_OP_ZERO);
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
> @@ -715,7 +718,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct
> ceph_osd_client *osdc,
>  	u64 object_base;
>  	int r;
> 
> -	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE);
> +	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> +			opcode != CEPH_OSD_OP_DELETE && opcode !=
> CEPH_OSD_OP_ZERO);
> 
>  	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
>  					GFP_NOFS);
> -- 
> 1.7.9.5
> 
> 
> 
