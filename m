Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaHJVlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 17:41:55 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:50289 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaHJVln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 17:41:43 -0400
Message-ID: <53E7E712.9060201@hp.com>
Date: Sun, 10 Aug 2014 17:41:38 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>, aswin@hp.com
Subject: Re: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner
 before wakeup
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>   <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>   <1407458726.2513.12.camel@buesod1.americas.hpqcorp.net>  <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>  <53E5172A.7090508@hp.com> <1407524600.6583.6.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1407524600.6583.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:03 PM, Davidlohr Bueso wrote:
> On Fri, 2014-08-08 at 14:30 -0400, Waiman Long wrote:
>> I have 2 issues about this. First of all, the timing windows between
>> atomic_set() and mutex_has_owner() check is really small, I doubt it
>> will be that effective.
> That is true, which is why I didn't bother showing any performance data
> in the changelog. However, more important than any performance, avoiding
> bogus wakeups is the _right_ thing to do when allowing lock stealing.
>
>> Secondly, I think you may need to call
>> mutex_release() and debug_mutex_unlock() to make the debugging code
>> work, but they seems to be called only under the wait_lock. So I think
>> there is more work that need to be done before this patch is ready.
> When !DEBUG both mutex_release() and debug_mutex_unlock() should be
> no-ops. So this allows us to do the mutex_has_owner() check *without*
> holding the wait_lock.
>
> When DEBUG is set, we don't even bother calling mutex_has_owner(), so
> nothing changes.
>
> I don't understand your concern.

It is true I forgot the fact that MUTEX_SPIN_ON_OWNER is disabled when 
DEBUG_MUTEX is on. However, mutex_release is controlled by the LOCKDEP 
config variable which is independent of DEBUG_MUTEX. So it is still a 
concern.

-Longman
