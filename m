Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIXQNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:13:54 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34225 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaIXQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
Date: Wed, 24 Sep 2014 20:13:51 +0400
Message-ID: <CANaxB-xM6NuXaHu443WXCGbUKNqhXg=bNih3zFzr-DrvEfSFag@mail.gmail.com>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
From: Andrey Wagin <avagin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-24 14:31 GMT+04:00 Andrey Wagin <avagin@gmail.com>:
> Hi All,
>
> I execute CRIU tests on linux-next. Today I found that one of tests
> hangs up forever.
>
> [root@linux-next-test linux-next]# git describe HEAD
> next-20140922
> [root@linux-next-test ~]# ps axf
> ...
>   698 ?        Ss     0:05  \_ sshd: root@notty
>   700 ?        Ss     0:00  |   \_ bash -x
> jenkins-scripts/jenkins-ct.sh jenkins.sh
>   706 ?        S      0:00  |       \_ bash -c ( mount --make-rprivate
> / && umount -l  /proc && mount -t proc proc /proc/ && bash -x
> jenkins.sh)
>   707 ?        S      0:00  |           \_ bash -c ( mount
> --make-rprivate / && umount -l  /proc && mount -t proc proc /proc/ &&
> bash -x jenkins.sh)
>   711 ?        S      0:00  |               \_ bash -x jenkins.sh
>  2981 ?        S      0:05  |                   \_ bash -x
> test/zdtm.sh -C -x .*\(maps01\|maps04\)
>  6717 ?        S      0:00  |                       \_ /bin/bash
> zdtm/live/static/cgroup00.hook --clean
>  6719 ?        D     11:13  |                           \_ mount -t
> cgroup none cgclean.cWgK71 -o none,name=zdtmtst
>
> [root@linux-next-test ~]# cat /proc/6719/stack
> [<ffffffff8111fcb7>] msleep+0x37/0x50
> [<ffffffff8114bde2>] cgroup_mount+0x712/0xa50
> [<ffffffff8124d0e9>] mount_fs+0x39/0x1b0
> [<ffffffff8126d76b>] vfs_kern_mount+0x6b/0x150
> [<ffffffff8127075b>] do_mount+0x22b/0xc20
> [<ffffffff81271492>] SyS_mount+0xa2/0x110
> [<ffffffff817e3ba9>] system_call_fastpath+0x12/0x17
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> Let me know which info do you need for investigation.
>
> Steps to reproduce:
>
> git clone https://github.com/xemul/criu.git
> cd criu
> make
> bash test/zdtm.sh static/cgroup00

Steps to reproduce without CRIU:

[root@avagin-fc19-cr ~]# mount -t cgroup -o none,name=zdtmtst xxx /mnt/test/
[root@avagin-fc19-cr ~]# mkdir /mnt/test/xxx
[root@avagin-fc19-cr ~]# umount /mnt/test/
[root@avagin-fc19-cr ~]# mount -t cgroup -o none,name=zdtmtst xxx /mnt/test/
[1]+  Stopped                 mount -t cgroup -o none,name=zdtmtst xxx
/mnt/test/
[root@avagin-fc19-cr ~]# bg
[root@avagin-fc19-cr ~]# cat /proc/633/stack
[<ffffffff810e9377>] msleep+0x37/0x50
[<ffffffff811118a2>] cgroup_mount+0x482/0x670
[<ffffffff811e3769>] mount_fs+0x39/0x1b0
[<ffffffff8120157b>] vfs_kern_mount+0x6b/0x150
[<ffffffff8120422b>] do_mount+0x22b/0xc20
[<ffffffff81204f62>] SyS_mount+0xa2/0x110
[<ffffffff816fcc69>] system_call_fastpath+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

>
> Thanks,
> Andrew
