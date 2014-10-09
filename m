Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbaJIVh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932899AbaJIVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:37:24 -0400
Date: Thu, 9 Oct 2014 23:34:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
Cc: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
Message-ID: <20141009213414.GA10705@redhat.com>
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com> <20141008151328.GB4835@redhat.com> <5871495633F38949900D2BF2DC04883E5E1649@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5871495633F38949900D2BF2DC04883E5E1649@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Chen, Hanxiao wrote:
>
> > From: Oleg Nesterov [mailto:oleg@redhat.com]
> >
> > Hmm. We only want the tasks from our namespace, yes? Perhaps find_ge_pid()
> > makes more sense?
>
> Only tasks from our ns is valid.
> But how could find_ge_pid() do that?
>
> nr = 1;
> while (nr < PID_MAX_LIMIT) {
> 	find_ge_pid(nr, curr_ns);
> 	list_add();
> 	nr++;
> }

something like this, except list_add() should obviously depend on
is_child_reaper() check.

This can be more optimal in sub-namespaces, you do not need to abuse
the global process list.

And if you change this code to use get_pid/put_pid, then you do not
need to hold rcu_read_lock() throughout, you only need it around
find_ge_pid + get_pid.

At the same time, for_each_process() in the global namespace can be
faster if there are a lot of sub-threads.

> Perhaps that's not a good way.

OK, I won't insist.

although it would be nice to know why do you think this is bad.

> > > +		pid = task_pid(p);
> >
> > Well, in theory you need barrier() here. Or perhaps we should add
> > ACCESS_ONCE() into task_pid()...
>
> You mean modify task_pid as:
> return ACCESS_ONCE(task->pids[PIDTYPE_PID].pid;);

Yes. But not now an not in this patch of course. I'd suggest to add
barrier() just in case.


> > And imho it would be better to declare pidns_list/pidns_tree locally
> > in nslist_proc_show() and pass them to the callees.
>
> That's a good idea.
> Will changed in the next version.

Good. And I forgot to mention, in this case you do not need pidns_list_lock
at all afaics.

Oleg.

