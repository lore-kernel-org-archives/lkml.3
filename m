Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3LDWMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:12:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab3LDWMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:12:13 -0500
Date: Wed, 4 Dec 2013 16:27:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the
	buggy while_each_thread()
Message-ID: <20131204152719.GA1235@redhat.com>
References: <20131204130351.GA5984@redhat.com> <20131204130409.GA5998@redhat.com> <20131204132828.GC4530@localhost.localdomain> <20131204134917.GA7251@redhat.com> <20131204141724.GF4530@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204141724.GF4530@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Frederic Weisbecker wrote:
>
> On Wed, Dec 04, 2013 at 02:49:17PM +0100, Oleg Nesterov wrote:
> >
> > Yes, perhaps we will need for_each_thread_continue(). I am not sure
> > yet. And note that, say, check_hung_uninterruptible_tasks() already
> > does _continue if fact, although it is still not clear to me if we
> > actually need this helper.
>
> So that's one of the possible users. _continue() can make sense if the
> reader can easily cope with missing a few threads from time to time, which
> is the case of the hung task detector.

Yes, but again it is not clear if we need the new helper.

For example. Note that you can simply do something like:

	// p can't go away

	rcu_read_lock();
	for_each_thread(p, t) {
		do_something(t);

		if (need_to_sleep()) {
			get_task_struct(t);
			rcu_read_unlock();

			schedule_timeout_interruptible(...);

			rcu_read_lock();
			put_task_struct();
			if (!pid_alive(t))
				break;
		}
	}
	rcu_read_unlock();

If you rewrite this code using for_each_thread_continue (which is just
list_for_each_entry_continue_rcu) the code will look more complex.

> > Note also that _continue() can't be safely used lockless, unless
> > you verify pid_alive() or something similar.
>
> Hmm, due to concurrent list_del()?
>
> Right, tsk->thread_list.next could point to junk after a list_del(), say if the next
> entry has been freed.

Yes. The same problem which while_each_thread() currently has (I mean,
even ignoring the fact it is itself buggy).

Oleg.

