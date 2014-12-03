Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaLCSO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:14:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaLCSOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:14:25 -0500
Date: Wed, 3 Dec 2014 13:14:15 -0500 (EST)
From: Benjamin Coddington <bcodding@redhat.com>
X-X-Sender: bcodding@planck.local
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Ian Kent <ikent@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
In-Reply-To: <87zjb4k7b6.fsf@x220.int.ebiederm.org>
Message-ID: <alpine.OSX.2.19.9992.1412031243160.12108@planck.local>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box> <20141125010734.4974.85347.stgit@pluto.fritz.box> <20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com> <87y4qy7wci.fsf@x220.int.ebiederm.org> <1416956845.2509.38.camel@pluto.fritz.box>
 <871toq7tr6.fsf@x220.int.ebiederm.org> <1416959452.2509.52.camel@pluto.fritz.box> <87egsq3fna.fsf@x220.int.ebiederm.org> <alpine.LRH.2.11.1412011607450.2583@sh-el6.eng.rdu2.redhat.com> <1417563215.2531.25.camel@pluto.fritz.box>
 <87zjb4k7b6.fsf@x220.int.ebiederm.org>
User-Agent: Alpine 2.19.9992 (OSX 65 2014-06-20)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2014, Eric W. Biederman wrote:

> Ian Kent <ikent@redhat.com> writes:
>
> > On Mon, 2014-12-01 at 16:56 -0500, Benjamin Coddington wrote:
> >> n Tue, 25 Nov 2014, Eric W. Biederman wrote:
> >> Hi,
> >>
> >> > Ian Kent <ikent@redhat.com> writes:
> >> >
> >> > > On Tue, 2014-11-25 at 17:19 -0600, Eric W. Biederman wrote:
> >> > >> Ian Kent <ikent@redhat.com> writes:
> >> > >>
> >> > >> > On Tue, 2014-11-25 at 16:23 -0600, Eric W. Biederman wrote:
> >> > >> >> Oleg Nesterov <oleg@redhat.com> writes:
> >> > >> >>
> >> > >> >> > On 11/25, Oleg Nesterov wrote:
> >> > >> >> >>
> >> > >> >> >> Let me first apologize, I didn't actually read this series yet.
> >> > >> >> >>
> >> > >> >> >> But I have to admit that so far I do not like this approach...
> >> > >> >> >> probably I am biased.
> >> > >> >> >
> >> > >> >> > Yes.
> >> > >> >> >
> >> > >> >> > And I have another concern... this is mostly a feeling, I can be
> >> > >> >> > easily wrong but:
> >> > >> >> >
> >> > >> >> >> On 11/25, Ian Kent wrote:
> >> > >> >> >> >
> >> > >> >> >> > +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
> >> > >> >> >> > +{
> >> > >> >> >> > +	struct nsproxy *ns = info->data;
> >> > >> >> >> > +
> >> > >> >> >> > +	mntns_setfs(ns->mnt_ns);
> >> > >> >> >>
> >> > >> >> >> Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
> >> > >> >> >> Let me remind about the coredump. The dumping task can cloned with
> >> > >> >> >> CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
> >> > >> >> >> this enough.
> >> > >> >> >
> >> > >> >> > And otoh. If we actually want to use the caller's mnt_ns/namespaces we
> >> > >> >> > could simply fork/reparent a child which will do execve ?
> >> > >> >>
> >> > >> >> That would certainly be a better approach, and roughly equivalent to
> >> > >> >> what exists here.  That would even ensure we remain in the proper
> >> > >> >> cgroups, and lsm context.
> >> > >> >>
> >> > >> >> The practical problem with the approach presented here is that I can
> >> > >> >> hijack any user mode helper I wish, and make it run in any executable I
> >> > >> >> wish as the global root user.
> >> > >> >>
> >> > >> >> Ian if we were to merge this I believe you would win the award for
> >> > >> >> easiest path to a root shell.
> >> > >> >
> >> > >> > LOL, OK, so there's a problem with this.
> >> > >> >
> >> > >> > But, how should a user mode helper execute within a namespace (or more
> >> > >> > specifically within a container)?
> >> > >> >
> >> > >> > Suppose a user mode helper program scans through the pid list and
> >> > >> > somehow picks the correct process pid and then does an
> >> > >> > open()/setns()/execve().
> >> > >> >
> >> > >> > Does that then satisfy the requirements?
> >> > >> > What needs to be done to safely do that in kernel?
> >> > >> >
> >> > >> > The other approach I've considered is doing a full open()/setns() in
> >> > >> > kernel (since the caller already knows its pid) but it sounds like
> >> > >> > that's not right either.
> >> > >>
> >> > >> The approach we agreed upon with the core dump helper was to provide
> >> > >> enough information that userspace could figure out what was the
> >> > >> appropriate policy and call nsenter/setns.
> >> > >
> >> > > Your recommending I have a look at the core dump helper, that's fine,
> >> > > I'll do that.
> >> >
> >> > I am just describing it because it came up.  Core dumps are a much
> >> > easier case than nfs.
> >> >
> >> > Frankly if we can figure out how to run the user mode helpers from the
> >> > kernel with an appropriate context and not involve userspace I think
> >> > that will be better for everyone, as it involves fewer moving parts at
> >> > the end of the day.
> >> >
> >> > >> The only sane approach I can think of in the context of nfs is to fork
> >> > >> a kernel thread at mount time that has all of the appropriate context
> >> > >> because it was captured from the privileged mounting process, and use
> >> > >> that kernel as the equivalent of kthreadd.
> >> > >>
> >> > >> There may be some intermediate ground where we capture things or we use
> >> > >> the init process of the pid namespace (captured at mount time) as our
> >> > >> template/reference process.
> >> > >>
> >> > >> If we are going to set this stuff up in the kernel we need a reference
> >> > >> process that we can create children of because what is possible with
> >> > >> respect to containers keeps changing, and it is extremely error prone to
> >> > >> figure out what all othe crazy little bits are, and to update everything
> >> > >> every time someone tweaks the kernel's capabilities.  We have kthreadd
> >> > >> because it was too error prone to scrub a userspace thread of all of the
> >> > >> userspace bits and make it the equivalent of what kthreadd is today.
> >> > >>
> >> > >> Of course it is also rather nice to have something to hang everything
> >> > >> else on.
> >> > >>
> >> > >> In summary we need a reference struct task that is all setup properly
> >> > >> so that we can create an appropriate kernel thread.
> >> > >
> >> > > I'm having trouble understanding what your getting at here but I'm not
> >> > > that sharp so bear with me.
> >> > >
> >> > > When call_usermodehelper() is called it's called from a process that is
> >> > > within the context within which the execution is required.
> >> >
> >> > No it is not.  That is precisely why we have call_usermodehelper instead
> >> > of just forking and exec'ing something.  The context which triggers the
> >> > call can be completely different from where you want to run.
> >> >
> >> > > So what information do we not have available for setup?
> >> > >
> >> > > Are you saying that the problem is that when the user mode helper run
> >> > > thread is invoked we don't have the information available that was
> >> > > present when call_usermodehelper() was called and that's where the
> >> > > challenge lies?
> >> >
> >> > That is part of it.
> >> >
> >> > However in the context of nfs the correct context is determined at mount
> >> > time, and so when call_usermodehelper() is invoked the only link to that
> >> > correct context that we have is the nfs super block.
> >> >
> >> > In a pathological case a userspace application can create a new user
> >> > namespace, and a new mount namespace and completely rearrange the
> >> > mounts, and deliberately trigger an nfs user mode helper.  If we were to
> >> > use that applications context it could control which userspace
> >> > application the kernel invoked.
> >>
> >> Then it seems it would never be safe to try to execve /sbin/request-key
> >> within the calling process' mnt_ns, so if we want to do some work
> >> within that namespace the transition to it needs to happen after the
> >> upcall, after /sbin/request-key calls the appropriate helper.
>
> No.  We never want to do work in the calling process's mnt_ns.
> We want to work in the mounters mnt_ns which given mount propagation
> can be something completely and totally different.
>
> >> And instead of transitioning into this context before execve, instead
> >> pass it along to allow the userspace helper to do setns()..
> >
> > I still don't see the difference between, given an appropriate pid,
> > using the open()/setns() mechanism in kernel similar to nsenter(1).
> >
> > In that case the setup is done before the first exec rather than between
> > the first and second exec (the one in nsenter). Our other approach
> > essentially did that but (incorrectly) used the current process pid and
> > didn't deal with all the namespace types as nsenter does.
> >
> > Isn't the real problem getting hold of an appropriate pid to use for the
> > open/setns that belongs to a process that's still running?
> > What else is needed, Eric?
>
> Essentially that is the real problem.  Getting ahold of the context of
> the container in which a filesystem was mounted.
>
> Now it isn't just namespaces but also cgroups and uids and gids and
> capabilities and process groups and sessions.  There are a whole host of
> little things that need to be right to run a user mode helper, and
> in particular to run a user mode helper in a ``container''.
>
> > Not having looked at how core dumping works before, I'm having
> > difficulty working out what gets executed in user space so I can't be
> > sure that what I'm saying is accurate, can someone spell this out for me
> > please?
>
> In that case what happens is that the normal user mode helper process
> runs started by kthreadd and if %P is specified that processes knows the
> pid in the initial pid namespace.  Which is good enough to use nsenter
> and otherwise figure out the appropriate container from the process that
> is dumping core.
>
> It is easier with core dumping as we don't have the disconnect in
> contexts that we do with filesystems.
>
> >> > So deeply and fundamentally for the case of nfs you need to capture the
> >> > context at nfs mount time.  The easiest way would be to fork a kernel
> >> > thread when nfs is mounted, that captures the entire context.
> >> >
> >> > We might be able to do something a little more sophisticated and a
> >> > little less resource intensive, like pick on the init process that
> >> > exists when nfs is mounted.
> >>
> >> The only namespace that needs to be preserved from mount time would be
> >> the mount namespace which can be pulled from the mount itself and passed
> >> along in the key request.
>
> We absolutely can not pull the mount from the mount namespace.  Mount
> propagtion makes that impossible.
>
> > Sounds simple but isn't it the case we don't know and shouldn't have to
> > care about what system calls the helper uses since the environment
> > should "see" what it's supposed to?
>
> The tricky bit is setting the environment correctly.
>
> >> Or if we tracked the mount namespace when creating a user
> >> namespace, we could climb out of the mount namespaces created within
> >> user namespaces by following them out.  Does that sound sane, or
> >> completely nuts?
>
> For what we have today (where the global root user has to mount the nfs
> filesystem) tracking the mount namespace at the time nfs is mounted is
> close to enough.  However if we are going to work this out we need to
> solve this for an nfs where we are brave enough to set
>  ".fs_flags = FS_USERNS_MOUNT".
>
> The NFS code base is nearly at the point where we can reasonably talk
> about supporting unprivileged mounts.
>
> >> > Those are the general parameters.
> >>
> >> It does seem very expensive to keep a thread around for every mount; I'm
> >> still trying to find a way around it..
> >
> > Yeah, that's not such a good idea.
> >
> > Several hundred mounts is going to create a big mess for system
> > administrators, not to mention the overhead. It's right up there with
> > symlinking /etc/mtab to /proc/self/mounts at sites with large direct
> > mount maps.
>
> A thread will cost you maybe 40k.  In the grand scheme of things that
> really isn't a lot.  I agree that it would be nice to do better than
> one thread per mount.   But I start with a thread as a reference point
> as that is the trivial way to get things correct.
>
> To relax it from a thread per mount we need definitions that we can
> explain to folks in userspace about when and where user mode helpers
> will run.
>
> I think something like Oleg's proposal to use the init process of a pid
> namespace as our reference is worth exploring.  We certainly don't match
> the mounters exact environment when running user mode helpers today, so
> there is leeway for some relaxation without breaking userspace.

That might look like a "khelper" workqueue for each pid namespace, and the
user of call_usermodehelper() would specify that the current pid namespace
helper should or should not be used.

Oleg also mentioned only using (or creating) the namespace helper if
requested via prctl().  I can imagine that some users of namespaces would
want to keep calls to userspace helpers within the global root space.

If the helper would only be created by request, that takes away the overhead
of thread-per-mount or thread-per-pid-namespace a bit.

As you mentioned earlier, it is a good idea to think about providing
userspace with a clear understanding of how and where user mode helpers run.
This approach allows userspace to think about them as being tied to the
first process in each container.

Ben

> There are funny issues without forking a thread to run the user mode
> helpers, such as what happens if all of the processes in the container
> exit what should happen?  Remember that mount propagation allows the
> filesystem to propagate into different mount namespaces and bind mounts
> allow the filesystem to show up in different places in the those mount
> namespaces.
>
> If the container has exited should the filesystem remain functional?
> Should the kernel keep pieces of the container alive to run user mode
> helpers?
>
> Eric
>
>
