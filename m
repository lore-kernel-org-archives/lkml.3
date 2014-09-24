Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaIXKbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:31:33 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57753 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaIXKbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:31:08 -0400
MIME-Version: 1.0
Date: Wed, 24 Sep 2014 14:31:06 +0400
Message-ID: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
Subject: linux-next: cgroup_mount() falls asleep forever
From: Andrey Wagin <avagin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I execute CRIU tests on linux-next. Today I found that one of tests
hangs up forever.

[root@linux-next-test linux-next]# git describe HEAD
next-20140922
[root@linux-next-test ~]# ps axf
...
  698 ?        Ss     0:05  \_ sshd: root@notty
  700 ?        Ss     0:00  |   \_ bash -x
jenkins-scripts/jenkins-ct.sh jenkins.sh
  706 ?        S      0:00  |       \_ bash -c ( mount --make-rprivate
/ && umount -l  /proc && mount -t proc proc /proc/ && bash -x
jenkins.sh)
  707 ?        S      0:00  |           \_ bash -c ( mount
--make-rprivate / && umount -l  /proc && mount -t proc proc /proc/ &&
bash -x jenkins.sh)
  711 ?        S      0:00  |               \_ bash -x jenkins.sh
 2981 ?        S      0:05  |                   \_ bash -x
test/zdtm.sh -C -x .*\(maps01\|maps04\)
 6717 ?        S      0:00  |                       \_ /bin/bash
zdtm/live/static/cgroup00.hook --clean
 6719 ?        D     11:13  |                           \_ mount -t
cgroup none cgclean.cWgK71 -o none,name=zdtmtst

[root@linux-next-test ~]# cat /proc/6719/stack
[<ffffffff8111fcb7>] msleep+0x37/0x50
[<ffffffff8114bde2>] cgroup_mount+0x712/0xa50
[<ffffffff8124d0e9>] mount_fs+0x39/0x1b0
[<ffffffff8126d76b>] vfs_kern_mount+0x6b/0x150
[<ffffffff8127075b>] do_mount+0x22b/0xc20
[<ffffffff81271492>] SyS_mount+0xa2/0x110
[<ffffffff817e3ba9>] system_call_fastpath+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

Let me know which info do you need for investigation.

Steps to reproduce:

git clone https://github.com/xemul/criu.git
cd criu
make
bash test/zdtm.sh static/cgroup00

Thanks,
Andrew
