Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaKYXHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:07:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaKYXHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:07:35 -0500
Message-ID: <1416956845.2509.38.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 26 Nov 2014 07:07:25 +0800
In-Reply-To: <87y4qy7wci.fsf@x220.int.ebiederm.org>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	 <20141125010734.4974.85347.stgit@pluto.fritz.box>
	 <20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
	 <87y4qy7wci.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 16:23 -0600, Eric W. Biederman wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > On 11/25, Oleg Nesterov wrote:
> >>
> >> Let me first apologize, I didn't actually read this series yet.
> >>
> >> But I have to admit that so far I do not like this approach...
> >> probably I am biased.
> >
> > Yes.
> >
> > And I have another concern... this is mostly a feeling, I can be
> > easily wrong but:
> >
> >> On 11/25, Ian Kent wrote:
> >> >
> >> > +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
> >> > +{
> >> > +	struct nsproxy *ns = info->data;
> >> > +
> >> > +	mntns_setfs(ns->mnt_ns);
> >>
> >> Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
> >> Let me remind about the coredump. The dumping task can cloned with
> >> CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
> >> this enough.
> >
> > And otoh. If we actually want to use the caller's mnt_ns/namespaces we
> > could simply fork/reparent a child which will do execve ?
> 
> That would certainly be a better approach, and roughly equivalent to
> what exists here.  That would even ensure we remain in the proper
> cgroups, and lsm context.
> 
> The practical problem with the approach presented here is that I can
> hijack any user mode helper I wish, and make it run in any executable I
> wish as the global root user.
> 
> Ian if we were to merge this I believe you would win the award for
> easiest path to a root shell.

LOL, OK, so there's a problem with this.

But, how should a user mode helper execute within a namespace (or more
specifically within a container)?

Suppose a user mode helper program scans through the pid list and
somehow picks the correct process pid and then does an
open()/setns()/execve().

Does that then satisfy the requirements?
What needs to be done to safely do that in kernel?

The other approach I've considered is doing a full open()/setns() in
kernel (since the caller already knows its pid) but it sounds like
that's not right either.

Ian

