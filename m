Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab3BMPbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:31:06 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:62216 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759726Ab3BMPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:31:04 -0500
Message-ID: <511BB198.1080609@redhat.com>
Date: Wed, 13 Feb 2013 16:30:32 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Ben Myers <bpm@sgi.com>, CAI Qian <caiqian@redhat.com>
Subject: Re: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the filesystem
 end
References: <20130201130207.444989281@linuxfoundation.org> <20130201130212.381996681@linuxfoundation.org>
In-Reply-To: <20130201130212.381996681@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/02/2013 14:08, Greg Kroah-Hartman ha scritto:
> 3.7-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit eb178619f930fa2ba2348de332a1ff1c66a31424 upstream.
> 
> When _xfs_buf_find is passed an out of range address, it will fail
> to find a relevant struct xfs_perag and oops with a null
> dereference. This can happen when trying to walk a filesystem with a
> metadata inode that has a partially corrupted extent map (i.e. the
> block number returned is corrupt, but is otherwise intact) and we
> try to read from the corrupted block address.
> 
> In this case, just fail the lookup. If it is readahead being issued,
> it will simply not be done, but if it is real read that fails we
> will get an error being reported.  Ideally this case should result
> in an EFSCORRUPTED error being reported, but we cannot return an
> error through xfs_buf_read() or xfs_buf_get() so this lookup failure
> may result in ENOMEM or EIO errors being reported instead.

It looks like this breaks xfs_growfs.  See
http://bugzilla.redhat.com/show_bug.cgi?id=909602.

Paolo

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Ben Myers <bpm@sgi.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>
> Cc: CAI Qian <caiqian@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  fs/xfs/xfs_buf.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -487,6 +487,7 @@ _xfs_buf_find(
>  	struct rb_node		*parent;
>  	xfs_buf_t		*bp;
>  	xfs_daddr_t		blkno = map[0].bm_bn;
> +	xfs_daddr_t		eofs;
>  	int			numblks = 0;
>  	int			i;
>  
> @@ -498,6 +499,23 @@ _xfs_buf_find(
>  	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
>  	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
>  
> +	/*
> +	 * Corrupted block numbers can get through to here, unfortunately, so we
> +	 * have to check that the buffer falls within the filesystem bounds.
> +	 */
> +	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> +	if (blkno >= eofs) {
> +		/*
> +		 * XXX (dgc): we should really be returning EFSCORRUPTED here,
> +		 * but none of the higher level infrastructure supports
> +		 * returning a specific error on buffer lookup failures.
> +		 */
> +		xfs_alert(btp->bt_mount,
> +			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
> +			  __func__, blkno, eofs);
> +		return NULL;
> +	}
> +
>  	/* get tree root */
>  	pag = xfs_perag_get(btp->bt_mount,
>  				xfs_daddr_to_agno(btp->bt_mount, blkno));
> 
> 

