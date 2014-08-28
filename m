Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaH1NuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:50:00 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:56164
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaH1Nt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:49:59 -0400
Date: Thu, 28 Aug 2014 15:49:57 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>
Subject: Re: [RFC]Pid conversion between pid namespace
Message-ID: <20140828134957.GA6047@mail.hallyn.com>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140804222044.GJ12438@ubuntumail>
 <5871495633F38949900D2BF2DC04883E57702E@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140807161141.GG18303@ubuntumail>
 <5871495633F38949900D2BF2DC04883E577E1A@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5871495633F38949900D2BF2DC04883E577E1A@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> 
> 
> > -----Original Message-----
> > From: Serge Hallyn [mailto:serge.hallyn@ubuntu.com]
> > Sent: Friday, August 08, 2014 12:12 AM
> > To: Chen, Hanxiao/陈 晗霄
> 
> > > > How much more kernel space does this take up?
> > > >
> > >
> > > Only first process when creating new ns will be add here.
> > > So there would not so many items.
> > 
> > Oh, I see.
> > 
> > > > Is there an easy way to go from a pid in your own namespace
> > > > to its proper node under /proc/nspid?  I.e. if I am interested
> > > > in pid 9987, which happens to be pid 5 inside a container in
> > > > ns2, and then I want to know what it means when it (pid 9987)
> > > > is talking about 'pid 10'.  Is there a link under /proc/9987/
> > > > leading to /proc/nspid/ns2/5 ?
> > >
> > > If you want to query pid 9987, you could:
> > > a) readlink /proc/9987/ns/pid
> > > b) refer to /proc/nspid/ns$(inum)/ns$(inum)..
> > > c) Also the link to the 1st new ns process could be found under ns$(inum).
> > 
> > This is good.  Let's go with it.
> 
> OK
> 
> > 
> > > Or as what you said above,
> > 
> > Nah.  Let's not change /proc/PID/ns/pid.
> > 
> > > > This sure does seem the simplest route.  But it actually still
> > > > does not provide us an easy answer to "what does pid 9987 mean
> > > > when it talks about pid 10?".
> > >
> > > Do you mean:
> > > init_pid_ns   ns1     ns2
> > > 9987            10      5
> > > Neither getnspid syscall nor proc/PID/status expansion
> > > could answer this without hierarchy information.
> > > For users in init_pid_ns, getnspid needs
> > > an observer pid live and only live in ns1,
> > 
> > Yes, good point.  That's a definite disadvantage of getnspid
> > compared to your proc approach.
> > 
> > > or we should call getnspid in ns1.
> > > See below for more.
> > >
> > > >
> > > > > 2. Advantage of procfs solution
> > > > > a) easy to use:
> > > > > getnspid(6, 10) -> (10, 9, 10)
> > > > > or
> > > > > getnspid(10, ns1_fd, ns0_fd) -> 9
> > > > > getnspid(10, ns2_fd, ns0_fd) -> 10
> > > > >
> > > > > And we could also get it by:
> > > > > cat /proc/10/status | grep NSpid:
> > > > > NSpid:	10 	9 	10
> > > > > ...
> > > >
> > > > It looks nice, but I'm not convinced it gives us the info we
> > > > need.
> > > >
> > > > It's certainly possible that I've just not thought it through
> > > > enough.
> > > >
> > > > Question: are you proposing this (/proc/pid/status expansion) as an
> > > > alternative to /proc/nspid, or are they meant to be complementary?
> > > >
> > >
> > > We want /proc/nspid as a complement for pid translation.
> > 
> > Ok.
> > 
> > > Ex:
> > >     init_pid_ns     ns1         ns2
> > > t1  2
> > > t2   `- 3           1
> > > t3       `- 4       `- 5        1
> > > t4           `-6        `-8      `-9
> > > t5             `-10        `-9      `-10
> > > Suppose we were in init_pid_ns:
> > > getnspid(9,4)->6 (t4)
> > > getnspid(9,3)->10(t5)
> > > We knew t2 in ns1 and t3 in ns2, but we don't know their relationship.
> > > If we want to query pid 9 in ns1, we could use getnspid(9,3)->10(t5)
> > > but the pre-requisite is that we know ns2 is the child of ns1.
> > 
> > I like your proc approach.  Do you have an implementation?
> 
> Thanks for your comments.
> I'm preparing the pidns hierarchy patch.
> It seems that it's not easy to carry it out.

:)  Not entirely surprised.

Please do send patches earlier rather than later to avoid going
down a path that someone's going to nack anyway.
