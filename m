Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaHEH2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:28:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaHEH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:28:29 -0400
Date: Tue, 5 Aug 2014 09:28:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: Re: [RFC][PATCH 4/7] inotify: Deal with nested sleeps
Message-ID: <20140805072813.GW3935@laptop>
References: <20140804103025.478913141@infradead.org>
 <20140804103537.564978189@infradead.org>
 <53E03FD3.5050705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E03FD3.5050705@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 10:22:11AM +0800, Lai Jiangshan wrote:
> I don't think this one needs nested sleeps.
> 
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index cc423a3..1ca5888 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -233,15 +233,16 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
>  	group = file->private_data;
>  
>  	while (1) {
> +		mutex_lock(&group->notification_mutex);
>  		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
>  
> -		mutex_lock(&group->notification_mutex);
>  		kevent = get_one_event(group, count);
>  		mutex_unlock(&group->notification_mutex);
>  
>  		pr_debug("%s: group=%p kevent=%p\n", __func__, group, kevent);
>  
>  		if (kevent) {
> +			__set_current_state(TASK_RUNNING);
>  			ret = PTR_ERR(kevent);
>  			if (IS_ERR(kevent))
>  				break;

Yeah, that'll probably work, but I'm not sure this the place to be
creative like that though. But whatever the inotify people prefer
really.
