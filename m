Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbaHHTDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:03:25 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:17539 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaHHTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:03:24 -0400
Message-ID: <1407524600.6583.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner
 before wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>, aswin@hp.com
Date: Fri, 08 Aug 2014 12:03:20 -0700
In-Reply-To: <53E5172A.7090508@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
	  <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>
	  <1407458726.2513.12.camel@buesod1.americas.hpqcorp.net>
	 <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>
	 <53E5172A.7090508@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 14:30 -0400, Waiman Long wrote:
> I have 2 issues about this. First of all, the timing windows between 
> atomic_set() and mutex_has_owner() check is really small, I doubt it 
> will be that effective. 

That is true, which is why I didn't bother showing any performance data
in the changelog. However, more important than any performance, avoiding
bogus wakeups is the _right_ thing to do when allowing lock stealing.

> Secondly, I think you may need to call 
> mutex_release() and debug_mutex_unlock() to make the debugging code 
> work, but they seems to be called only under the wait_lock. So I think 
> there is more work that need to be done before this patch is ready.

When !DEBUG both mutex_release() and debug_mutex_unlock() should be
no-ops. So this allows us to do the mutex_has_owner() check *without*
holding the wait_lock.

When DEBUG is set, we don't even bother calling mutex_has_owner(), so
nothing changes.

I don't understand your concern. 

Thanks,
Davidlohr

