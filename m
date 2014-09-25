Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaIYKXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:23:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54638 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaIYKXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:23:49 -0400
Message-ID: <5423ED2B.8010009@huawei.com>
Date: Thu, 25 Sep 2014 18:23:39 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Wagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com> <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com> <20140924185213.GB7996@ZenIV.linux.org.uk> <20140924192456.GA1233@mtj.dyndns.org> <20140925024719.GJ7996@ZenIV.linux.org.uk> <20140925032502.GB6903@mtj.dyndns.org>
In-Reply-To: <20140925032502.GB6903@mtj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/25 11:25, Tejun Heo wrote:
> Hello, Al.
> 
> On Thu, Sep 25, 2014 at 03:47:19AM +0100, Al Viro wrote:
>>> Yeah, it's an ugly thing to work around vfs interface not very
>>> conducive for filesystems which conditionally create or reuse
>>> superblocks during mount.  There was a thread explaining what's going
>>> on.  Looking up...
>>>
>>>   http://thread.gmane.org/gmane.linux.kernel.containers/27623/focus=10635
>>
>> Umm...  I still don't get it.  Could you describe the screnario in which
>> that percpu_ref_tryget_live() would be called and managed to fail?
> 

See this:

https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/commit/kernel/cgroup.c?id=3a32bd72d77058d768dbb38183ad517f720dd1bc

Without the above commit, A scenario like this can happen:

1. Thread A has dropped sb refcnt to 0 but hasn't called percpu_ref_kill(). 
2. At this time Thread B calls cgroup_mount() and percpu_ref_tryget() succeeds.
3. After a while Thread C calls cgroup_mount(), but percpu_ref_tryget() keeps
returning failure, because the ref has been killed by percpu_ref_kill().

So I had to use kernfs_pin_sb() to prevent thread B from getting the percpu refcnt.

Any better idea to fix this?

> That was for the initial fix and Li later added the pinning to fix
> something else.  Let's wait for Li to chime in.  He knows this part
> better.
> 
>> It smells to me like most of the problems here are simply due to having too
>> many locks and not being able to decide where should they live relative to
>> ->s_umount.  That cgroup_mutex thing feels like something way to coarse...
>> You have it grabbed/dropped in
> 
> cgroup_mutex is the outer-most lock as far as cgroup is concerned and
> not expected to nest under anything which is used by individual
> controllers.  Most of what cgroup core does is low-freq managerial
> things which don't benefit from finer grained locking and the mount
> path is one of few surfaces where it interacts with outside in terms
> of locking, so it's better to keep that path special and everything
> else simpler.
> 
>> And that's a single system-wide mutex.  Plus there's a slew of workqueues
>> and really unpleasant abuse of restart_syscall() tossed in for fun - what
>> happens if some joker triggers that ->mount() _not_ from mount(2)?
> 
> For cgroup, mount is the userland-visible init interface.  It gotta be
> called from userland.  It originally had internal retry loop but
> syscall restart is simpler.  Reviving that loop isn't difficult if it
> ever becomes necessary.
> 
>> Then there's a global rwsem nesting inside that sucker.  And there's another
> 
> The rwsem nests inside cgroup_mutex and exists to allow multiple
> reader accesses to a particular data structure.
> 
>> mutex in fs/kernfs - also a global one.  Are the locking rules documented
>> anywhere?  Lifetime rules, as well...
> 
> kernfs one shouldn't interact with anything outside kernfs.  Its
> dependency is terminated within kernfs.
> 
>> Frankly, my first inclination here would be to try using sget() instead of
>> scanning the list of roots.  How painful would it be to split the allocation
>> and setup of roots, always allocate a new root and have sget() wait
>> for fs shutdown in progress and decide whether it wants to reuse the existing
>> one.  You can easily tell reuse existing vs. set up a new one from each other -
>> just look at the root associated with the superblock you've got and check
>> if it's the one you've allocated.  Freeing the damn thing if we'd reused
>> an existing one and doing setup otherwise.
>>
>> I realize that it won't do in such form; your for_each_subsys() loop in there
>> really depends on holding cgroup_mutex all the way through.  But do we really
>> need it there?  Would just skipping the ones that doomed in rebind_subsystems()
>> suffice?
> 
> At this point, cgroup core locking is heavily focused on simplicity -
> cgroup_mutex for the whole thing and css_set_rwsem for css_set reader
> accesses.  It works out pretty well for the rest of the code but the
> mount path does get tricky.  We can definitely relax / separate out
> locking on subsys iteration for mount path but if possible I'd prefer
> to pay isolated complexity there instead of spilling it to other
> places.
> 
> Anyways, let's wait for Li.  At least nobody reported breakage before
> the recent commit, so we can revert the offending commit for the short
> term.
> 

That patch is wrong. We have to use both pinned_sb and new_sb, so
please revert it. :(

I think we need to put some test cases in tools/testing/selftests/, to
prevent this fragile thing from breaking again.
