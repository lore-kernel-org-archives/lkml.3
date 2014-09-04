Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaIDKNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:13:54 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11739 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbaIDKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:13:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,465,1406563200"; 
   d="scan'208";a="35510754"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Vasiliy Kulikov <segooon@gmail.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: RE: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
Thread-Topic: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
Thread-Index: AQHPx3UrNz/1yUBLOUWGMlZ9vPjC6pvwsGyQ
Date: Thu, 4 Sep 2014 10:13:45 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5914D6@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1409740200-26461-3-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20140903124655.GA5578@cachalot>
In-Reply-To: <20140903124655.GA5578@cachalot>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84AE3DL009078

Hi,

> -----Original Message-----
> Hi,
> 
> On Wed, Sep 03, 2014 at 18:29 +0800, Chen Hanxiao wrote:
> > This patch will show the hierarchy of pid namespace
> > under /proc/pidns like:
> > /proc/pidns
> > â”œâ”€â”€ hierarchy
> > â”‚   â”œâ”€â”€ pidns4026532399
> > â”‚   â”‚   â”œâ”€â”€ pidns -> /proc/2863/ns/pid
> > â”‚   â”‚   â””â”€â”€ pidns4026532515
> > â”‚   â”‚       â””â”€â”€ pidns -> /proc/10611/ns/pid
> > â”‚   â””â”€â”€ pidns4026532504
> > â”‚       â””â”€â”€ pidns -> /proc/4450/ns/pid
> > â””â”€â”€ refresh
> 
> Re: this hierarchy:
> 
> 1) I think it is a bit weird that there is a global hierarchy of NSs with
> symlinks to actual NSs located in some random /proc/PID/ns/pid

It will be a symlink to the init process (PID 1) of that ns.
So it could stand for that namespace.

> directories.  It would be better to have a global tree with actual
> directories and process directories would have symlinks to some subdirs
> in this global tree.

Do you mean create symlinks from every /proc/PID/ns/pid to a global tree?
If that, 
a) we need to rebuild this global tree when pid ns changed.
	It would be a burden even if we don't need to know the hierarchy info. 
b) we need to prepare different tree views for different pid ns level.

> 
> 2) The naming can be changed for even more trivial NSs traversal.
> If the hierarchy is as following --
> 
>     hierarchy/
>       pidns1234/
>         pidns
>         children/
>           pidns3456/
>             ...
>           pidns5678/
>             ...
> 
> -- then it is more simple to traverse the tree as child NSs are all
> files in pidnsXXX/children/, not all files of the mask pidns[0-9]+.

Yeh, naming pidns($init_pid_in_ns) is good idea.
IIUC, my current proposal is the same as your opinion,
but free from children dir.

Tree view like your style:
init_pid_ns
       |
--- ns10--
|         |
ns20    ns21
          |
         ns30

And this patch suggested:
hierarchy/
â””â”€â”€ nspid4026532393
    â”œâ”€â”€ nspid -> /proc/4652/ns/pid		--ns10
    â”œâ”€â”€ nspid4026532489
    â”‚Â Â  â””â”€â”€ nspid -> /proc/4701/ns/pid	--ns20
    â””â”€â”€ nspid4026532496	
        â”œâ”€â”€ nspid -> /proc/4706/ns/pid	--ns21
        â””â”€â”€ nspid4026532499
            â””â”€â”€ nspid -> /proc/4714/ns/pid	--ns30


Thanks,
- Chen

> 
> > a) hierarchy dir:
> >   use to show hierarchy infomation using dir and symlinks.
> >   dirs are named as pidns($inum)
> >   a symlink is created under pidns($inum), and linked to
> >   that pid namespace.
> >
> > b) refresh
> >   trigger key.
> >   We need to write sth to /proc/nspid/refresh,
> >   then we could get hierarchy info
> >   under /proc/pidns/hierarchy.
> >
> 
> --
> Vasily
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
