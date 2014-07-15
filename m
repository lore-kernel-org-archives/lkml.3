Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaGOERM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:17:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaGOERK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:17:10 -0400
Date: Tue, 15 Jul 2014 04:16:28 +0000
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
Message-ID: <20140715041628.GL1132@ubuntumail>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hi,
> 
> Let me summarize our discussions of ID conversion by pros/cons: 
> 
> A) make new system call for translation	
>     A-1) systemcall(ID, NS1, NS2) into (ID).
>     pros:
>         - has a reference ns(NS2)
>           We could get any lower level ID directly.
> 		 
>     cons:
>         - lack of hierarchy information. 
>           CRIU need hierarchy info for checkpoint/restore in nested containers.
>         - not easy for debug. 
>           And a lot of tools/libs need be modified.
> 
>     A-2) syscall pid_t getnspid(pid_t query_pid, pid_t observer_pid)
>     pros:
>         - ns procfs free, easy to use.
>         We could get rid of mounted ns procfs.
> 
>     cons:
>         - may find multiple results in nested ns.
>           We wished the new API could tell us the exact answer.
>           But if getnspid return more than one results will bring trouble to admins,

(See below for more, but) the question being posed to getnspid has precisely
one answer.

>           they had to make another decision.
>           Or we marked the deepest level for translation as prerequisite.
> 
>         -based on current pidns, no reference ns.

Hm, no.  The intent here was that

	observer_pid would be in current ns
	query_pid would be in observer_pid's ns.

So this would be ideal for "I got a pid in a logfile created by rsyslog in
a nested contaner, what is the logged pid in my pidns."

Taking a set of tasks (like a container with nesting) and bulding a tree
of all pids shouldn't be too difficult either.  Start with the init pid,
call getnspid($pid, $init_pid) for every $pid in the container;  to figure
out whether any $pid is itself a nested init_pid, we can compare the
/proc/$$/ns/pid, as well as look at getnspid($pid, $pid).

> B) make/change proc file/directories
> 	B-1) expand /proc/pid/status
> 	pros:
>         - easy to use and to debug
>         - already had existed interface in kernel
>         
> 	cons:
>         - based on current ns
>           for middle level, we had to make another decision.
>         - do not have hierarchy info.
> 
> 	B-2) /proc/<pidX>/ns/proc/ which would contain everything
> 	pros:
>         - have enough info from /proc in container
> 
> 	cons:
>         - Requirements unclear.
>           We need more discussion to decide which items should not be exposed.
>         - do not have hierarchy info.
> 
> 
> How about do these things in two steps: 
> 
> C)  1. expose all sets of pid, pgid, sid and tgid
> via expanded /proc/PID/status
>       We could get translated IDs from container like:
>     NStgid:	16465 	5 	1 
>     NSpid:	16465 	5 	1 
>     NSpgid:	16465 	5 	1 
>     NSsid:	16423 	1 	0
>     (a set of IDs with 3 level of ns)
> 
>     2. add hierarchy info under /proc
>       We lacked of method of getting hierarchy info, which is useful.
>       Then we could know the relationship of ns.
>       How about adding a new proc file just under /proc
>       to show the hierarchy like readlink did:
> 	  pid:[4026531836]-> [4026532390] -> [4026532484]
>       pid:[4026531836]-> [4026532491]
>       (A 3 level pid and 2 level pid_
> 
> Any comments would be appreciated.
> 
> Thanks,
> - Chen
> 
> > -----Original Message-----
> > Subject: [RFC]Pid conversion between pid namespace
> > 
> > Hi,
> > 
> > We had some discussions on how to carry out
> > pid conversion between pid namespace via:
> > syscall[1] and procfs[2].
> > 
> > Pavel suggested that a syscall like
> > (ID, NS1, NS2) into (ID).
> > 
> > Serge suggested that a syscall
> > pid_t getnspid(pid_t query_pid, pid_t observer_pid).
> > 
> > 
> > Eric and Richard suggested a procfs solution is
> > more appropriate.
> > 
> > Oleg suggested that we should expand /proc/pid/status
> > to report this kind of information.
> > 
> > And Richard suggested adding a directory like
> > /proc/<pidX>/ns/proc/ which would contain everything
> > from /proc/<pidX inside the namespace>/.
> > 
> > As procfs provided a more user friendly interface,
> > how about expose all sets of tgid, pid, pgid, sid
> > by expanding /proc/PID/status in procfs?
> > And we could also expose ns hierarchy under /proc,
> > which could be another reference.
> > 
> > Ex:
> >     init_pid_ns    ns1         ns2
> > t1  2
> > t2   `- 3          1
> > t3       `- 4      `- 5        1
> > 
> > We could get in /proc/t3/status:
> > NSpid: 4 5 1
> > We knew that pid 1 in container is pid 4 in init ns.
> > 
> > And we could get ns hierarchy under /proc/ns_hierarchy like:
> > init_ns->ns1->ns2		(as the result of readlink)
> >          ->ns3
> > We knew that t3 in ns2, and its hierarchy.
> > 
> > How these ideas looks like?
> > Any comments would be appreciated.
> > 
> > Thanks,
> > - Chen
> > 
> > 
> > a) syscall
> > http://lwn.net/Articles/602987/
> > 
> > b) procfs
> > http://www.spinics.net/lists/kernel/msg1751688.html
> > 
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/containers
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
