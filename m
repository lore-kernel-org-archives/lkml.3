Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbbAHJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:25:26 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57842 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbAHJZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:25:23 -0500
Date: Thu, 8 Jan 2015 01:25:19 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] nfs: don't dirty ITER_BVEC pages read through
 direct I/O
Message-ID: <20150108092519.GA2673@mew>
References: <cover.1419044605.git.osandov@osandov.com>
 <b42b9a61d22260ee44b312d0119f1856e8f5840d.1419044605.git.osandov@osandov.com>
 <54AAA27C.6040906@Netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AAA27C.6040906@Netapp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 09:41:00AM -0500, Anna Schumaker wrote:
> Hi Omar,
> 
> On 12/19/2014 10:18 PM, Omar Sandoval wrote:
> > As with the generic blockdev code, kernel pages shouldn't be dirtied by
> > the direct I/O path.
> > 
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> >  fs/nfs/direct.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> > index 10bf072..b6ca65c 100644
> > --- a/fs/nfs/direct.c
> > +++ b/fs/nfs/direct.c
> > @@ -88,6 +88,7 @@ struct nfs_direct_req {
> >  	struct pnfs_ds_commit_info ds_cinfo;	/* Storage for cinfo */
> >  	struct work_struct	work;
> >  	int			flags;
> > +	int			should_dirty;	/* should we mark read pages dirty? */
> >  #define NFS_ODIRECT_DO_COMMIT		(1)	/* an unstable reply was received */
> >  #define NFS_ODIRECT_RESCHED_WRITES	(2)	/* write verification failed */
> >  	struct nfs_writeverf	verf;		/* unstable write verifier */
> 
> Can you add should_dirty after the NFS_ODIRECT_* flags?
> 
> Thanks,
> Anna
> 
> > @@ -370,7 +371,8 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
> >  		struct nfs_page *req = nfs_list_entry(hdr->pages.next);
> >  		struct page *page = req->wb_page;
> >  
> > -		if (!PageCompound(page) && bytes < hdr->good_bytes)
> > +		if (!PageCompound(page) && bytes < hdr->good_bytes &&
> > +		    dreq->should_dirty)
> >  			set_page_dirty(page);
> >  		bytes += req->wb_bytes;
> >  		nfs_list_remove_request(req);
> > @@ -542,6 +544,7 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
> >  	dreq->inode = inode;
> >  	dreq->bytes_left = count;
> >  	dreq->ctx = get_nfs_open_context(nfs_file_open_context(iocb->ki_filp));
> > +	dreq->should_dirty = !iov_iter_is_bvec(iter);
> >  	l_ctx = nfs_get_lock_context(dreq->ctx);
> >  	if (IS_ERR(l_ctx)) {
> >  		result = PTR_ERR(l_ctx);
> > 
> 

Thanks, Anna, I'll fix that.

-- 
Omar
