Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaFTPjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:39:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:41940 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbaFTPjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:39:02 -0400
Date: Fri, 20 Jun 2014 12:24:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140620152449.GH31524@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <20140620132105.GE31524@kernel.org>
 <20140620150318.GK15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620150318.GK15620@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 20, 2014 at 07:03:18PM +0400, Stanislav Fomichev escreveu:
> > Just to clarify here, those slides came from slides I made and in turn
> > the whole idea about pagefaults tracing I got from the trace prototype
> > that Thomas Gleixner implemented in his 'trace'  utility, described
> > here:

> >   Announcing a new utility: 'trace'
> >   http://lwn.net/Articles/415728/

> > The comments section has lots of interesting ideas, some you may find
> > interesting to implement :-)

> > There is a branch in my tree with the branch tglx did his work on:

> > https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/trace2

> Wow, thanks, I tried to search lkml for any presence of
> patches/discussion about these slides, but couldn't find anything, thanks for
> pointing it out.
 
> I really like 'blocking/preempted' indication and of course I miss
> pointers decoding.
 
> Did anyone really think about decoding pointers and how we can
> implement it (like dumping them upon entering a syscall and then
> using inside the perf trace?)?

Hey, haven't you seen the vfs_getname probe? Idea is to hook on where
the relevant copy_from_user is done and insert that into the ring
buffer, as we already do for mapping fd -> pathname.

Right now it is too simple, but I was starting to work (when you jumped
right in with your work making me stop and go on testing/reviewing :) )
on making it more generic so that we could defer pretty printing the
arguments from sys_enter to sys_exit, when, by then, we would already
have an association of a user level pointer in some specific thread to
its contents.

This will allow us to to resolve the pathname pointer in things like
open() (i.e. not just after that, in the fd syscalls (write, etc)) and
as well any other pointer of interest.

By librarizing 'builtin-probe.c', that now uses lots of global
variables, etc, we would be able to insert probes where we want them to
capture the contents of pointers, check if the probes are already in
place, use just the ones that we managed to insert (i.e. that were not
invalid because the places where we wanted them to be were changed
across kernel releases, etc).

I.e. no need for actual tracepoints from day one, just wannabe
tracepoints using whatever probe inserting gizmo the kprobes_tracer used
by 'perf probe' now thinks its best to use.

Combine that with using DWARF descriptions (that could be pre cached
into something like CTF (the DTrace kind of CTF) or similar) like pahole
does and we would mostly automatically do all this work of prettyfing
syscall parameters.

</handwave>

:-)

For now try:

  perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
  trace

And look at how it manages to decode fds.

- Arnaldo
