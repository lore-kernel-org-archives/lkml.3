Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3JCN2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:28:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:45282 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3JCN2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:28:33 -0400
Message-ID: <524D70FE.5000701@parallels.com>
Date: Thu, 3 Oct 2013 17:28:30 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.sourceforge.net>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] fuse: writepages: crop secondary requests
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru> <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru> <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 01:57 PM, Miklos Szeredi wrote:
> On Wed, Oct 02, 2013 at 09:38:32PM +0400, Maxim Patlasov wrote:
>> If writeback happens while fuse is in FUSE_NOWRITE condition, the request
>> will be queued but not processed immediately (see fuse_flush_writepages()).
>> Until FUSE_NOWRITE becomes relaxed, more writebacks can happen. They will
>> be queued as "secondary" requests to that first ("primary") request.
>>
>> Existing implementation crops only primary request. This is not correct
>> because a subsequent extending write(2) may increase i_size and then secondary
>> requests won't be cropped properly. The result would be stale data written to
>> the server to a file offset where zeros must be.
>>
>> Similar problem may happen if secondary requests are attached to an in-flight
>> request that was already cropped.
>>
>> The patch solves the issue by cropping all secondary requests in
>> fuse_writepage_end(). Thanks to Miklos for idea.
> How about this, even simpler, one?

Very cute, but unfortunately it has a flaw. See please inline comment below.

>
> Thanks,
> Miklos
>
>
> Index: linux/fs/fuse/file.c
> ===================================================================
> --- linux.orig/fs/fuse/file.c	2013-10-03 11:27:00.597084704 +0200
> +++ linux/fs/fuse/file.c	2013-10-03 11:53:30.477208467 +0200
> @@ -1436,12 +1436,12 @@ static void fuse_writepage_finish(struct
>   }
>   
>   /* Called under fc->lock, may release and reacquire it */
> -static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
> +static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req,
> +				loff_t size)
>   __releases(fc->lock)
>   __acquires(fc->lock)
>   {
>   	struct fuse_inode *fi = get_fuse_inode(req->inode);
> -	loff_t size = i_size_read(req->inode);
>   	struct fuse_write_in *inarg = &req->misc.write.in;
>   	__u64 data_size = req->num_pages * PAGE_CACHE_SIZE;
>   
> @@ -1476,7 +1476,7 @@ __acquires(fc->lock)
>    *
>    * Called with fc->lock
>    */
> -void fuse_flush_writepages(struct inode *inode)
> +void __fuse_flush_writepages(struct inode *inode, loff_t crop)
>   __releases(fc->lock)
>   __acquires(fc->lock)
>   {
> @@ -1487,9 +1487,15 @@ __acquires(fc->lock)
>   	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {
>   		req = list_entry(fi->queued_writes.next, struct fuse_req, list);
>   		list_del_init(&req->list);
> -		fuse_send_writepage(fc, req);
> +		fuse_send_writepage(fc, req, crop);
>   	}
>   }
> +void fuse_flush_writepages(struct inode *inode)
> +__releases(fc->lock)
> +__acquires(fc->lock)
> +{
> +	__fuse_flush_writepages(inode, i_size_read(inode));
> +}
>   
>   static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
>   {
> @@ -1499,12 +1505,13 @@ static void fuse_writepage_end(struct fu
>   	mapping_set_error(inode->i_mapping, req->out.h.error);
>   	spin_lock(&fc->lock);
>   	while (req->misc.write.next) {
> +		struct fuse_write_in *inarg = &req->misc.write.in;
>   		struct fuse_req *next = req->misc.write.next;
>   		req->misc.write.next = next->misc.write.next;
>   		next->misc.write.next = NULL;
>   		list_add(&next->writepages_entry, &fi->writepages);
>   		list_add_tail(&next->list, &fi->queued_writes);
> -		fuse_flush_writepages(inode);
> +		__fuse_flush_writepages(inode, inarg->offset + inarg->size);

__fuse_flush_writepages() will ignore its 'crop' arg if fi->writectr is 
below zero. This can easily happen if a request is finalized after 
fuse_set_nowrite(). So in a scenario like this:

1. There is an in-flight primary request with a chain of secondary ones.
2. User calls ftruncate(2) to extend file; fuse_set_nowrite() makes 
fi->writectr negative and starts waiting for completion of that 
in-flight request
3. Userspace fuse daemon ACKs the request and fuse_writepage_end() is 
called; it calls __fuse_flush_writepages(), but the latter does nothing 
because fi->writectr < 0
4. fuse_do_setattr() proceeds extending i_size and calling 
__fuse_release_nowrite(). But now new (increased) i_size will be used as 
'crop' arg of __fuse_flush_writepages()

stale data can leak to the server.

Thanks,
Maxim
