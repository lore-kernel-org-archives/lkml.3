Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaKYWgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:36:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaKYWgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:36:16 -0500
Message-ID: <1416954967.2509.25.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 26 Nov 2014 06:36:07 +0800
In-Reply-To: <20141125215248.GA7958@redhat.com>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	 <20141125010734.4974.85347.stgit@pluto.fritz.box>
	 <20141125215248.GA7958@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 22:52 +0100, Oleg Nesterov wrote:
> Let me first apologize, I didn't actually read this series yet.
> 
> But I have to admit that so far I do not like this approach...
> probably I am biased.

Oleg, thanks for your comments.

> 
> On 11/25, Ian Kent wrote:
> >
> > The call_usermodehelper() function executes all binaries in the
> > global "init" root context. This doesn't allow a binary to be run
> > within the callers namespace (aka. a container).
> 
> Please see below.
> 
> > Both containerized NFS client and NFS server need the ability to
> > execute a binary within their container. To do this create a new
> > nsproxy within the callers' context so it can be used for setup
> > prior to calling do_execve() from the user mode helper thread
> > runner.
> 
> and probably we also need this for coredump helpers, we want them
> to be per-namespace.

To save me some time could you point me to some of the related code
please. I don't normally play in that area.

> 
> > +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
> > +{
> > +	struct nsproxy *ns = info->data;
> > +
> > +	mntns_setfs(ns->mnt_ns);
> 
> Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
> Let me remind about the coredump. The dumping task can cloned with
> CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
> this enough.
> 
> 
> > +	switch_task_namespaces(current, ns);
> 
> This doesn't look sane because this won't switch task_active_pid_ns().

I wondered about that too but I didn't design the open()/setns()
interface and TBH I've been wondering how he hell it is supposed to work
because of exactly this.

The statement amounts to saying that the
fd = open(/proc/<pid in target namespace>/ns/mnt);
setns(fd);
won't set the namespace properly but the documentation I've seen so far
(there's probably more that I need to see, I'll look further) implies
this is sufficient.

How does one correctly set the namespace in user space since each of
the /proc/<pid>/ns/<namespace> will use a slightly different
proc_ns_operations install function? 

Are we saying that, for example, if open(/proc/<pid>/ns/pid)/setns() is
used then the process must not do path lookups if it expects them to be
within the namespace and restrict itself to pid related system calls
only and so on for each of the other namespaces?

Or is it assumed that userspace will do
open(/proc/<pid>/ns/<namespace>)/setns()/close() every time it makes
systems calls that rely on a specific type of namespace?

> 
> And this reminds me another discussion, please look at
> http://marc.info/?l=linux-kernel&m=138479570926192
> 
> Once again, this is just an idea to provoke more discussion. I am starting
> to think that perhaps we need pid_ns->umh_helper (init by default). And
> PR_SET_NS_UMH_HELPER.

Yeah, I'll need to digest that for a while.

Ian

