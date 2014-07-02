Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaGBGv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaGBGv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:51:56 -0400
Date: Wed, 2 Jul 2014 08:53:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Brian Lane <bcl@redhat.com>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH driver-core-linus] kernfs: kernfs_notify() must be
 useable from non-sleepable contexts
Message-ID: <20140702055339.GB3773@redhat.com>
References: <CA+5PVA4h2hQJLrAm4eEZ8oUgGiAjq2y5eAyBcJWxK_FiQXnuQg@mail.gmail.com>
 <20140629082637.GA23942@redhat.com>
 <20140629193222.GA7030@lst.de>
 <20140629204710.GB11100@redhat.com>
 <53B07D48.60003@kernel.dk>
 <20140630201741.GA20853@htj.dyndns.org>
 <20140701204103.GA12459@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701204103.GA12459@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 04:41:03PM -0400, Tejun Heo wrote:
> d911d9874801 ("kernfs: make kernfs_notify() trigger inotify events
> too") added fsnotify triggering to kernfs_notify() which requires a
> sleepable context.  There are already existing users of
> kernfs_notify() which invoke it from an atomic context and in general
> it's silly to require a sleepable context for triggering a
> notification.
> 
> The following is an invalid context bug triggerd by md invoking
> sysfs_notify() from IO completion path.
> 
>  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
>  in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/1
>  2 locks held by swapper/1/0:
>   #0:  (&(&vblk->vq_lock)->rlock){-.-...}, at: [<ffffffffa0039042>] virtblk_done+0x42/0xe0 [virtio_blk]
>   #1:  (&(&bitmap->counts.lock)->rlock){-.....}, at: [<ffffffff81633718>] bitmap_endwrite+0x68/0x240
>  irq event stamp: 33518
>  hardirqs last  enabled at (33515): [<ffffffff8102544f>] default_idle+0x1f/0x230
>  hardirqs last disabled at (33516): [<ffffffff818122ed>] common_interrupt+0x6d/0x72
>  softirqs last  enabled at (33518): [<ffffffff810a1272>] _local_bh_enable+0x22/0x50
>  softirqs last disabled at (33517): [<ffffffff810a29e0>] irq_enter+0x60/0x80
>  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.16.0-0.rc2.git2.1.fc21.x86_64 #1
>  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>   0000000000000000 f90db13964f4ee05 ffff88007d403b80 ffffffff81807b4c
>   0000000000000000 ffff88007d403ba8 ffffffff810d4f14 0000000000000000
>   0000000000441800 ffff880078fa1780 ffff88007d403c38 ffffffff8180caf2
>  Call Trace:
>   <IRQ>  [<ffffffff81807b4c>] dump_stack+0x4d/0x66
>   [<ffffffff810d4f14>] __might_sleep+0x184/0x240
>   [<ffffffff8180caf2>] mutex_lock_nested+0x42/0x440
>   [<ffffffff812d76a0>] kernfs_notify+0x90/0x150
>   [<ffffffff8163377c>] bitmap_endwrite+0xcc/0x240
>   [<ffffffffa00de863>] close_write+0x93/0xb0 [raid1]
>   [<ffffffffa00df029>] r1_bio_write_done+0x29/0x50 [raid1]
>   [<ffffffffa00e0474>] raid1_end_write_request+0xe4/0x260 [raid1]
>   [<ffffffff813acb8b>] bio_endio+0x6b/0xa0
>   [<ffffffff813b46c4>] blk_update_request+0x94/0x420
>   [<ffffffff813bf0ea>] blk_mq_end_io+0x1a/0x70
>   [<ffffffffa00392c2>] virtblk_request_done+0x32/0x80 [virtio_blk]
>   [<ffffffff813c0648>] __blk_mq_complete_request+0x88/0x120
>   [<ffffffff813c070a>] blk_mq_complete_request+0x2a/0x30
>   [<ffffffffa0039066>] virtblk_done+0x66/0xe0 [virtio_blk]
>   [<ffffffffa002535a>] vring_interrupt+0x3a/0xa0 [virtio_ring]
>   [<ffffffff81116177>] handle_irq_event_percpu+0x77/0x340
>   [<ffffffff8111647d>] handle_irq_event+0x3d/0x60
>   [<ffffffff81119436>] handle_edge_irq+0x66/0x130
>   [<ffffffff8101c3e4>] handle_irq+0x84/0x150
>   [<ffffffff818146ad>] do_IRQ+0x4d/0xe0
>   [<ffffffff818122f2>] common_interrupt+0x72/0x72
>   <EOI>  [<ffffffff8105f706>] ? native_safe_halt+0x6/0x10
>   [<ffffffff81025454>] default_idle+0x24/0x230
>   [<ffffffff81025f9f>] arch_cpu_idle+0xf/0x20
>   [<ffffffff810f5adc>] cpu_startup_entry+0x37c/0x7b0
>   [<ffffffff8104df1b>] start_secondary+0x25b/0x300
> 
> This patch fixes it by punting the notification delivery through a
> work item.  This ends up adding an extra pointer to kernfs_elem_attr
> enlarging kernfs_node by a pointer, which is not ideal but not a very
> big deal either.  If this turns out to be an actual issue, we can move
> kernfs_elem_attr->size to kernfs_node->iattr later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>

FWIW

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  fs/kernfs/file.c       |   69 +++++++++++++++++++++++++++++++++++++++----------
>  include/linux/kernfs.h |    1 
>  2 files changed, 56 insertions(+), 14 deletions(-)
> 
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -39,6 +39,19 @@ struct kernfs_open_node {
>  	struct list_head	files; /* goes through kernfs_open_file.list */
>  };
>  
> +/*
> + * kernfs_notify() may be called from any context and bounces notifications
> + * through a work item.  To minimize space overhead in kernfs_node, the
> + * pending queue is implemented as a singly linked list of kernfs_nodes.
> + * The list is terminated with the self pointer so that whether a
> + * kernfs_node is on the list or not can be determined by testing the next
> + * pointer for NULL.
> + */
> +#define KERNFS_NOTIFY_EOL			((void *)&kernfs_notify_list)
> +
> +static DEFINE_SPINLOCK(kernfs_notify_lock);
> +static struct kernfs_node *kernfs_notify_list = KERNFS_NOTIFY_EOL;
> +
>  static struct kernfs_open_file *kernfs_of(struct file *file)
>  {
>  	return ((struct seq_file *)file->private_data)->private;
> @@ -783,24 +796,25 @@ static unsigned int kernfs_fop_poll(stru
>  	return DEFAULT_POLLMASK|POLLERR|POLLPRI;
>  }
>  
> -/**
> - * kernfs_notify - notify a kernfs file
> - * @kn: file to notify
> - *
> - * Notify @kn such that poll(2) on @kn wakes up.
> - */
> -void kernfs_notify(struct kernfs_node *kn)
> +static void kernfs_notify_workfn(struct work_struct *work)
>  {
> -	struct kernfs_root *root = kernfs_root(kn);
> +	struct kernfs_node *kn;
>  	struct kernfs_open_node *on;
>  	struct kernfs_super_info *info;
> -	unsigned long flags;
> -
> -	if (WARN_ON(kernfs_type(kn) != KERNFS_FILE))
> +repeat:
> +	/* pop one off the notify_list */
> +	spin_lock_irq(&kernfs_notify_lock);
> +	kn = kernfs_notify_list;
> +	if (kn == KERNFS_NOTIFY_EOL) {
> +		spin_unlock_irq(&kernfs_notify_lock);
>  		return;
> +	}
> +	kernfs_notify_list = kn->attr.notify_next;
> +	kn->attr.notify_next = NULL;
> +	spin_unlock_irq(&kernfs_notify_lock);
>  
>  	/* kick poll */
> -	spin_lock_irqsave(&kernfs_open_node_lock, flags);
> +	spin_lock_irq(&kernfs_open_node_lock);
>  
>  	on = kn->attr.open;
>  	if (on) {
> @@ -808,12 +822,12 @@ void kernfs_notify(struct kernfs_node *k
>  		wake_up_interruptible(&on->poll);
>  	}
>  
> -	spin_unlock_irqrestore(&kernfs_open_node_lock, flags);
> +	spin_unlock_irq(&kernfs_open_node_lock);
>  
>  	/* kick fsnotify */
>  	mutex_lock(&kernfs_mutex);
>  
> -	list_for_each_entry(info, &root->supers, node) {
> +	list_for_each_entry(info, &kernfs_root(kn)->supers, node) {
>  		struct inode *inode;
>  		struct dentry *dentry;
>  
> @@ -833,6 +847,33 @@ void kernfs_notify(struct kernfs_node *k
>  	}
>  
>  	mutex_unlock(&kernfs_mutex);
> +	kernfs_put(kn);
> +	goto repeat;
> +}
> +
> +/**
> + * kernfs_notify - notify a kernfs file
> + * @kn: file to notify
> + *
> + * Notify @kn such that poll(2) on @kn wakes up.  Maybe be called from any
> + * context.
> + */
> +void kernfs_notify(struct kernfs_node *kn)
> +{
> +	static DECLARE_WORK(kernfs_notify_work, kernfs_notify_workfn);
> +	unsigned long flags;
> +
> +	if (WARN_ON(kernfs_type(kn) != KERNFS_FILE))
> +		return;
> +
> +	spin_lock_irqsave(&kernfs_notify_lock, flags);
> +	if (!kn->attr.notify_next) {
> +		kernfs_get(kn);
> +		kn->attr.notify_next = kernfs_notify_list;
> +		kernfs_notify_list = kn;
> +		schedule_work(&kernfs_notify_work);
> +	}
> +	spin_unlock_irqrestore(&kernfs_notify_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(kernfs_notify);
>  
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -91,6 +91,7 @@ struct kernfs_elem_attr {
>  	const struct kernfs_ops	*ops;
>  	struct kernfs_open_node	*open;
>  	loff_t			size;
> +	struct kernfs_node	*notify_next;	/* for kernfs_notify() */
>  };
>  
>  /*
