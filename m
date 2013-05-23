Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3EWNG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:06:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab3EWNG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:06:27 -0400
Date: Thu, 23 May 2013 09:05:26 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, <viro@zeniv.linux.org.uk>,
        <serge.hallyn@canonical.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <oleg@redhat.com>, <bfields@fieldses.org>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <devel@openvz.org>
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20130523090526.63fc153e@corrin.poochiereds.net>
In-Reply-To: <519E0AB0.7040704@panasas.com>
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
	<878v36ex6n.fsf@xmission.com>
	<519DCE5D.6070204@parallels.com>
	<87k3mq9fsu.fsf@xmission.com>
	<519DF109.9010309@parallels.com>
	<20130523073108.13afafa6@tlielax.poochiereds.net>
	<519DFFA9.3010606@parallels.com>
	<20130523075620.21abf79a@tlielax.poochiereds.net>
	<519E0474.5000606@parallels.com>
	<519E0AB0.7040704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013 15:25:20 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 23/05/13 14:58, Stanislav Kinsbursky wrote:
> > 23.05.2013 15:56, Jeff Layton пишет:
> >> On Thu, 23 May 2013 15:38:17 +0400
> >> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
> >>
> >>> 23.05.2013 15:31, Jeff Layton пишет:
> >>>> On Thu, 23 May 2013 14:35:53 +0400
> >>>> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
> >>>>
> >>>>> 23.05.2013 14:00, Eric W. Biederman пишет:
> >>>>>> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
> >>>>>>
> >>>>>>> 22.05.2013 21:33, Eric W. Biederman пишет:
> >>>>>>>> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
> >>>>>>>>
> >>>>>>>>> Usermode helper executes all binaries in global "init" root context. This
> >>>>>>>>> doesn't allow to call a binary from other root context (for example in a
> >>>>>>>>> container).
> >>>>>>>>> Currently, both containerized NFS client and NFS server requires an ability to
> >>>>>>>>> execute a binary in a container's root context. Root swap can be done in
> >>>>>>>>> "init" callback, passed by UMH caller.
> >>>>>>>>> But since we have 2 callers already (and more of them are expected to appear
> >>>>>>>>> in future) and because set_fs_root() in not exported, it looks reasonable to
> >>>>>>>>> add one more generic UMH helper to generic fs code.
> >>>>>>>>> Root path reference must be hold by the caller, since it will be put on UMH
> >>>>>>>>> thread exit.
> >>>>>>>>
> >>>>>>>> Awesome.  With this patch as an uprivilieged user I get to pick which
> >>>>>>>> binary the kernel will execute.  At least if nfs and nfsd ever runs in a
> >>>>>>>> user namespace (something that looks like only matter of time).
> >>>>>>>>
> >>>>>>>
> >>>>>>> Not really. Only by using a kernel module to call the UMH.
> >>>>>>> And an unprivileged can't load a module as far a I know.
> >>>>>>> I.e. NFSd, for example, will use unprivileged user's root to perform this call.
> >>>>>>
> >>>>>> To help me understand the context which instances of call user mode
> >>>>>> helper are you expecting to use this facility?
> >>>>>>
> >>>>>
> >>>>> Ok. Here is how the NFSd uses UMH:
> >>>>> UMH is used on NFSd service to start user-space client tracker daemon
> >>>>> ("/sbin/nfsdcltarck"), which is used to store some per-client locks data on
> >>>>> persistent storage.
> >>>>>
> >>>>>>>> I think this is a seriously bad idea.
> >>>>>>>>
> >>>>>>>> Why can't we do this in userspace with setns as we do with the core dump
> >>>>>>>> helper?
> >>>>>>>>
> >>>>>>>
> >>>>>>> Could you, please, clarify, how setns can help here?
> >>>>>>
> >>>>>> setns can change the mount namespace, and chroot can change to root
> >>>>>> directory in the specified mount namespace.  Essentially you can enter
> >>>>>> into a containers complete context (pid, mnt, root, etc) comming from
> >>>>>> the outside.
> >>>>>>
> >>>>>
> >>>>> So, you are actually suggesting to move the binary start from the kernel to user-space.
> >>>>> IOW, you are suggesting to do not using UMH at all.
> >>>>> Am I right?
> >>>>> I don't know the reasons, why it was done by using UMH and not in userspace.
> >>>>> Could you clarify this, Jeff?
> >>>>>
> >>>>
> >>>> nfsdcltrack is a "one-shot" program for managing and querying the nfsd
> >>>> client tracking database. When knfsd needs to query or modify the
> >>>> db, it uses the UMH infrastructure to call this program that does
> >>>> what's requested and then exits.
> >>>>
> >>>> So, I'm not sure I really understand your question. It wasn't done in
> >>>> userspace since the whole purpose of this program is to handle upcalls
> >>>> from the kernel.
> >>>>
> >>>
> >>> The question is what was the reason to start this binary from kernel by UMH?
> >>
> >> Manipulating and querying the client tracking database is an infrequent
> >> event, so having a continuously running daemon is wasteful and means
> >> that the admin has to ensure that it's running. A UMH upcall is much
> >> simpler and generally "just works" if the program is present.
> >>
> >>> I.e. why it can't be started by some user-space process before or after NFSd start?
> >>> I don't familiar with this client tracking facility and that's the only reason why I'm asking.
> >>>
> >>
> >> This program is not a daemon that runs continuously. It's only called
> >> when the kernel needs to manipulate the database. Are you asking
> >> whether we could turn this into a continuously running daemon? If so
> >> then the answer is "yes", but that's not really a good idea either.
> >>
> >> In fact, we had that with the nfsdcld program, but no one liked it
> >> (including me) for the reasons I detailed above.
> >>
> > 
> > No, I'm just asking to understand.
> > Eric was, actually, asking the same. I.e. how does NFSd uses UMH and why this can't be done in userspace?
> > Thanks you for your answer.
> > 
> 
> I'm not familiar with nfsdcltrack but I would imagine it receives it's information from
> Kernel as a command line parameters.
> 
> Would it not be the simplest approach to add a --chroot=/path/to/root optional
> parameter to nfsdcltrack so it should access an alternate DB relative to 
> --chroot.
> 
> This would address Eric's concern of not executing user-privileged executable
> from Kernel. I think
> 
> Just my $0.017
> Boaz
> 

I think that sounds reasonable. Is it always the case
that /path/to/root is reachable from the "primary" namespace? If not,
you may need to do something more exotic there.

Also, do you have to do anything like change the uid/gid to a different
user who is root within the container?

What might help most here is to lay out a particular scenario for how
you envision setting up knfsd in a container so we can ensure that it's
addressed properly by whatever solution you settle on.

-- 
Jeff Layton <jlayton@redhat.com>
