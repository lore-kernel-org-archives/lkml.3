Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaFYOiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:38:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaFYOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:38:49 -0400
Date: Wed, 25 Jun 2014 14:38:31 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Weinberger <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2] ns: introduce getnspid syscall
Message-ID: <20140625143831.GB17169@ubuntumail>
References: <1403259512-10510-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <53A414B2.20108@nod.at>
 <5871495633F38949900D2BF2DC04883E54ECC5@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140623133230.GA31817@mail.hallyn.com>
 <5871495633F38949900D2BF2DC04883E551F09@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5871495633F38949900D2BF2DC04883E551F09@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hi,
> 
> > -----Original Message-----
> > From: Serge E. Hallyn [mailto:serge@hallyn.com]
> > Sent: Monday, June 23, 2014 9:33 PM
> > To: Chen, Hanxiao/陈 晗霄
> > Cc: Richard Weinberger; containers@lists.linux-foundation.org;
> > linux-kernel@vger.kernel.org; Pavel Emelyanov; linux-api@vger.kernel.org;
> > Serge Hallyn; Oleg Nesterov; David Howells; Eric W. Biederman; Al Viro
> > Subject: Re: [PATCH v2] ns: introduce getnspid syscall
> > 
> > > > >
> > > >
> > > > I don't think that adding a new system call for this is a good solution.
> > > > We need a more generic way. I bet people are interested in more than just
> > PID
> > > > numbers.
> > >
> > > Could you please give some hints on how to expand this interface?
> > >
> > > >
> > > > I agree with Eric that a procfs solution is more appropriate.
> > > >
> > >
> > > Procfs is a good solution, but syscall is not bad though.
> > 
> > I might be inclined to agree, except that in this case you are still
> > needing mounted procfs anyway to get the proc/$pid/ns/pid fds.
> > 
> > I'm sorry, I've not been watching this thread, so this probably has been
> > considered and decided against, but I'm going to ask anyway.  Keeping
> > in mind both checkpoint-restart and and introspection for use in a
> > setns'd commend, why not make it
> > 
> > pid_t getnspid(pid_t query_pid, pid_t observer_pid)
> > 
> > which returns the process id of query_pid as seen from observer_pid's
> > pidns?
> > 
> 
> But this could be confused in nested ns.
> 
> Ex:
> (thanks for Pavel's figure)
>     init_pid_ns    ns1         ns2
> t1  2
> t2   `- 3          1 
> t3       `- 4      `- 5        1
> t4  5
> 
> a) getnspid(1, 1):
> We expected it could return t2's pid(2nd 1 as pid

Clearly the passed-in pids should be interpreted as relative
to current's pidns.  There can be no ambiguity at that point,
unless I'm overlooking something.

> such as systemd in init_pid_ns),
> but t3'pid is also an appropriate result.
> We may get more than one returns.
> 
> b) getnspid(5, 1):
> (1st 5 was expected as  pid in ns1)
> t3'pid and t4's pid could both be the answer.
> We could not determine which one is what we want.
> 
> So something unique like fds of ns should be
> a better reference. 
> 
> Thanks,
> - Chen
> 
> > 
> > > Procfs works for me, but that seems could not fit
> > > Pavel's requirement.
> > > His opinion is that a syscall is a more generic interface
> > > than proc files, and  also very helpful.
> > > And syscall could tell whether a pid lives in a specific pid namespace,
> > > much convenient than procfs.
> > >
> > > Thanks,
> > > - Chen
> > 
> > > _______________________________________________
> > > Containers mailing list
> > > Containers@lists.linux-foundation.org
> > > https://lists.linuxfoundation.org/mailman/listinfo/containers
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
