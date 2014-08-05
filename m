Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaHECUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:20:53 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23843 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723AbaHECUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:20:52 -0400
X-IronPort-AV: E=Sophos;i="5.04,266,1406563200"; 
   d="scan'208";a="34183056"
Message-ID: <53E03FD3.5050705@cn.fujitsu.com>
Date: Tue, 5 Aug 2014 10:22:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@kernel.org>, <oleg@redhat.com>, <torvalds@linux-foundation.org>,
        <tglx@linutronix.de>, <ilya.dryomov@inktank.com>,
        <umgwanakikbuti@gmail.com>, <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: Re: [RFC][PATCH 4/7] inotify: Deal with nested sleeps
References: <20140804103025.478913141@infradead.org> <20140804103537.564978189@infradead.org>
In-Reply-To: <20140804103537.564978189@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this one needs nested sleeps.

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index cc423a3..1ca5888 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -233,15 +233,16 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 	group = file->private_data;
 
 	while (1) {
+		mutex_lock(&group->notification_mutex);
 		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
 
-		mutex_lock(&group->notification_mutex);
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
 
 		pr_debug("%s: group=%p kevent=%p\n", __func__, group, kevent);
 
 		if (kevent) {
+			__set_current_state(TASK_RUNNING);
 			ret = PTR_ERR(kevent);
 			if (IS_ERR(kevent))
 				break;



On 08/04/2014 06:30 PM, Peter Zijlstra wrote:
> inotify_read is a wait loop with sleeps in. Wait loops rely on
> task_struct::state and sleeps do too, since that's the only means of
> actually sleeping. Therefore the nested sleeps destroy the wait loop
> state and the wait loop breaks the sleep functions that assume
> TASK_RUNNING (mutex_lock).
> 
> Fix this by using the new woken_wake_function and wait_woken() stuff,
> which registers wakeups in wait and thereby allows shrinking the
> task_state::state changes to the actual sleep part.
> 
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: John McCutchan <john@johnmccutchan.com>
> Cc: Robert Love <rlove@rlove.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  fs/notify/inotify/inotify_user.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -227,14 +227,13 @@ static ssize_t inotify_read(struct file
>  	struct fsnotify_event *kevent;
>  	char __user *start;
>  	int ret;
> -	DEFINE_WAIT(wait);
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  
>  	start = buf;
>  	group = file->private_data;
>  
> +	add_wait_queue(&group->notification_waitq, &wait);
>  	while (1) {
> -		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
> -
>  		mutex_lock(&group->notification_mutex);
>  		kevent = get_one_event(group, count);
>  		mutex_unlock(&group->notification_mutex);
> @@ -264,10 +263,10 @@ static ssize_t inotify_read(struct file
>  		if (start != buf)
>  			break;
>  
> -		schedule();
> +		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
>  	}
> +	remove_wait_queue(&group->notification_waitq, &wait);
>  
> -	finish_wait(&group->notification_waitq, &wait);
>  	if (start != buf && ret != -EFAULT)
>  		ret = buf - start;
>  	return ret;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
> 

