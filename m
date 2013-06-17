Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3FQW4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:56:54 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:46956 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQW4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <878v284iif.fsf@xmission.com>
References: <1371457498-27241-1-git-send-email-avagin@openvz.org>
	<878v284iif.fsf@xmission.com>
Date: Tue, 18 Jun 2013 02:56:51 +0400
Message-ID: <CANaxB-zvPMZe932nAeyOCbdHmmXa76f12BRv0X0W7F0ULZMkTA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] mnt: restrict a number of "struct mnt"
From: Andrey Wagin <avagin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/17 Eric W. Biederman <ebiederm@xmission.com>:
> Andrey Vagin <avagin@openvz.org> writes:
>
>> I found that a few processes can eat all host memory and nobody can kill them.
>> $ mount -t tmpfs xxx /mnt
>> $ mount --make-shared /mnt
>> $ for i in `seq 30`; do mount --bind /mnt `mktemp -d /mnt/test.XXXXXX` & done
>>
>> All this processes are unkillable, because they took i_mutex and waits
>> namespace_lock.
>>
>> ...
>> 21715 pts/0    D      0:00          \_ mount --bind /mnt /mnt/test.ht6jzO
>> 21716 pts/0    D      0:00          \_ mount --bind /mnt /mnt/test.97K4mI
>> 21717 pts/0    R      0:01          \_ mount --bind /mnt /mnt/test.gO2CD9
>> ...
>>
>> Each of this process doubles a number of mounts, so at the end we will
>> have about 2^32 mounts and the size of struct mnt is 256 bytes, so we
>> need about 1TB of RAM.
>>
>> Another problem is that “umount” of a big tree is very hard operation
>> and it requires a lot of time.
>> E.g.:
>> 16411
>> umount("/tmp/xxx", MNT_DETACH)          = 0 <7.852066> (7.8 sec)
>> 32795
>> umount("/tmp/xxx", MNT_DETACH)          = 0 <34.485501> ( 34 sec)
>>
>> For all this time sys_umoun takes namespace_sem and vfsmount_lock...
>>
>> Due to all this reasons I suggest to restrict a number of mounts.
>> Probably we can optimize this code in a future, but now this restriction
>> can help.
>
> So for anyone seriously worried about this kind of thing in general we
> already have the memory control group, which is quite capable of
> limiting this kind of thing,

> and it limits all memory allocations not just mount.

And that is problem, we can't to limit a particular slab. Let's
imagine a real container with 4Gb of RAM. What is a kernel memory
limit resonable for it? I setup 64 Mb (it may be not enough for real
CT, but it's enough to make host inaccessible for some minutes).

$ mkdir /sys/fs/cgroup/memory/test
$ echo $((64 << 20)) > /sys/fs/cgroup/memory/test/memory.kmem.limit_in_bytes
$ unshare -m
$ echo $$ > /sys/fs/cgroup/memory/test/tasks
$ mount --make-rprivate /
$ mount -t tmpfs xxx /mnt
$ mount --make-shared /mnt
$ time bash -c 'set -m; for i in `seq 30`; do mount --bind /mnt
`mktemp -d /mnt/test.XXXXXX` & done;  for i in `seq 30`; do wait;
done'
real 0m23.141s
user 0m0.016s
sys 0m22.881s

While the last script is working, nobody can't to read /proc/mounts or
mount something. I don't think that users from other containers will
be glad. This problem is not so significant in compared with umounting
of this tree.

$ strace -T umount -l /mnt
umount("/mnt", MNT_DETACH)              = 0 <548.898244>
The host is inaccessible, it writes messages about soft lockup in
kernel log and eats 100% cpu.


>
> Is there some reason we want to go down the path of adding and tuning
> static limits all over the kernel?  As opposed to streamlining the memory
> control group so it is low overhead and everyone that cares can use it?

The memory control group doesn't help in this case... I need to look
at this code in more details, maybe we can limit a depth of nested
mount points.
