Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3LDORb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:17:31 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51844 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3LDOR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:17:29 -0500
Date: Wed, 4 Dec 2013 15:17:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the buggy
 while_each_thread()
Message-ID: <20131204141724.GF4530@localhost.localdomain>
References: <20131204130351.GA5984@redhat.com>
 <20131204130409.GA5998@redhat.com>
 <20131204132828.GC4530@localhost.localdomain>
 <20131204134917.GA7251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204134917.GA7251@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:49:17PM +0100, Oleg Nesterov wrote:
> On 12/04, Frederic Weisbecker wrote:
> >
> > On Wed, Dec 04, 2013 at 02:04:09PM +0100, Oleg Nesterov wrote:
> >
> > > For example, do/while_each_thread() always
> > > sees at least one task, while for_each_thread() can do nothing if
> > > the whole thread group has died.
> >
> > Would it be safe to have for_each_thread_continue() instead?
> 
> Yes, and no.
> 
> Yes, perhaps we will need for_each_thread_continue(). I am not sure
> yet. And note that, say, check_hung_uninterruptible_tasks() already
> does _continue if fact, although it is still not clear to me if we
> actually need this helper.

So that's one of the possible users. _continue() can make sense if the
reader can easily cope with missing a few threads from time to time, which
is the case of the hung task detector.

> 
> But no, _continue() can't help if the whole thread group has died,
> we simply can not continue.

Right, but if the whole group has died, the list is empty anyway. I mean
pure rcu walking requires the user to tolerate the miss of some concurrent
updates anyway.

> 
> Note also that _continue() can't be safely used lockless, unless
> you verify pid_alive() or something similar.

Hmm, due to concurrent list_del()?

Right, tsk->thread_list.next could point to junk after a list_del(), say if the next
entry has been freed.

> 
> And,
> 
> > Yeah if the conversion needs careful audit, it makes sense to switch incrementally.
> 
> Yes. For example the case above. If someone does
> 
> 	do
> 		do_something(t);
> 	while_each_thread(g, t);
> 
> we should check that it can tolerate the case when do_something()
> won't be called at all, or ensure that this is not possible.

Right!

Thanks.
