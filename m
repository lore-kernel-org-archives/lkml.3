Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840Ab3FSVhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:37:51 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:57827 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934987Ab3FSVhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:37:48 -0400
Date: Thu, 20 Jun 2013 01:35:32 +0400
From: Andrey Wagin <avagin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] [RFC] mnt: restrict a number of "struct mnt"
Message-ID: <20130619213532.GA31165@gmail.com>
References: <1371457498-27241-1-git-send-email-avagin@openvz.org>
 <878v284iif.fsf@xmission.com>
 <CANaxB-zvPMZe932nAeyOCbdHmmXa76f12BRv0X0W7F0ULZMkTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <CANaxB-zvPMZe932nAeyOCbdHmmXa76f12BRv0X0W7F0ULZMkTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:56:51AM +0400, Andrey Wagin wrote:
> 2013/6/17 Eric W. Biederman <ebiederm@xmission.com>:
> > So for anyone seriously worried about this kind of thing in general we
> > already have the memory control group, which is quite capable of
> > limiting this kind of thing,
> 
> > and it limits all memory allocations not just mount.
> 
> And that is problem, we can't to limit a particular slab. Let's
> imagine a real container with 4Gb of RAM. What is a kernel memory
> limit resonable for it? I setup 64 Mb (it may be not enough for real
> CT, but it's enough to make host inaccessible for some minutes).
> 
> $ mkdir /sys/fs/cgroup/memory/test
> $ echo $((64 << 20)) > /sys/fs/cgroup/memory/test/memory.kmem.limit_in_bytes
> $ unshare -m
> $ echo $$ > /sys/fs/cgroup/memory/test/tasks
> $ mount --make-rprivate /
> $ mount -t tmpfs xxx /mnt
> $ mount --make-shared /mnt
> $ time bash -c 'set -m; for i in `seq 30`; do mount --bind /mnt
> `mktemp -d /mnt/test.XXXXXX` & done;  for i in `seq 30`; do wait;
> done'
> real 0m23.141s
> user 0m0.016s
> sys 0m22.881s
> 
> While the last script is working, nobody can't to read /proc/mounts or
> mount something. I don't think that users from other containers will
> be glad. This problem is not so significant in compared with umounting
> of this tree.
> 
> $ strace -T umount -l /mnt
> umount("/mnt", MNT_DETACH)              = 0 <548.898244>
> The host is inaccessible, it writes messages about soft lockup in
> kernel log and eats 100% cpu.

Eric, do you agree that
* It is a problem
* Currently we don't have a mechanism to prevent this problem
* We need to find a way to prevent this problem

> 
> 
> >
> > Is there some reason we want to go down the path of adding and tuning
> > static limits all over the kernel?  As opposed to streamlining the memory
> > control group so it is low overhead and everyone that cares can use it?
> 
> The memory control group doesn't help in this case... I need to look
> at this code in more details, maybe we can limit a depth of nested
> mount points.

Complexity of the umount algorithm does not depends on a depth of nested
mounts, it depends on a number of mounts and sometimes complexity is O(n^2).

For example:

	mount -t tmpfs xxx /mnt
	mount --make-shared /mnt

	mkdir /mnt/tmp
	mount -t tmpfs xxx /mnt/tmp
	mkdir /mnt/d

	for ((i = 0; i < $1; i++)); do
		d=`mktemp -d /mnt/d/xxx.XXXXXX`
		mount --bind /mnt/tmp $d || break
	done

	mkdir /mnt/tmp/d
	for ((i = 0; i < $1; i++)); do
		d=`mktemp -d /mnt/tmp/xxx.XXXXXX`
		mount --bind /mnt/tmp/d $d || break
	done

perf data for umount -l /mnt
    29.60%     dbus-daemon  [kernel.kallsyms]        [k] __ticket_spin_lock
               |
               --- __ticket_spin_lock
                   lg_local_lock
                   path_init
                   path_openat
                   do_filp_open
                   do_sys_open
                   SyS_openat
                   system_call_fastpath
                   __openat64_nocancel
                   0x747379732f312d73

    20.20%          umount  [kernel.kallsyms]        [k] propagation_next
                    |
                    --- propagation_next
                       |
                       |--65.35%-- umount_tree
                       |          SyS_umount
                       |          system_call_fastpath
                       |          __umount2
                       |          __libc_start_main
                       |
                        --34.65%-- propagate_umount
                                  umount_tree
                                  SyS_umount
                                  system_call_fastpath
                                  __umount2
                                  __libc_start_main

    17.81%          umount  [kernel.kallsyms]        [k] __lookup_mnt
                    |
                    --- __lookup_mnt
                       |
                       |--82.78%-- propagate_umount
                       |          umount_tree
                       |          SyS_umount
                       |          system_call_fastpath
                       |          __umount2
                       |          __libc_start_main
                       |
                        --17.22%-- umount_tree
                                  SyS_umount
                                  system_call_fastpath
                                  __umount2
                                  __libc_start_main

