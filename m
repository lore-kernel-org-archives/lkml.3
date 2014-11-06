Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKFFsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:48:19 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:52428 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846AbaKFFsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:48:14 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="42940965"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Richard Weinberger <richard@nod.at>, "Serge E. Hallyn" <serge@hallyn.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        "David Howells" <dhowells@redhat.com>
Subject: RE: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
Thread-Index: AQHP+Pc/qGDYtmaBZEefvR6LuiiBNpxS8tMw
Date: Thu, 6 Nov 2014 05:48:09 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E61F2B2@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
 <545A13DA.3090207@nod.at> <20141105124111.GA19563@mail.hallyn.com>
 <545A1D53.3070507@nod.at>
In-Reply-To: <545A1D53.3070507@nod.at>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA65mO7x000332



> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Wednesday, November 05, 2014 8:52 PM
> To: Serge E. Hallyn
> Cc: Chen, Hanxiao/³Â êÏÏö; Eric W. Biederman; Serge Hallyn; Oleg Nesterov;
> containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Mateusz
> Guzik; David Howells
> Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
> 
> Am 05.11.2014 um 13:41 schrieb Serge E. Hallyn:
> > Quoting Richard Weinberger (richard@nod.at):
> >> Am 05.11.2014 um 11:41 schrieb Chen Hanxiao:
> >>> We lack of pid hierarchy information, and this will lead to:
> >>> a) we don't know pids' relationship, who is whose child:
> >>>    /proc/PID/ns/pid only tell us whether two pids live in different ns
> >>> b) bring trouble to nested lxc container check/restore/migration
> >>> c) bring trouble to pid translation between containers;
> >>>
> >>> This patch will show the hierarchy of pid namespace
> >>> by pidns_hierarchy like:
> >>>
> >>> [root@localhost ~]#cat /proc/pidns_hierarchy
> >>> 18060 18102 1534
> >>> 18060 18102 1600
> >>> 1550
> >>
> >> Hmm, what about printing the pid hierarchy in the same way as
> /proc/self/mountinfo
> >> does with mount namespaces?
> >> Your current approach is not bad but we should really try to be consistent
> with existing
> >> sources of information.
> >
> > Good point.  How would you structure it to make it look mor elike mountinfo?
> > Adding the pidns inode number (in place of a mount sequence number) might be
> > useful, but it sounds like you have a more concrete idea?
> 
> Just list <init_PID> <parent_of_init_PID>. This way we have exactly one
> information record per line and always exactly two columns to parse.
> 
> e.g.
> [root@localhost ~]#cat /proc/pidns_hierarchy
> 1550 1
> 18060 1
> 18102 18060
> 1534 18102
> 1600 18102
> 
But this style lacks of *level* information:
Ex:
1->18060->18102->1600->1700
If we want to check the 1700's level in pid ns
Style 1:
18060 18102 1600 1700

Style 2:
18060 1
18102 18060
1600 18102
1700 1600

If we had a little more containers,
Style 2 would not be clear enough.
1 line vs $(PID level) line

If there were no more related information to show,
I think style 1 looks better.

Thanks,
- Chen

> >> This function allocates memory per PID. If we have lots of PIDs, how does this
> scale?
> >> I'd go so far and say this can be a DoS'able issue if the pidns_hierarchy file
> is opened multiple times...
> >
> > It's not per pid, but per init-pid.  For non-reaper pids he bails and continue
> > through the loop a few lines above.  This still may be DOS-able if users don't
> > have kmem restrictions to prevent a ton of pid namespaces, but then the
> > namespaces themselves will take a lot more memory than the representation here.
> 
> Ah, I've overlooked that fact. If it is per init-pid it is not that bad. :-)
> 
> Thanks,
> //richard
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
