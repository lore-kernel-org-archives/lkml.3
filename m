Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaFWNcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:32:36 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:46286
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaFWNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:32:32 -0400
Date: Mon, 23 Jun 2014 15:32:30 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: Richard Weinberger <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] ns: introduce getnspid syscall
Message-ID: <20140623133230.GA31817@mail.hallyn.com>
References: <1403259512-10510-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <53A414B2.20108@nod.at>
 <5871495633F38949900D2BF2DC04883E54ECC5@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5871495633F38949900D2BF2DC04883E54ECC5@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hi
> 
> > -----Original Message-----
> > From: Richard Weinberger [mailto:richard@nod.at]
> > Sent: Friday, June 20, 2014 7:02 PM
> > To: Chen, Hanxiao/陈 晗霄; containers@lists.linux-foundation.org;
> > linux-kernel@vger.kernel.org
> > Cc: Eric W. Biederman; Serge Hallyn; Daniel P. Berrange; Oleg Nesterov; Al Viro;
> > David Howells; Pavel Emelyanov; Vasiliy Kulikov; Gotou, Yasunori/五島 康文;
> > linux-api@vger.kernel.org
> > Subject: Re: [PATCH v2] ns: introduce getnspid syscall
> > 
> > Am 20.06.2014 12:18, schrieb Chen Hanxiao:
> > > We need a direct method of getting the pid inside containers.
> > > If some issues occurred inside container guest, host user
> > > could not know which process is in trouble just by guest pid:
> > > the users of container guest only knew the pid inside containers.
> > > This will bring obstacle for trouble shooting.
> > >
> > > int getnspid(pid_t pid, int fd1, int fd2);
> > >
> > > pid: the pid number need to be translated.
> > >
> > > fd: a file descriptor referring to one of
> > >     the namespace entries in a /proc/[pid]/ns/pid.
> > >     fd1 for destination ns(ns1), where the pid came from.
> > >     fd2 for reference ns(ns2), while fd2 = -2 means for current ns.
> > >
> > > return value:
> > >     >0 : translated pid in ns1(fd1) seen from ns2(fd2).
> > >     <=0: on failure.
> > >
> > 
> > I don't think that adding a new system call for this is a good solution.
> > We need a more generic way. I bet people are interested in more than just PID
> > numbers.
> 
> Could you please give some hints on how to expand this interface?
> 
> > 
> > I agree with Eric that a procfs solution is more appropriate.
> > 
> 
> Procfs is a good solution, but syscall is not bad though.

I might be inclined to agree, except that in this case you are still
needing mounted procfs anyway to get the proc/$pid/ns/pid fds.

I'm sorry, I've not been watching this thread, so this probably has been
considered and decided against, but I'm going to ask anyway.  Keeping
in mind both checkpoint-restart and and introspection for use in a
setns'd commend, why not make it

pid_t getnspid(pid_t query_pid, pid_t observer_pid)

which returns the process id of query_pid as seen from observer_pid's
pidns?


> Procfs works for me, but that seems could not fit
> Pavel's requirement.
> His opinion is that a syscall is a more generic interface
> than proc files, and  also very helpful.
> And syscall could tell whether a pid lives in a specific pid namespace,
> much convenient than procfs.
> 
> Thanks,
> - Chen

> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers

