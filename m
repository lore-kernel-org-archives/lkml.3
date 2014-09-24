Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaIXO3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:29:30 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:65235 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaIXO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:29:29 -0400
MIME-Version: 1.0
In-Reply-To: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
Date: Wed, 24 Sep 2014 18:29:27 +0400
Message-ID: <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
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

The problem is in a following commit:

commit 0c7bf3e8cab7900e17ce7f97104c39927d835469
Author: Zefan Li <lizefan@huawei.com>
Date:   Sat Sep 20 14:49:10 2014 +0800

    cgroup: remove redundant variable in cgroup_mount()

    Both pinned_sb and new_sb indicate if a new superblock is needed,
    so we can just remove new_sb.

    Note now we must check if kernfs_tryget_sb() returns NULL, because
    when it returns NULL, kernfs_mount() may still re-use an existing
    superblock, which is just allocated by another concurent mount.

    Suggested-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Zefan Li <lizefan@huawei.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

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
>
> Thanks,
> Andrew
