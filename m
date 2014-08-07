Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaHGQMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:12:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59957 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGQMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:12:18 -0400
Date: Thu, 7 Aug 2014 16:11:41 +0000
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
Message-ID: <20140807161141.GG18303@ubuntumail>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140804222044.GJ12438@ubuntumail>
 <5871495633F38949900D2BF2DC04883E57702E@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5871495633F38949900D2BF2DC04883E57702E@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hi,
> 
> > -----Original Message-----
> > From: Serge Hallyn [mailto:serge.hallyn@ubuntu.com]
> > Sent: Tuesday, August 05, 2014 6:21 AM
> > 
> > Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> > > Hi,
> > >
> > > We discussed two ways of pid conversion:
> > > syscall and procfs.
> > >
> > > Both of them could do a pid translation job.
> > > But for ns hierarchy, syscall like:
> > >
> > > pid_t* getnspid(pid_t query_pid, pid_t observer_pid)
> > > or
> > > pid_t getnspid(pid_t query_pid, int query_fd, int ref_fd)
> > >
> > > could not work, we knew a pid lived in one ns, but we
> > 
> > Note I still disagree here. 
> > 
> > > did not know their relationships.
> > > For getting the entire set of pids, both of them can do.
> > >
> > > So using procfs is a better way.
> > >
> > > Ex:
> > >     init_pid_ns     ns1         ns2
> > > t1  2
> > > t2   `- 3           1
> > > t3       `- 4       `- 5        1
> > > t4           `-6        `-8      `-9
> > > t5             `-10        `-9      `-10
> > >
> > > 1. How procfs work:
> > > a) adding a nspid hierarchy  under /proc/ like:
> > > [root@localhost proc]# tree /proc/nspid
> > > /proc/nspid
> > > ├── ns0
> > > │    └── ns1
> > 
> > Are these actually called 'ns1' etc?  Adding a namespace of pid
> > namespace names is a bad thing.
> 
> That's just an example.
> We incline to name it as ns$(inum), 
> like what we did in proc_ns_readlink.
> 
> > 
> > > │       ├── ns2
> > > │       │   └── pid -> /proc/9/ns
> > > │       └── pid -> /proc/4/ns
> > > └── pid -> /proc/1/ns
> > >
> > > We created dirs and add a link to the 1st process of this ns.
> > 
> > How much more kernel space does this take up?
> > 
> 
> Only first process when creating new ns will be add here.
> So there would not so many items.

Oh, I see.

> > Is there an easy way to go from a pid in your own namespace
> > to its proper node under /proc/nspid?  I.e. if I am interested
> > in pid 9987, which happens to be pid 5 inside a container in
> > ns2, and then I want to know what it means when it (pid 9987)
> > is talking about 'pid 10'.  Is there a link under /proc/9987/
> > leading to /proc/nspid/ns2/5 ?
> 
> If you want to query pid 9987, you could:
> a) readlink /proc/9987/ns/pid
> b) refer to /proc/nspid/ns$(inum)/ns$(inum)..
> c) Also the link to the 1st new ns process could be found under ns$(inum).

This is good.  Let's go with it.

> Or as what you said above,

Nah.  Let's not change /proc/PID/ns/pid.

> we could do some change in /proc/PID/ns/pid
> a) when new ns created, we put them under /proc/nspid
> b) create a link from /proc/PID/ns/pid to /proc/nspid/ns$(inum)/pid
> 
> Then we could get a more clear view:
> 1. pidns view
> /proc/nspid
> ├── ns_4026531836	(ns0)
> │  ├─ ns1
> │  │   ├─── ns2
> │  │   └── pid -> pid:[4026531836]
> │  └── pid -> pid:[4026531816]
> └── pid -> pid:[4026531806]
> 
> Then there will be a link under /proc/9987/ns/pid to ns2:
> 2. PID1 live in ns0, PID2 live in ns2
> /proc/PID1/ns/pid->/proc/nspid/ns_4026531806
> 
> /proc/PID2/ns/pid->/proc/nspid/ns_4026531836
> 
> > 
> > > b) expose all sets of pid, pgid, sid and tgid
> > > via expanded /proc/PID/status
> > >       We could get translated IDs from container like:
> > >     NStgid:	6 	8	9
> > >     NSpid:	6 	8 	9
> > >     NSpgid:	6 	8 	9
> > >     NSsid:	6 	1 	0
> > >     (a set of IDs with 3 level of ns)
> > 
> > This sure does seem the simplest route.  But it actually still
> > does not provide us an easy answer to "what does pid 9987 mean
> > when it talks about pid 10?".
> 
> Do you mean:
> init_pid_ns   ns1     ns2
> 9987            10      5
> Neither getnspid syscall nor proc/PID/status expansion
> could answer this without hierarchy information.
> For users in init_pid_ns, getnspid needs
> an observer pid live and only live in ns1,

Yes, good point.  That's a definite disadvantage of getnspid
compared to your proc approach.

> or we should call getnspid in ns1.
> See below for more.
> 
> > 
> > > 2. Advantage of procfs solution
> > > a) easy to use:
> > > getnspid(6, 10) -> (10, 9, 10)
> > > or
> > > getnspid(10, ns1_fd, ns0_fd) -> 9
> > > getnspid(10, ns2_fd, ns0_fd) -> 10
> > >
> > > And we could also get it by:
> > > cat /proc/10/status | grep NSpid:
> > > NSpid:	10 	9 	10
> > > ...
> > 
> > It looks nice, but I'm not convinced it gives us the info we
> > need.
> > 
> > It's certainly possible that I've just not thought it through
> > enough.
> > 
> > Question: are you proposing this (/proc/pid/status expansion) as an
> > alternative to /proc/nspid, or are they meant to be complementary?
> > 
> 
> We want /proc/nspid as a complement for pid translation.

Ok.

> Ex:
>     init_pid_ns     ns1         ns2
> t1  2
> t2   `- 3           1 
> t3       `- 4       `- 5        1
> t4           `-6        `-8      `-9
> t5             `-10        `-9      `-10
> Suppose we were in init_pid_ns:
> getnspid(9,4)->6 (t4)
> getnspid(9,3)->10(t5)
> We knew t2 in ns1 and t3 in ns2, but we don't know their relationship.
> If we want to query pid 9 in ns1, we could use getnspid(9,3)->10(t5)
> but the pre-requisite is that we know ns2 is the child of ns1. 

I like your proc approach.  Do you have an implementation?

-serge
