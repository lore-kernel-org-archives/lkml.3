Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbaGYKBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:01:51 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:41328 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbaGYKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:01:49 -0400
X-IronPort-AV: E=Sophos;i="5.00,961,1396972800"; 
   d="scan'208";a="33777908"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Serge Hallyn (serge.hallyn@ubuntu.com)" <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC]Pid conversion between pid namespace
Thread-Topic: [RFC]Pid conversion between pid namespace
Thread-Index: Ac+WpagelAqWSmeOTWy8zWQgFaQt9gEpMoTAAydZYhA=
Date: Fri, 25 Jul 2014 10:01:45 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
In-Reply-To: <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6PA1v9n031715

Hi,

We discussed two ways of pid conversion:
syscall and procfs.

Both of them could do a pid translation job.
But for ns hierarchy, syscall like:

pid_t* getnspid(pid_t query_pid, pid_t observer_pid)
or
pid_t getnspid(pid_t query_pid, int query_fd, int ref_fd)

could not work, we knew a pid lived in one ns, but we
did not know their relationships.
For getting the entire set of pids, both of them can do.

So using procfs is a better way.

Ex:
    init_pid_ns     ns1         ns2
t1  2
t2   `- 3           1 
t3       `- 4       `- 5        1
t4           `-6        `-8      `-9
t5             `-10        `-9      `-10

1. How procfs work:
a) adding a nspid hierarchy  under /proc/ like:
[root@localhost proc]# tree /proc/nspid
/proc/nspid
©À©¤©¤ ns0
©¦    ©¸©¤©¤ ns1
©¦       ©À©¤©¤ ns2
©¦       ©¦   ©¸©¤©¤ pid -> /proc/9/ns
©¦       ©¸©¤©¤ pid -> /proc/4/ns
©¸©¤©¤ pid -> /proc/1/ns 

We created dirs and add a link to the 1st process of this ns.

b) expose all sets of pid, pgid, sid and tgid
via expanded /proc/PID/status
      We could get translated IDs from container like:
    NStgid:	6 	8	9 
    NSpid:	6 	8 	9
    NSpgid:	6 	8 	9 
    NSsid:	6 	1 	0
    (a set of IDs with 3 level of ns)

2. Advantage of procfs solution
a) easy to use:
getnspid(6, 10) -> (10, 9, 10)
or
getnspid(10, ns1_fd, ns0_fd) -> 9
getnspid(10, ns2_fd, ns0_fd) -> 10

And we could also get it by:
cat /proc/10/status | grep NSpid:
NSpid:	10 	9 	10
...

b) hierarchy info:
We could not get the ns hierarchy info by just one syscall.
If we had to, it will complicate the interface.

We could check whether two process had some relations
via procfs:
readlink /proc/PID1/ns/pid -> aaa
readlink /proc/PID2/ns/pid -> bbb

Then we could check /proc/nspid/nsX/nsY/nsZ 
and find out their relationship.
Ex£º
We know t4 live in ns2, 
readlink /proc/t4/ns/pid -> AAA
then we refer to /proc/nspid/ and find a same inum AAA under
/proc/nspid/ns0/ns1/ns2
Then we knew that t4 have pid 9 in ns2, have pid 8 in ns1.

Any comments would be warmly welcomed!

Thanks,
- Chen

> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of
> chenhanxiao@cn.fujitsu.com
> Sent: Wednesday, July 09, 2014 6:34 PM
> To: Eric W. Biederman (ebiederm@xmission.com); Serge Hallyn
> (serge.hallyn@ubuntu.com); Oleg Nesterov (oleg@redhat.com); Richard Weinberger
> (richard@nod.at); Pavel Emelyanov (xemul@parallels.com); Vasily Kulikov
> (segoon@openwall.com); Gotou, Yasunori/Îåu ¿µÎÄ; 'Daniel P. Berrange
> (berrange@redhat.com)'
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: RE: [RFC]Pid conversion between pid namespace
> 
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
>           they had to make another decision.
>           Or we marked the deepest level for translation as prerequisite.
> 
>         -based on current pidns, no reference ns.
> 
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
