Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3GBQtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:49:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:51220 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3GBQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:49:18 -0400
Date: Tue, 2 Jul 2013 09:49:18 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: majianpeng <majianpeng@gmail.com>
cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ceph: update atime after read-operation.
In-Reply-To: <201307021345043628495@gmail.com>
Message-ID: <alpine.DEB.2.00.1307020948330.1067@cobra.newdream.net>
References: <201307021345043628495@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, majianpeng wrote:
> Now ceph don't support updating atime after read-operation if the open
> mode is CEPH_CAP_FILE_RD.There are two reasons:
> 1:in client of fs,it don't set dirty cap of CEPH_CAP_FILE_RD.
> 2:in mds,it only update the atime if the condition
> "dirty & (CEPH_CAP_FILE_EXCL|CEPH_CAP_FILE_WR) is true.
> But if we can read, we can update atime. This patch only modify client to
> support.

Do we awnt to update atime if ret == 0?

Otherwise looks good.  Please make the changelog only describe the kernel 
change (in this patch) and not the MDS changes.

sage

> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/ceph/file.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 87df15a..9daea70 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -672,6 +672,15 @@ again:
>  out:
>  	dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
>  	     inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
> +
> +	if (ret >= 0) {
> +		int dirty;
> +		spin_lock(&ci->i_ceph_lock);
> +		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_RD);
> +		spin_unlock(&ci->i_ceph_lock);
> +		if (dirty)
> +			__mark_inode_dirty(inode, dirty);
> +	}
>  	ceph_put_cap_refs(ci, got);
>  
>  	if (checkeof && ret >= 0) {
> -- 
> 1.8.1.2
> 
