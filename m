Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaKLAVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:21:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaKLAVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:21:48 -0500
Date: Tue, 11 Nov 2014 16:21:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
Message-Id: <20141111162146.6e72c3fb0858df4945096c47@linux-foundation.org>
In-Reply-To: <fae396b9bc15.545c5b55@langara.bc.ca>
References: <fae396b9bc15.545c5b55@langara.bc.ca>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 05:40:37 +0000 (GMT) Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca> wrote:

> This shouldn't be too controversial. I simply looked for where there
> was a tiny bit of waste in the message queue code.
> 

It's probably better to do this as three or four separate patches.

> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -278,16 +278,29 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  		mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
>  					  info->attr.mq_msgsize);
>  
> -		spin_lock(&mq_lock);
> -		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
> -		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
> +		{
> +			bool too_many_open_files;

Well yes, that's what EMFILE means but "too_many_open_files" doesn't
make sense in this context!


> +			long msgqueue_lim;
> +			unsigned long u_bytes;
> +
> +			msgqueue_lim = rlimit(RLIMIT_MSGQUEUE);
> +
> +			spin_lock(&mq_lock);
> +
> +			u_bytes = u->mq_bytes;
> +			too_many_open_files = u_bytes + mq_bytes < u_bytes ||
> +				u_bytes + mq_bytes > msgqueue_lim;
> +			if (!too_many_open_files)

This test isn't really needed.

> +				u->mq_bytes += mq_bytes;
> +
>  			spin_unlock(&mq_lock);
> +
>  			/* mqueue_evict_inode() releases info->messages */
> -			ret = -EMFILE;
> -			goto out_inode;
> +			if (too_many_open_files) {
> +				ret = -EMFILE;
> +				goto out_inode;
> +			}
>  		}
> -		u->mq_bytes += mq_bytes;
> -		spin_unlock(&mq_lock);
>  
>  		/* all is ok */
>  		info->user = get_uid(u);
> @@ -423,44 +436,60 @@ static int mqueue_create(struct inode *dir, struct dentry
> *dentry,
>  				umode_t mode, bool excl)
>  {
>  	struct inode *inode;
> -	struct mq_attr *attr = dentry->d_fsdata;
> -	int error;
> +	struct mq_attr *attr;
>  	struct ipc_namespace *ipc_ns;
> +	int error = 0;
> +
> +	if (!capable(CAP_SYS_RESOURCE)) {
> +		error = -ENOSPC;
> +		goto finish;
> +	}

Thatsabug.  It only requires CAP_SYS_RESOURCE if we're trying with
queues_count >= queues_max.


