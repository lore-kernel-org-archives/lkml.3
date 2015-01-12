Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbbALRCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:02:18 -0500
Received: from service88.mimecast.com ([195.130.217.12]:47236 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbALRCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:02:17 -0500
Date: Mon, 12 Jan 2015 17:02:11 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, vdavydov@parallels.com, hannes@cmpxchg.org,
        Will.Deacon@arm.com, linux-mm@kvack.org, suzuki.poulose@arm.com
Subject: Re: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
Message-ID: <20150112170210.GA1288@e106634-lin.cambridge.arm.com>
References: <54B01335.4060901@arm.com>
 <20150109214649.GF2785@htj.dyndns.org>
MIME-Version: 1.0
In-Reply-To: <20150109214649.GF2785@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MC-Unique: 115011217021500802
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 09:46:49PM +0000, Tejun Heo wrote:
> On Fri, Jan 09, 2015 at 05:43:17PM +0000, Suzuki K. Poulose wrote:
> > We have hit a hang on ARM64 defconfig, while running LTP tests on 3.19-rc3.
> > We are
> > in the process of a git bisect and will update the results as and
> > when we find the commit.
> >
> > During the ksm ltp run, the test hangs trying to mount memcg with the
> > following strace
> > output:
> >
> > mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ? ERESTARTNOINTR (To
> > be restarted)
> > mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ? ERESTARTNOINTR (To
> > be restarted)
> > [ ... repeated forever ... ]
> >
> > At this point, one can try mounting the memcg to verify the problem.
> > # mount -t cgroup -o memory memcg memcg_dir
> > --hangs--
> >
> > Strangely, if we run the mount command from a cold boot (i.e. without
> > running LTP first),
> > then it succeeds.
>
> I don't know what LTP is doing and this could actually be hitting on
> an actual bug but if it's trying to move memcg back from unified
> hierarchy to an old one, that might hang - it should prolly made to
> just fail at that point.  Anyways, any chance you can find out what
> happened, in terms of cgroup mounting, to memcg upto that point?
>

This is what the test(ksm03) does, roughly from strace :

faccessat(AT_FDCWD, "/sys/kernel/mm/ksm/", F_OK) = 0
faccessat(AT_FDCWD, "/sys/kernel/mm/ksm/merge_across_nodes", F_OK) = -1 ENOENT (No such file or directory)
mkdirat(AT_FDCWD, "/dev/cgroup", 0777)  = 0
mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = 0

--- set memory limit. Create a new set /dev/cgroups/1 and moves test to that group ---
mkdirat(AT_FDCWD, "/dev/cgroup/1", 0777) = 0
openat(AT_FDCWD, "/dev/cgroup/1/memory.limit_in_bytes", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
fstat(3, {st_dev=makedev(0, 24), st_ino=41, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, st_atime=2015/01/12-15:10:13, st_mtime=2015/01/12-15:10:13, st_ctime=2015/01/12-15:10:13}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fb2903000
write(3, "1073741824", 10)              = 10
close(3)                                = 0
munmap(0x7fb2903000, 65536)             = 0
getpid()                                = 1324
openat(AT_FDCWD, "/dev/cgroup/1/tasks", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
fstat(3, {st_dev=makedev(0, 24), st_ino=37, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, st_atime=2015/01/12-15:10:13, st_mtime=2015/01/12-15:10:13, st_ctime=2015/01/12-15:10:13}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fb2903000
write(3, "1324", 4)                     = 4
close(3)                                = 0
munmap(0x7fb2903000, 65536)             = 0

clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fb2a7f0d0) = 1325
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fb2a7f0d0) = 1326
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fb2a7f0d0) = 1327

--- Creates 3 children, perform a lot of memory operations with shared pages
    verify the ksm for activity and wait for children to exit ---

wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WSTOPPED|WCONTINUED, NULL) = 1325
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WSTOPPED|WCONTINUED, NULL) = 1326
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WSTOPPED|WCONTINUED, NULL) = 1327
wait4(-1, 0x7fe5625f3c, WSTOPPED|WCONTINUED, NULL) = -1 ECHILD (No child processes)

--- cleanup: Move tasks under /dev/cgroups/1/ to /dev/cgroups/ and delete subdir, umount cgroup ---

faccessat(AT_FDCWD, "/sys/kernel/mm/ksm/merge_across_nodes", F_OK) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/dev/cgroup/tasks", O_WRONLY) = 205
openat(AT_FDCWD, "/dev/cgroup/1/tasks", O_RDONLY) = 206
fstat(206, {st_dev=makedev(0, 24), st_ino=37, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, st_atime=2015/01/12-15:10:13, st_mtime=2015/01/12-15:10:13, st_ctime=2015/01/12-15:10:13}) = 0
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fb1c53000
read(206, "1324\n", 4096)               = 5
write(205, "1324", 4)                   = 4
read(206, "", 4096)                     = 0
close(205)                              = 0
close(206)                              = 0
munmap(0x7fb1c53000, 65536)             = 0
unlinkat(AT_FDCWD, "/dev/cgroup/1", AT_REMOVEDIR) = 0
umount2("/dev/cgroup", 0)               = 0
unlinkat(AT_FDCWD, "/dev/cgroup", AT_REMOVEDIR) = 0
exit_group(0)                           = ?


The next invocation of the same test fails to mount the cgroup memory.

Thanks
Suzuki

> Thanks.
>
> --
> tejun
>

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

