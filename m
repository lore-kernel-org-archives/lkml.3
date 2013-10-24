Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3JXQAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:00:43 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:49636 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974Ab3JXQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:00:41 -0400
Message-ID: <52694428.3000700@akamai.com>
Date: Thu, 24 Oct 2013 12:00:40 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "normalperson@yhbt.net" <normalperson@yhbt.net>,
        "nzimmer@sgi.com" <nzimmer@sgi.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "nelhage@nelhage.com" <nelhage@nelhage.com>,
        "davidel@xmailserver.org" <davidel@xmailserver.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] epoll: Do not take global 'epmutex' for simple
 topologies
References: <cover.1380645717.git.jbaron@akamai.com> <355cdd8dc79b7bcca59509999a972cc9d6b4b673.1380645717.git.jbaron@akamai.com> <20131024100940.GB4834@linux.vnet.ibm.com>
In-Reply-To: <20131024100940.GB4834@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 06:09 AM, Paul E. McKenney wrote:
> On Tue, Oct 01, 2013 at 05:08:14PM +0000, Jason Baron wrote:
>> When calling EPOLL_CTL_ADD for an epoll file descriptor that is attached
>> directly to a wakeup source, we do not need to take the global 'epmutex',
>> unless the epoll file descriptor is nested. The purpose of taking
>> the 'epmutex' on add is to prevent complex topologies such as loops and
>> deep wakeup paths from forming in parallel through multiple EPOLL_CTL_ADD
>> operations. However, for the simple case of an epoll file descriptor
>> attached directly to a wakeup source (with no nesting), we do not need
>> to hold the 'epmutex'.
>>
>> This patch along with 'epoll: optimize EPOLL_CTL_DEL using rcu' improves
>> scalability on larger systems. Quoting Nathan Zimmer's mail on SPECjbb
>> performance:
>>
>> "
>> On the 16 socket run the performance went from 35k jOPS to 125k jOPS.
>> In addition the benchmark when from scaling well on 10 sockets to scaling well
>> on just over 40 sockets.
>>
>> ...
>>
>> Currently the benchmark stops scaling at around 40-44 sockets but it seems like
>> I found a second unrelated bottleneck.
>> "
> 
> Some questions and comments below.
> 
>> Tested-by: Nathan Zimmer <nzimmer@sgi.com>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>  fs/eventpoll.c | 94 ++++++++++++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 68 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index dd9fae1..0f25162 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -595,8 +595,7 @@ static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
>>  static int ep_scan_ready_list(struct eventpoll *ep,
>>  			      int (*sproc)(struct eventpoll *,
>>  					   struct list_head *, void *),
>> -			      void *priv,
>> -			      int depth)
>> +			      void *priv, int depth, int ep_locked)
>>  {
>>  	int error, pwake = 0;
>>  	unsigned long flags;
>> @@ -607,7 +606,9 @@ static int ep_scan_ready_list(struct eventpoll *ep,
>>  	 * We need to lock this because we could be hit by
>>  	 * eventpoll_release_file() and epoll_ctl().
>>  	 */
>> -	mutex_lock_nested(&ep->mtx, depth);
>> +
>> +	if (!ep_locked)
>> +		mutex_lock_nested(&ep->mtx, depth);
>>
>>  	/*
>>  	 * Steal the ready list, and re-init the original one to the
>> @@ -671,7 +672,8 @@ static int ep_scan_ready_list(struct eventpoll *ep,
>>  	}
>>  	spin_unlock_irqrestore(&ep->lock, flags);
>>
>> -	mutex_unlock(&ep->mtx);
>> +	if (!ep_locked)
>> +		mutex_unlock(&ep->mtx);
>>
>>  	/* We have to call this outside the lock */
>>  	if (pwake)
> 
> OK, allowing calls to ep_scan_ready_list() to be made under the lock.
> 
> Usually you would use a __ep_scan_ready_list() instead of adding the
> flag, but you do have the wakeup that needs to be outside of the lock.
> 
> But doesn't that mean that you need something like?
> 
> 	if (pwake && !ep_locked)
> 
> And then wouldn't you also need some way to inform the caller to
> do the wakeup after releasing ep->mtx?
> 
> Or is it now safe to do the wakeup under ep->mtx?  If so, why?
> 

All I was trying to do here was to preserve the locking ep->mtx as it was
prior to this patch series. Because the patches now take the 'destination'
ep->mtx on an epoll_ctl() operation. It might be already held leading to
double locking (i hit this case while testing this series). So the idea
here is simply to realize when we've already grabbed this ep->mtx.


>> @@ -829,15 +831,34 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
>>  	return 0;
>>  }
>>
>> +static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
>> +				 poll_table *pt);
>> +
>> +struct readyevents_arg {
>> +	struct eventpoll *ep;
>> +	int locked;
>> +};
>> +
>>  static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
>>  {
> 
> OK, I will bite...  What is constraining the arguments of the
> ep_poll_readyevents_proc()?  I don't see any use of it except in this
> file.  Nor do I see any use of ep_call_nested() except in this file.
> Might it be a bit cleaner to add a flag to the argument list?
> 
> I don't feel strongly about this, just asking the question.
> 

I don't feel too strongly either, but other users of ep_call_nested
don't need this either...

Thanks,

-Jason

