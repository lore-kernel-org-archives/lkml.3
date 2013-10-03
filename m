Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3JCPux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:50:53 -0400
Received: from relay.parallels.com ([195.214.232.42]:44096 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3JCPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:50:52 -0400
Message-ID: <524D925A.8050402@parallels.com>
Date: Thu, 3 Oct 2013 19:50:50 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.sourceforge.net>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] fuse: writepages: crop secondary requests
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru> <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru> <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu> <524D70FE.5000701@parallels.com> <20131003151432.GE14242@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20131003151432.GE14242@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 07:14 PM, Miklos Szeredi wrote:
> On Thu, Oct 03, 2013 at 05:28:30PM +0400, Maxim Patlasov wrote:
>
>> 1. There is an in-flight primary request with a chain of secondary ones.
>> 2. User calls ftruncate(2) to extend file; fuse_set_nowrite() makes
>> fi->writectr negative and starts waiting for completion of that
>> in-flight request
>> 3. Userspace fuse daemon ACKs the request and fuse_writepage_end()
>> is called; it calls __fuse_flush_writepages(), but the latter does
>> nothing because fi->writectr < 0
>> 4. fuse_do_setattr() proceeds extending i_size and calling
>> __fuse_release_nowrite(). But now new (increased) i_size will be
>> used as 'crop' arg of __fuse_flush_writepages()
>>
>> stale data can leak to the server.
> So, lets do this then: skip fuse_flush_writepages() and call
> fuse_send_writepage() directly.  It will ignore the NOWRITE logic, but that's
> okay, this happens rarely and cannot happen more than once in a row.
>
> Does this look good?

Yes, but let's at least add a comment explaining why it's safe. There 
are three different cases and what you write above explains only one of 
them:

1st case (trivial): there are no concurrent activities using 
fuse_set/release_nowrite. Then we're on safe side because 
fuse_flush_writepages() would call fuse_send_writepage() anyway.
2nd case: someone called fuse_set_nowrite and it is waiting now for 
completion of all in-flight requests. Here what you wrote about 
"happening rarely and no more than once" is applicable.
3rd case: someone (e.g. fuse_do_setattr()) is in the middle of 
fuse_set_nowrite..fuse_release_nowrite section. The fact that 
fuse_set_nowrite returned implies that all in-flight requests were 
completed along with all its secondary requests (because we increment 
writectr for a secondry before decrementing it for the primary -- that's 
how fuse_writepage_end is implemeted). Further requests are blocked by 
negative writectr. Hence there cannot be any in-flight requests and no 
invocations of fuse_writepage_end while we're in 
fuse_set_nowrite..fuse_release_nowrite section.

It looks obvious now, but I'm not sure we'll able to recollect it later.

>
> Can you actually trigger this path with your testing?

No.

Thanks,
Maxim

>
> Thanks,
> Miklos
>
>
> Index: linux/fs/fuse/file.c
> ===================================================================
> --- linux.orig/fs/fuse/file.c	2013-10-03 12:12:33.480918954 +0200
> +++ linux/fs/fuse/file.c	2013-10-03 17:06:23.702510854 +0200
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
> @@ -1482,12 +1482,13 @@ __acquires(fc->lock)
>   {
>   	struct fuse_conn *fc = get_fuse_conn(inode);
>   	struct fuse_inode *fi = get_fuse_inode(inode);
> +	size_t crop = i_size_read(inode);
>   	struct fuse_req *req;
>   
>   	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {
>   		req = list_entry(fi->queued_writes.next, struct fuse_req, list);
>   		list_del_init(&req->list);
> -		fuse_send_writepage(fc, req);
> +		fuse_send_writepage(fc, req, crop);
>   	}
>   }
>   
> @@ -1499,12 +1500,13 @@ static void fuse_writepage_end(struct fu
>   	mapping_set_error(inode->i_mapping, req->out.h.error);
>   	spin_lock(&fc->lock);
>   	while (req->misc.write.next) {
> +		struct fuse_conn *fc = get_fuse_conn(inode);
> +		struct fuse_write_in *inarg = &req->misc.write.in;
>   		struct fuse_req *next = req->misc.write.next;
>   		req->misc.write.next = next->misc.write.next;
>   		next->misc.write.next = NULL;
>   		list_add(&next->writepages_entry, &fi->writepages);
> -		list_add_tail(&next->list, &fi->queued_writes);
> -		fuse_flush_writepages(inode);
> +		fuse_send_writepage(fc, next, inarg->offset + inarg->size);
>   	}
>   	fi->writectr--;
>   	fuse_writepage_finish(fc, req);
>
>

