Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaKTKnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:43:00 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38039 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaKTKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:42:57 -0500
Message-ID: <546DC5AD.3040606@plexistor.com>
Date: Thu, 20 Nov 2014 12:42:53 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
References: <20141113220927.GF2598@htj.dyndns.org> <20141113221139.GG2598@htj.dyndns.org>
In-Reply-To: <20141113221139.GG2598@htj.dyndns.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 12:11 AM, Tejun Heo wrote:
> inode->i_devices is a list_head used to link device inodes to the
> corresponding block_device or cdev.  This patch makes block_device and
> cdev usfe ptrset to keep track of the inodes instead of linking
> inode->i_devices allowing removal of the field and thus reduction of
> struct inode by two pointers.
> 
> The conversion is staright-forward.  list_add() is replaced with
> preloaded ptrset_add(), list_del_init() with ptrset_del(), and list
> iteration with ptrset_for_each().  The only part which isn't direct
> one-to-one mapping is the error handling after ptrset_add() failure.
> 
> The saved two pointers will be used by cgroup writback support.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  fs/block_dev.c       |   39 +++++++++++++++++++++++----------------
>  fs/char_dev.c        |   25 +++++++++++++++----------
>  fs/inode.c           |    1 -
>  include/linux/cdev.h |    4 ++--
>  include/linux/fs.h   |    4 ++--
>  5 files changed, 42 insertions(+), 31 deletions(-)
> 
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -458,7 +458,7 @@ static void init_once(void *foo)
>  
>  	memset(bdev, 0, sizeof(*bdev));
>  	mutex_init(&bdev->bd_mutex);
> -	INIT_LIST_HEAD(&bdev->bd_inodes);
> +	ptrset_init(&bdev->bd_inodes);
>  	INIT_LIST_HEAD(&bdev->bd_list);
>  #ifdef CONFIG_SYSFS
>  	INIT_LIST_HEAD(&bdev->bd_holder_disks);
> @@ -470,7 +470,7 @@ static void init_once(void *foo)
>  
>  static inline void __bd_forget(struct inode *inode)
>  {
> -	list_del_init(&inode->i_devices);
> +	ptrset_del(inode, &inode->i_bdev->bd_inodes);
>  	inode->i_bdev = NULL;
>  	inode->i_mapping = &inode->i_data;
>  }
> @@ -478,14 +478,15 @@ static inline void __bd_forget(struct in
>  static void bdev_evict_inode(struct inode *inode)
>  {
>  	struct block_device *bdev = &BDEV_I(inode)->bdev;
> -	struct list_head *p;
> +	struct ptrset_iter iter;
> +	struct inode *bd_inode;
> +
>  	truncate_inode_pages_final(&inode->i_data);
>  	invalidate_inode_buffers(inode); /* is it needed here? */
>  	clear_inode(inode);
>  	spin_lock(&bdev_lock);
> -	while ( (p = bdev->bd_inodes.next) != &bdev->bd_inodes ) {
> -		__bd_forget(list_entry(p, struct inode, i_devices));
> -	}
> +	ptrset_for_each(bd_inode, &bdev->bd_inodes, &iter)
> +		__bd_forget(bd_inode);
>  	list_del_init(&bdev->bd_list);
>  	spin_unlock(&bdev_lock);
>  }
> @@ -634,20 +635,26 @@ static struct block_device *bd_acquire(s
>  
>  	bdev = bdget(inode->i_rdev);
>  	if (bdev) {
> +		ptrset_preload(GFP_KERNEL);

if I understand correctly the motivation here is that the allocation
of the internal element is done GFP_KERNEL at this call

Then the add() below can be under the spin_lock.

So why don't you just return an element here to caller and give it to
add below. No Preemption-disable, no percpu variable, simple. Like:
	struct ptrset_elem *new = ptrset_preload(GFP_KERNEL);

	then 
	if (!new)
		just fail here just as you faild below with ptrset_add()
>  		spin_lock(&bdev_lock);

lock taken
>  		if (!inode->i_bdev) {
> -			/*
> -			 * We take an additional reference to bd_inode,
> -			 * and it's released in clear_inode() of inode.
> -			 * So, we can access it via ->i_mapping always
> -			 * without igrab().
> -			 */
> -			ihold(bdev->bd_inode);
> -			inode->i_bdev = bdev;
> -			inode->i_mapping = bdev->bd_inode->i_mapping;
> -			list_add(&inode->i_devices, &bdev->bd_inodes);
> +			if (!ptrset_add(inode, &bdev->bd_inodes, GFP_NOWAIT)) {

			ptrset_add(inode, &bdev->bd_inodes, new);

Here ptrset_add cannot fail and can just be void return.
(If element exist then "new" is freed inside here. After add() "new" is owned
 by the pset)

> +				/*
> +				 * We take an additional reference to bd_inode,
> +				 * and it's released in clear_inode() of inode.
> +				 * So, we can access it via ->i_mapping always
> +				 * without igrab().
> +				 */
> +				ihold(bdev->bd_inode);
> +				inode->i_bdev = bdev;
> +				inode->i_mapping = bdev->bd_inode->i_mapping;
> +			} else {

This else is of the if(!new) above if need the spinlock then fine lock for this too.

> +				bdput(bdev);
> +				bdev = NULL;
> +			}
>  		}
>  		spin_unlock(&bdev_lock);
> +		ptrset_preload_end();

This one not needed anymore

>  	}
>  	return bdev;
>  }
> --- a/fs/char_dev.c
> +++ b/fs/char_dev.c
> @@ -383,16 +383,20 @@ static int chrdev_open(struct inode *ino
>  		if (!kobj)
>  			return -ENXIO;
>  		new = container_of(kobj, struct cdev, kobj);
> +		ptrset_preload(GFP_KERNEL);

Same exact thing here 

>  		spin_lock(&cdev_lock);
>  		/* Check i_cdev again in case somebody beat us to it while
>  		   we dropped the lock. */
>  		p = inode->i_cdev;
>  		if (!p) {
> -			inode->i_cdev = p = new;
> -			list_add(&inode->i_devices, &p->list);
> -			new = NULL;
> +			ret = ptrset_add(inode, &new->inodes, GFP_NOWAIT);
> +			if (!ret) {
> +				inode->i_cdev = p = new;
> +				new = NULL;
> +			}
>  		} else if (!cdev_get(p))
>  			ret = -ENXIO;
> +		ptrset_preload_end();
>  	} else if (!cdev_get(p))
>  		ret = -ENXIO;
>  	spin_unlock(&cdev_lock);
<>

Am I totally missing something? It looks like you want to make sure you
allocate-with-wait an element before hand, if needed, usually you do, before
you take spin-locks. Is there some other reasons that I do not see?

Thanks
Boaz

