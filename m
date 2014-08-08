Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaHHJaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:30:52 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:18440 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752894AbaHHJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:30:50 -0400
X-IronPort-AV: E=Sophos;i="5.04,287,1406563200"; 
   d="scan'208";a="34365016"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC]Pid conversion between pid namespace
Thread-Topic: [RFC]Pid conversion between pid namespace
Thread-Index: AQHPslpQgLUVwCSfekG8T1zyTBLrppvGVuiw
Date: Fri, 8 Aug 2014 09:30:46 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E577E1A@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140804222044.GJ12438@ubuntumail>
 <5871495633F38949900D2BF2DC04883E57702E@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140807161141.GG18303@ubuntumail>
In-Reply-To: <20140807161141.GG18303@ubuntumail>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s789VANk023278



> -----Original Message-----
> From: Serge Hallyn [mailto:serge.hallyn@ubuntu.com]
> Sent: Friday, August 08, 2014 12:12 AM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„

> > > How much more kernel space does this take up?
> > >
> >
> > Only first process when creating new ns will be add here.
> > So there would not so many items.
> 
> Oh, I see.
> 
> > > Is there an easy way to go from a pid in your own namespace
> > > to its proper node under /proc/nspid?  I.e. if I am interested
> > > in pid 9987, which happens to be pid 5 inside a container in
> > > ns2, and then I want to know what it means when it (pid 9987)
> > > is talking about 'pid 10'.  Is there a link under /proc/9987/
> > > leading to /proc/nspid/ns2/5 ?
> >
> > If you want to query pid 9987, you could:
> > a) readlink /proc/9987/ns/pid
> > b) refer to /proc/nspid/ns$(inum)/ns$(inum)..
> > c) Also the link to the 1st new ns process could be found under ns$(inum).
> 
> This is good.  Let's go with it.

OK

> 
> > Or as what you said above,
> 
> Nah.  Let's not change /proc/PID/ns/pid.
> 
> > > This sure does seem the simplest route.  But it actually still
> > > does not provide us an easy answer to "what does pid 9987 mean
> > > when it talks about pid 10?".
> >
> > Do you mean:
> > init_pid_ns   ns1     ns2
> > 9987            10      5
> > Neither getnspid syscall nor proc/PID/status expansion
> > could answer this without hierarchy information.
> > For users in init_pid_ns, getnspid needs
> > an observer pid live and only live in ns1,
> 
> Yes, good point.  That's a definite disadvantage of getnspid
> compared to your proc approach.
> 
> > or we should call getnspid in ns1.
> > See below for more.
> >
> > >
> > > > 2. Advantage of procfs solution
> > > > a) easy to use:
> > > > getnspid(6, 10) -> (10, 9, 10)
> > > > or
> > > > getnspid(10, ns1_fd, ns0_fd) -> 9
> > > > getnspid(10, ns2_fd, ns0_fd) -> 10
> > > >
> > > > And we could also get it by:
> > > > cat /proc/10/status | grep NSpid:
> > > > NSpid:	10 	9 	10
> > > > ...
> > >
> > > It looks nice, but I'm not convinced it gives us the info we
> > > need.
> > >
> > > It's certainly possible that I've just not thought it through
> > > enough.
> > >
> > > Question: are you proposing this (/proc/pid/status expansion) as an
> > > alternative to /proc/nspid, or are they meant to be complementary?
> > >
> >
> > We want /proc/nspid as a complement for pid translation.
> 
> Ok.
> 
> > Ex:
> >     init_pid_ns     ns1         ns2
> > t1  2
> > t2   `- 3           1
> > t3       `- 4       `- 5        1
> > t4           `-6        `-8      `-9
> > t5             `-10        `-9      `-10
> > Suppose we were in init_pid_ns:
> > getnspid(9,4)->6 (t4)
> > getnspid(9,3)->10(t5)
> > We knew t2 in ns1 and t3 in ns2, but we don't know their relationship.
> > If we want to query pid 9 in ns1, we could use getnspid(9,3)->10(t5)
> > but the pre-requisite is that we know ns2 is the child of ns1.
> 
> I like your proc approach.  Do you have an implementation?

Thanks for your comments.
I'm preparing the pidns hierarchy patch.
It seems that it's not easy to carry it out.

Thanks,
- Chen  
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
