Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaLCXeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:34:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaLCXeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:34:20 -0500
Message-ID: <1417649648.2581.32.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Coddington <bcodding@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 04 Dec 2014 07:34:08 +0800
In-Reply-To: <87zjb4k7b6.fsf@x220.int.ebiederm.org>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	 <20141125010734.4974.85347.stgit@pluto.fritz.box>
	 <20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
	 <87y4qy7wci.fsf@x220.int.ebiederm.org>
	 <1416956845.2509.38.camel@pluto.fritz.box>
	 <871toq7tr6.fsf@x220.int.ebiederm.org>
	 <1416959452.2509.52.camel@pluto.fritz.box>
	 <87egsq3fna.fsf@x220.int.ebiederm.org>
	 <alpine.LRH.2.11.1412011607450.2583@sh-el6.eng.rdu2.redhat.com>
	 <1417563215.2531.25.camel@pluto.fritz.box>
	 <87zjb4k7b6.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 10:49 -0600, Eric W. Biederman wrote:
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

And I think this is where the confusion starts because ....

As it stands (whether executing within a container or not) the mounting
process is mostly long gone when these calls are made and they are
executed from the root init context.

So doesn't adding a new init context, for example the init context of a
container, then using that for the template amount to the same thing
within the container?

If we accept that then the open/setns is "fairly" straight forward.

TBH I'm struggling to see where would be different.

Ian

