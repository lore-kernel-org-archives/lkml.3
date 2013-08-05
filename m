Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3HETok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:44:40 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:39440 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3HETog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:44:36 -0400
Date: Mon, 5 Aug 2013 15:44:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Message-ID: <20130805194431.GD23751@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <20130805160107.GM10146@dhcp22.suse.cz>
 <20130805162958.GF19631@mtj.dyndns.org>
 <20130805191641.GA24003@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805191641.GA24003@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Mon, Aug 05, 2013 at 09:16:41PM +0200, Michal Hocko wrote:
> I keep hearing that over and over. And I also keep hearing that there
> are users who do not like many simplifications because they are breaking
> their usecases. Users are those who matter to me. Hey some of them are
> even sane...

There needs to be some balance between serving use cases and cutting
off edge ones which pollutes the code with unjustified complexity.  We
went way far to one end and are trying to cut back, so complaints are
expected.

> Besides that, is fsnotify really an interface to be used under memory
> pressure? I might be wrong but from a quick look fsnotify depends on
> GFP_KERNEL allocation which would be no-go for oom_control at least.

Yeap, I'm pretty sure you're wrong.  I didn't follow the development
but this is wrapper to combine inotify and dnotify and kernel's main
FS event mechanism and none of the two mechanisms required memory
allocation during delivery.

> How does the reclaim context gets to struct file to notify? I am pretty
> sure we would get to more and more questions when digging further.

The file is optional and probably just to extract path for dnotify, I
think.  Not sure about namespace implications but I'll build cgroup
level interface for it so that controllers won't have to deal with it
directly.  ie. there'll be css_notify_file(css, cfe) interface.

> I am all for simplifications, but removing interfaces just because you
> feel they are "over-done" is not a way to go IMHO. In this particular

We can keep it around but it's a pretty good time to gradually move
towards something saner as we're essentially doing v2 of the
interface.  Note that there's no reason for the interface to disappear
immediately.  You can keep it and there won't be any problem for it to
co-exist with simpler mechanism.

> case you are removing an interface from cgroup core which has users,
> and will have to support them for very long time. "It is just memcg
> so move it there" is not a way that different subsystems should work
> together and I am _not_ going to ack such a move. All the flexibility that
> you are so complaining about is hidden from the cgroup core in register
> callbacks and the rest is only the core infrastructure (registration and
> unregistration).

memcg is the only user and will stay that way.  If you wanna keep it
around, be my guest.  Also, cftype is planned to be simplified so that
it just provides seq_file interface and the types become helper
routines like a normal file callback interface.  There'll be nothing
tying the event file handling to cgroup core and it surely won't be
used by anyone else.  memcg is and will be the only user.  It's the
natural place for the code.

> And btw. a common notification interface at least makes things
> consistent and prevents controllers to invent their one purpose
> solutions.

We'll surely have a common notification interface which is simple -
basically just one function - as it should be.

> So I am really skeptical about this patch set. It doesn't give anything.
> It just moves a code which you do not like out of your sight hoping that
> something will change.
> 
> There were mistakes done in the past. And some interfaces are really too
> flexible but that doesn't mean we should be militant about everything.
> 
> > For the usage ones, configurability makes some sense but even then
> > just giving it a single array of event points of limited size would be
> > sufficient.
> 
> This would be a question for users. I am not one of those so I cannot
> tell you but I certainly cannot claim that something more coarse would
> be sufficient either.

I can tell you because there will be a single agent of the hierarchy
with unified hierarchy and both control and events will be routed
through it.  As such usage restriction rises from inherent properties
of the current cgroup design and implementation, it isn't something
which can be properly worked around.

> > It's just way over-done.
> 
> > > So you think that vmpressure, oom notification or thresholds are
> > > an abuse of this interface? What would you consider a reasonable
> > > replacement for those notifications?  Or do you think that controller
> > > shouldn't be signaling any conditions to the userspace at all?
> > 
> > I don't think the ability to generate events are an abuse, just that
> > the facility itself is way over-engineered.  Just generate a file
> > changed event unconditionally for vmpressure and oom and maybe
> > implement configureable cadence or single set of threshold array for
> > threshold events.  These are things which can and should be done in a
> > a few tens of lines of code with far simpler interface. 
> 
> These are strong words without any justification.

If you think this level of flexibility is healthy, we'll have to agree
to disagree.  Just look at it this way - this is memcg specific piece
of code and this patchset is just natural reorganization of code.

Thanks.

-- 
tejun
