Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3IWPRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:17:41 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:30048 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab3IWPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:17:40 -0400
Message-ID: <52405B93.2010206@akamai.com>
Date: Mon, 23 Sep 2013 11:17:39 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
References: <1379087642-131349-1-git-send-email-nzimmer@sgi.com> <5239FA69.8030202@akamai.com> <523B2867.7000209@sgi.com>
In-Reply-To: <523B2867.7000209@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 12:37 PM, Nathan Zimmer wrote:
> On 09/18/2013 02:09 PM, Jason Baron wrote:
>> On 09/13/2013 11:54 AM, Nathan Zimmer wrote:
>>> We noticed some scaling issue in the SPECjbb benchmark.  Running perf
>>> we found that the it was spending lots of time in SYS_epoll_ctl.
>>> In particular it is holding the epmutex.
>>> This patch helps by moving out the kmem_cache_alloc and kmem_cache_free out
>>> from under the lock.  It improves throughput by around 15% on 16 sockets.
>>>
>>> While this patch should be fine as it is there are probably is more things
>>> that can be done out side the lock, like wakeup_source_unregister, but I am
>>> not familar with the area and I don't know of many tests.  I did find the
>>> one posted by Jason Baron at https://lkml.org/lkml/2011/2/25/297.
>>>
>>> Any thoughts?
>>>
>> Hi,
>>
>> Intersting - I think its also possible to completely drop taking the
>> 'epmutex' for EPOLL_CTL_DEL by using rcu, and restricting it on add
>> to more 'complex' topologies. That is when we have an epoll descriptor
>> that doesn't nest with other epoll descriptors, we don't need the
>> global 'epmutex' either. Any chance you can re-run with this? Its a bit
>> hacky, but we can clean it up if it makes sense.
>>
>> Thanks,
>>
>> -Jason
>>
> That is working GREAT.  It is scaling to 16 jobs quite well.
> I will have to grab a larger machine( to see what the new scaling curve 
> will be.
> 

Cool. Any specific numbers would be helpful for the changelog in support of these
changes. Also, I think the move the alloc/free out of from under the locks still
might be nice, since we are still taking the per-ep lock in most cases. If you
want I can roll those too into a patch series for this when I resubmit.

Also, if you're still testing I have a small additional optimization on top of the
prior patch:

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d98105d..d967fd7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -857,7 +857,7 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 	struct eventpoll *ep = file->private_data;
 	struct readyevents_params params;
 
-	params.locked = ((wait->_qproc == ep_ptable_queue_proc) ? 1 : 0);
+	params.locked = ((wait && (wait->_qproc == ep_ptable_queue_proc)) ? 1 : 0);
 	params.ep = ep;
 
 	/* Insert inside our poll wait queue */
@@ -1907,7 +1907,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			} else
 				list_add(&tf.file->f_tfile_llink, &tfile_check_list);
 			mutex_lock_nested(&ep->mtx, 0);
-			ep->type = EVENTPOLL_COMPLEX;
 			if (is_file_epoll(tf.file)) {
 				mutex_lock_nested(&(((struct eventpoll *)tf.file->private_data)->mtx), 1);
 				((struct eventpoll *)tf.file->private_data)->type = EVENTPOLL_COMPLEX;


Thanks,

-Jason







