Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaFZKUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:20:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:8509 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752833AbaFZKUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:20:01 -0400
X-IronPort-AV: E=Sophos;i="5.00,783,1396972800"; 
   d="scan'208";a="32469776"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Weinberger <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "David Howells" <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: RE: [PATCH v2] ns: introduce getnspid syscall
Thread-Topic: [PATCH v2] ns: introduce getnspid syscall
Thread-Index: AQHPkIMqQ7HRAwalz0mhvC9yA+uFmZuDJGXg
Date: Thu, 26 Jun 2014 10:19:55 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5538AC@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403259512-10510-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <53A414B2.20108@nod.at>
 <5871495633F38949900D2BF2DC04883E54ECC5@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140623133230.GA31817@mail.hallyn.com>
 <5871495633F38949900D2BF2DC04883E551F09@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140625143831.GB17169@ubuntumail>
In-Reply-To: <20140625143831.GB17169@ubuntumail>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5QAKKWH016643



> -----Original Message-----
> From: Serge Hallyn [mailto:serge.hallyn@ubuntu.com]
> Sent: Wednesday, June 25, 2014 10:39 PM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„
> Cc: Serge E. Hallyn; Eric W. Biederman; Richard Weinberger;
> containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Oleg
> Nesterov; David Howells; Al Viro; linux-api@vger.kernel.org
> > > > > >
> > > > >
> > > > > I don't think that adding a new system call for this is a good solution.
> > > > > We need a more generic way. I bet people are interested in more than just
> > > PID
> > > > > numbers.
> > > >
> > > > Could you please give some hints on how to expand this interface?
> > > >
> > > > >
> > > > > I agree with Eric that a procfs solution is more appropriate.
> > > > >
> > > >
> > > > Procfs is a good solution, but syscall is not bad though.
> > >
> > > I might be inclined to agree, except that in this case you are still
> > > needing mounted procfs anyway to get the proc/$pid/ns/pid fds.
> > >
> > > I'm sorry, I've not been watching this thread, so this probably has been
> > > considered and decided against, but I'm going to ask anyway.  Keeping
> > > in mind both checkpoint-restart and and introspection for use in a
> > > setns'd commend, why not make it
> > >
> > > pid_t getnspid(pid_t query_pid, pid_t observer_pid)
> > >
> > > which returns the process id of query_pid as seen from observer_pid's
> > > pidns?
> > >
> >
> > But this could be confused in nested ns.
> >
> > Ex:
> > (thanks for Pavel's figure)
> >     init_pid_ns    ns1         ns2
> > t1  2
> > t2   `- 3          1
> > t3       `- 4      `- 5        1
> > t4  5
> >
> > a) getnspid(1, 1):
> > We expected it could return t2's pid(2nd 1 as pid
> 
> Clearly the passed-in pids should be interpreted as relative
> to current's pidns.  There can be no ambiguity at that point,
> unless I'm overlooking something.
> 

Default to current's pidns looks reasonable.
But nested namespace will still bring trouble to us.
Since the middle level of namespace looks less attractive to users,
how about ignore them, and just show the deepest level's pid?

Ex:
(Thanks for Pavel's figure again)
    init_pid_ns    ns1         ns2
t1  2
t2   `- 3          1
t3       `- 4      `- 5        1
t4           `- 5       `-7      `- 2

1. In init_pid_ns:
a) getnspid(2, 1):
returns 2 (t1)

b) getnspid(1, 3):
returns 3 (t2)

c) getnspid(1, 4):
returns 4 (t3)

getnspid(2, 4):
returns 5 (t3)

2. In ns1
a) getnspid(2, 5):
returns 7 (t4)

How do you like this idea?

Thanks,
- Chen

> > such as systemd in init_pid_ns),
> > but t3'pid is also an appropriate result.
> > We may get more than one returns.
> >
> > b) getnspid(5, 1):
> > (1st 5 was expected as  pid in ns1)
> > t3'pid and t4's pid could both be the answer.
> > We could not determine which one is what we want.
> >
> > So something unique like fds of ns should be
> > a better reference.
> >
> > Thanks,
> > - Chen
> >
> > >
> > > > Procfs works for me, but that seems could not fit
> > > > Pavel's requirement.
> > > > His opinion is that a syscall is a more generic interface
> > > > than proc files, and  also very helpful.
> > > > And syscall could tell whether a pid lives in a specific pid namespace,
> > > > much convenient than procfs.
> > > >
> > > > Thanks,
> > > > - Chen
> > >
> > > > _______________________________________________
> > > > Containers mailing list
> > > > Containers@lists.linux-foundation.org
> > > > https://lists.linuxfoundation.org/mailman/listinfo/containers
> >
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/containers
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
