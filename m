Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3ITIGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:06:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:57304 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3ITIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:06:13 -0400
Message-ID: <523C01F2.40006@parallels.com>
Date: Fri, 20 Sep 2013 12:06:10 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/3] fuse: fixes for writepages
References: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

On 09/19/2013 08:11 PM, Miklos Szeredi wrote:
> Maxim,
>
> Please review and test these.  I've appended them to writepages.v2 and for-next.

Thanks a lot for efforts. I'll start to work on it now and send you 
feedback as soon as I get a progress.

Btw, adding fuse-devel to cc.

Thanks,
Maxim

>
> Here's a test patch for the rewrites stuff.  It simply disables the waiting in
> fuse_page_mkwrite() and is quite effective in generating rewrites in my
> testcase.
>
> Thanks,
> Miklos
>
> ---
>   fs/fuse/file.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1498,6 +1498,7 @@ static void fuse_writepage_end(struct fu
>   
>   	mapping_set_error(inode->i_mapping, req->out.h.error);
>   	spin_lock(&fc->lock);
> +	int count = 0;
>   	while (req->misc.write.next) {
>   		struct fuse_req *next = req->misc.write.next;
>   		req->misc.write.next = next->misc.write.next;
> @@ -1505,7 +1506,10 @@ static void fuse_writepage_end(struct fu
>   		list_add(&next->writepages_entry, &fi->writepages);
>   		list_add_tail(&next->list, &fi->queued_writes);
>   		fuse_flush_writepages(inode);
> +		count++;
>   	}
> +	if (count)
> +		printk("rewrite: %i\n", count);
>   	fi->writectr--;
>   	fuse_writepage_finish(fc, req);
>   	spin_unlock(&fc->lock);
> @@ -1884,7 +1888,7 @@ static int fuse_page_mkwrite(struct vm_a
>   		return VM_FAULT_NOPAGE;
>   	}
>   
> -	fuse_wait_on_page_writeback(inode, page->index);
> +	//fuse_wait_on_page_writeback(inode, page->index);
>   	return VM_FAULT_LOCKED;
>   }
>   
>
>
>

