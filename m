Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3JCKZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:25:35 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:60025 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3JCKZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:25:32 -0400
Date: Thu, 3 Oct 2013 12:26:14 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fuse: writepage: update bdi writeout when deleting
 secondary request
Message-ID: <20131003102614.GC14242@tucsk.piliscsaba.szeredi.hu>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
 <20131002173837.31188.34247.stgit@dhcp-10-30-17-2.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002173837.31188.34247.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 09:38:43PM +0400, Maxim Patlasov wrote:
> BDI_WRITTEN counter is used to estimate bdi bandwidth. It must be incremented
> every time as bdi ends page writeback. No matter whether it was fulfilled by
> actual write or by discarding the request (e.g. due to shrunk i_size).
> 
> Note that even before writepages patches, the case "Got truncated off
> completely" was handled in fuse_send_writepage() by calling
> fuse_writepage_finish() which updated BDI_WRITTEN unconditionally.

Hmm, I'm not sure I can agree with this.  If BDI_WRITTEN is used for bandwidth
estimation, then I think it's more correct not to count rewrites and truncated
pages.

But I don't see this matter either way since this is just used as a heuristic
and the occasional extra or lack of count shouldn't make a significant
difference.

Thanks,
Miklos

> 
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> ---
>  fs/fuse/file.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index a3c7123..5d323bd 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1536,6 +1536,7 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
>  			drop->inode->i_mapping->backing_dev_info;
>  		dec_bdi_stat(bdi, BDI_WRITEBACK);
>  		dec_zone_page_state(drop->pages[0], NR_WRITEBACK_TEMP);
> +		bdi_writeout_inc(bdi);
>  		fuse_writepage_free(fc, drop);
>  		fuse_put_request(fc, drop);
>  		drop = next;
> @@ -1706,11 +1707,14 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
>  
>  	if (old_req->num_pages == 1 && (old_req->state == FUSE_REQ_INIT ||
>  					old_req->state == FUSE_REQ_PENDING)) {
> +		struct backing_dev_info *bdi = page->mapping->backing_dev_info;
> +
>  		copy_highpage(old_req->pages[0], page);
>  		spin_unlock(&fc->lock);
>  
> -		dec_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
> +		dec_bdi_stat(bdi, BDI_WRITEBACK);
>  		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
> +		bdi_writeout_inc(bdi);
>  		fuse_writepage_free(fc, new_req);
>  		fuse_request_free(new_req);
>  		goto out;
> 
