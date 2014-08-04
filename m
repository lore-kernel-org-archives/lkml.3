Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaHDWVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:21:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHDWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:21:33 -0400
Date: Mon, 4 Aug 2014 22:20:44 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC]Pid conversion between pid namespace
Message-ID: <20140804222044.GJ12438@ubuntumail>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hi,
> 
> We discussed two ways of pid conversion:
> syscall and procfs.
> 
> Both of them could do a pid translation job.
> But for ns hierarchy, syscall like:
> 
> pid_t* getnspid(pid_t query_pid, pid_t observer_pid)
> or
> pid_t getnspid(pid_t query_pid, int query_fd, int ref_fd)
> 
> could not work, we knew a pid lived in one ns, but we

Note I still disagree here.

> did not know their relationships.
> For getting the entire set of pids, both of them can do.
> 
> So using procfs is a better way.
> 
> Ex:
>     init_pid_ns     ns1         ns2
> t1  2
> t2   `- 3           1 
> t3       `- 4       `- 5        1
> t4           `-6        `-8      `-9
> t5             `-10        `-9      `-10
> 
> 1. How procfs work:
> a) adding a nspid hierarchy  under /proc/ like:
> [root@localhost proc]# tree /proc/nspid
> /proc/nspid
> ├── ns0
> │    └── ns1

Are these actually called 'ns1' etc?  Adding a namespace of pid
namespace names is a bad thing.

> │       ├── ns2
> │       │   └── pid -> /proc/9/ns
> │       └── pid -> /proc/4/ns
> └── pid -> /proc/1/ns 
> 
> We created dirs and add a link to the 1st process of this ns.

How much more kernel space does this take up?

Is there an easy way to go from a pid in your own namespace
to its proper node under /proc/nspid?  I.e. if I am interested
in pid 9987, which happens to be pid 5 inside a container in
ns2, and then I want to know what it means when it (pid 9987)
is talking about 'pid 10'.  Is there a link under /proc/9987/
leading to /proc/nspid/ns2/5 ?

> b) expose all sets of pid, pgid, sid and tgid
> via expanded /proc/PID/status
>       We could get translated IDs from container like:
>     NStgid:	6 	8	9 
>     NSpid:	6 	8 	9
>     NSpgid:	6 	8 	9 
>     NSsid:	6 	1 	0
>     (a set of IDs with 3 level of ns)

This sure does seem the simplest route.  But it actually still
does not provide us an easy answer to "what does pid 9987 mean
when it talks about pid 10?".

> 2. Advantage of procfs solution
> a) easy to use:
> getnspid(6, 10) -> (10, 9, 10)
> or
> getnspid(10, ns1_fd, ns0_fd) -> 9
> getnspid(10, ns2_fd, ns0_fd) -> 10
> 
> And we could also get it by:
> cat /proc/10/status | grep NSpid:
> NSpid:	10 	9 	10
> ...

It looks nice, but I'm not convinced it gives us the info we
need.

It's certainly possible that I've just not thought it through
enough.

Question: are you proposing this (/proc/pid/status expansion) as an
alternative to /proc/nspid, or are they meant to be complementary?

> b) hierarchy info:
> We could not get the ns hierarchy info by just one syscall.
> If we had to, it will complicate the interface.

Agreed.  But I'm not sure that's particularly important.

> We could check whether two process had some relations
> via procfs:
> readlink /proc/PID1/ns/pid -> aaa
> readlink /proc/PID2/ns/pid -> bbb
> 
> Then we could check /proc/nspid/nsX/nsY/nsZ 
> and find out their relationship.
> Ex：
> We know t4 live in ns2, 
> readlink /proc/t4/ns/pid -> AAA
> then we refer to /proc/nspid/ and find a same inum AAA under
> /proc/nspid/ns0/ns1/ns2
> Then we knew that t4 have pid 9 in ns2, have pid 8 in ns1.
> 
> Any comments would be warmly welcomed!
> 
> Thanks,
> - Chen
> 
> > -----Original Message-----
> > From: containers-bounces@lists.linux-foundation.org
> > [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of
> > chenhanxiao@cn.fujitsu.com
> > Sent: Wednesday, July 09, 2014 6:34 PM
> > To: Eric W. Biederman (ebiederm@xmission.com); Serge Hallyn
> > (serge.hallyn@ubuntu.com); Oleg Nesterov (oleg@redhat.com); Richard Weinberger
> > (richard@nod.at); Pavel Emelyanov (xemul@parallels.com); Vasily Kulikov
> > (segoon@openwall.com); Gotou, Yasunori/五島 康文; 'Daniel P. Berrange
> > (berrange@redhat.com)'
> > Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> > Subject: RE: [RFC]Pid conversion between pid namespace
> > 
> > Hi,
> > 
> > Let me summarize our discussions of ID conversion by pros/cons:
> > 
> > A) make new system call for translation
> >     A-1) systemcall(ID, NS1, NS2) into (ID).
> >     pros:
> >         - has a reference ns(NS2)
> >           We could get any lower level ID directly.
> > 
> >     cons:
> >         - lack of hierarchy information.
> >           CRIU need hierarchy info for checkpoint/restore in nested containers.
> >         - not easy for debug.
> >           And a lot of tools/libs need be modified.
> > 
> >     A-2) syscall pid_t getnspid(pid_t query_pid, pid_t observer_pid)
> >     pros:
> >         - ns procfs free, easy to use.
> >         We could get rid of mounted ns procfs.
> > 
> >     cons:
> >         - may find multiple results in nested ns.
> >           We wished the new API could tell us the exact answer.
> >           But if getnspid return more than one results will bring trouble to admins,
> >           they had to make another decision.
> >           Or we marked the deepest level for translation as prerequisite.
> > 
> >         -based on current pidns, no reference ns.
> > 
> > B) make/change proc file/directories
> > 	B-1) expand /proc/pid/status
> > 	pros:
> >         - easy to use and to debug
> >         - already had existed interface in kernel
> > 
> > 	cons:
> >         - based on current ns
> >           for middle level, we had to make another decision.
> >         - do not have hierarchy info.
> > 
> > 	B-2) /proc/<pidX>/ns/proc/ which would contain everything
> > 	pros:
> >         - have enough info from /proc in container
> > 
> > 	cons:
> >         - Requirements unclear.
> >           We need more discussion to decide which items should not be exposed.
> >         - do not have hierarchy info.
> > 
> > 
> > How about do these things in two steps:
> > 
> > C)  1. expose all sets of pid, pgid, sid and tgid
> > via expanded /proc/PID/status
> >       We could get translated IDs from container like:
> >     NStgid:	16465 	5 	1
> >     NSpid:	16465 	5 	1
> >     NSpgid:	16465 	5 	1
> >     NSsid:	16423 	1 	0
> >     (a set of IDs with 3 level of ns)
> > 
> >     2. add hierarchy info under /proc
> >       We lacked of method of getting hierarchy info, which is useful.
> >       Then we could know the relationship of ns.
> >       How about adding a new proc file just under /proc
> >       to show the hierarchy like readlink did:
> > 	  pid:[4026531836]-> [4026532390] -> [4026532484]
> >       pid:[4026531836]-> [4026532491]
> >       (A 3 level pid and 2 level pid_
> > 
> > Any comments would be appreciated.
> > 
> > Thanks,
> > - Chen
> > 
> > > -----Original Message-----
> > > Subject: [RFC]Pid conversion between pid namespace
> > >
> > > Hi,
> > >
> > > We had some discussions on how to carry out
> > > pid conversion between pid namespace via:
> > > syscall[1] and procfs[2].
> > >
> > > Pavel suggested that a syscall like
> > > (ID, NS1, NS2) into (ID).
> > >
> > > Serge suggested that a syscall
> > > pid_t getnspid(pid_t query_pid, pid_t observer_pid).
> > >
> > >
> > > Eric and Richard suggested a procfs solution is
> > > more appropriate.
> > >
> > > Oleg suggested that we should expand /proc/pid/status
> > > to report this kind of information.
> > >
> > > And Richard suggested adding a directory like
> > > /proc/<pidX>/ns/proc/ which would contain everything
> > > from /proc/<pidX inside the namespace>/.
> > >
> > > As procfs provided a more user friendly interface,
> > > how about expose all sets of tgid, pid, pgid, sid
> > > by expanding /proc/PID/status in procfs?
> > > And we could also expose ns hierarchy under /proc,
> > > which could be another reference.
> > >
> > > Ex:
> > >     init_pid_ns    ns1         ns2
> > > t1  2
> > > t2   `- 3          1
> > > t3       `- 4      `- 5        1
> > >
> > > We could get in /proc/t3/status:
> > > NSpid: 4 5 1
> > > We knew that pid 1 in container is pid 4 in init ns.
> > >
> > > And we could get ns hierarchy under /proc/ns_hierarchy like:
> > > init_ns->ns1->ns2		(as the result of readlink)
> > >          ->ns3
> > > We knew that t3 in ns2, and its hierarchy.
> > >
> > > How these ideas looks like?
> > > Any comments would be appreciated.
> > >
> > > Thanks,
> > > - Chen
> > >
> > >
> > > a) syscall
> > > http://lwn.net/Articles/602987/
> > >
> > > b) procfs
> > > http://www.spinics.net/lists/kernel/msg1751688.html
> > >
> > > _______________________________________________
> > > Containers mailing list
> > > Containers@lists.linux-foundation.org
> > > https://lists.linuxfoundation.org/mailman/listinfo/containers
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/containers

> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers

