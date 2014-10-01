Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaJAAWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:22:55 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61048 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJAAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:22:52 -0400
MIME-Version: 1.0
From: Aditya Kali <adityakali@google.com>
Date: Tue, 30 Sep 2014 17:22:32 -0700
Message-ID: <CAGr1F2FPLCfZjMCoLM3h-8okHcJSkdE7et25_TKU-2Xtx03OTg@mail.gmail.com>
Subject: uid=0 inside user-namespace and procfs file permissions
To: Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to run a process with uid=0 inside userns. But in the when
I also do capset() after setresuid(0, 0, 0), I am seeing inconsistent
proc file permissions. Almost all the files in /proc/<pid>/ has global
'root' as owner and group even if the actual process uid is correctly
changed.

I wrote a simple program that demonstrate the issue:

1. parent, as global root (uid=0 in init_user_ns) fork()s a child
2. child:
    a) unshare(CLONE_NEWUSER)
    b) [wait for parent to write uid_map]
    c) setresgid(id, id, id) ; setresuid(0, 0, 0);
    d) conditionally call capset() to clear capabilities
    e) execve(/bin/sleep)
3. parent:
    a) populates child's uid_map and maps some uid to 0 inside userns. ex:
    0 99 1
    b) waitpid()

(the actual program can be found at http://pastebin.com/f4P17VFn for
your reference).

When there is no capset() call after setresuid(0,0,0), everything is
fine. But when I do a capset() to clear all capabilities, the 'owner'
and 'group' of all the files under /proc/<child_pid>/  of the child
process are reverted to global 'root' user.

# without capset (2.d):
root@vm1# id
uid=0(root) gid=0(root) groups=0(root)

root@vm1# ./userns_uid0
child_pid: 24277
proc_file: /proc/24277/uid_map
proc_file: /proc/24277/gid_map
child resuming

^Z
[1]+  Stopped                 ./userns_uid0
root@vm1# cat /proc/24277/uid_map
         0         99          1
root@vm1# cat /proc/24277/status | grep -e "Uid:" -e "Gid:"
Uid: 99 99 99 99
Gid: 99 99 99 99
root@vm1# ls -l /proc/24277/
total 0
dr-xr-xr-x 2 nobody nobody 0 2014-09-30 16:31 attr
-r-------- 1 nobody nobody 0 2014-09-30 16:31 auxv
-r--r--r-- 1 nobody nobody 0 2014-09-30 16:31 cgroup
--w------- 1 nobody nobody 0 2014-09-30 16:31 clear_refs
-r--r--r-- 1 nobody nobody 0 2014-09-30 16:31 cmdline
-rw-r--r-- 1 nobody nobody 0 2014-09-30 16:31 comm
-rw-r--r-- 1 nobody nobody 0 2014-09-30 16:31 coredump_filter
-r--r--r-- 1 nobody nobody 0 2014-09-30 16:31 cpuset
...
[All files have owner='nobody' and group='nobody' .. same as that of
the process]

With the additional capset() call, the files under /proc/<child_pid>/
are now owned by global root:

root@vm1# ./userns_uid0 resetcaps
child_pid: 24706
proc_file: /proc/24706/uid_map
proc_file: /proc/24706/gid_map
child resuming
resetting caps
^Z
[2]+  Stopped                 ./userns_uid0 resetcaps
root@vm1# cat /proc/24706/uid_map
         0         99          1
root@vm1# cat /proc/24706/status | grep -e "Uid:" -e "Gid:"
Uid: 99 99 99 99
Gid: 99 99 99 99

[Everything as before till now]

root@vm1# ls -l /proc/24706/
total 0
dr-xr-xr-x 2 nobody nobody 0 2014-09-30 16:47 attr
-r-------- 1 root   root   0 2014-09-30 16:47 auxv
-r--r--r-- 1 root   root   0 2014-09-30 16:47 cgroup
--w------- 1 root   root   0 2014-09-30 16:47 clear_refs
-r--r--r-- 1 root   root   0 2014-09-30 16:47 cmdline
-rw-r--r-- 1 root   root   0 2014-09-30 16:47 comm
-rw-r--r-- 1 root   root   0 2014-09-30 16:47 coredump_filter
-r--r--r-- 1 root   root   0 2014-09-30 16:47 cpuset
...
-r--r--r-- 1 root   root   0 2014-09-30 16:47 mountinfo
-r--r--r-- 1 root   root   0 2014-09-30 16:47 mounts
-r-------- 1 root   root   0 2014-09-30 16:47 mountstats
dr-xr-xr-x 5 nobody nobody 0 2014-09-30 16:47 net
dr-x--x--x 2 root   root   0 2014-09-30 16:47 ns
-r--r--r-- 1 root   root   0 2014-09-30 16:47 numa_maps
...
-r--r--r-- 1 root   root   0 2014-09-30 16:47 status
-r-------- 1 root   root   0 2014-09-30 16:47 syscall
dr-xr-xr-x 3 nobody nobody 0 2014-09-30 16:47 task
..

Only the directories 'attr', 'net' and 'task' are owned by the uid=99.
Rest all files are owned by global root.

This behavior seems inconsistent. I ran this on 3.17 kernel. Can
someone with expertise in this area explain if this is expected?

Thanks,
-- 
Aditya
