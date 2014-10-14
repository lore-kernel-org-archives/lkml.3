Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaJNWnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:43:35 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55945 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaJNWnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:43:18 -0400
MIME-Version: 1.0
In-Reply-To: <1413235430-22944-1-git-send-email-adityakali@google.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 15:42:55 -0700
Message-ID: <CALCETrVnjrBt3odufhAirf45_REq-S9T=HpoEWqmFef2M6PucA@mail.gmail.com>
Subject: Re: [PATCHv1 0/8] CGroup Namespaces
To: Aditya Kali <adityakali@google.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        jnagal@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 2:23 PM, Aditya Kali <adityakali@google.com> wrote:
> Second take at the Cgroup Namespace patch-set.
>
> Major changes form RFC (V0):
> 1. setns support for cgroupns
> 2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
>    mounts the cgroup hierarcy with cgroupns-root as the filesystem root.
> 3. writes to cgroup files outside of cgroupns-root are not allowed
> 4. visibility of /proc/<pid>/cgroup is further restricted by not showing
>    anything if the <pid> is in a sibling cgroupns and its cgroup falls outside
>    your cgroupns-root.
>
> More details in the writeup below.
>
> Background
>   Cgroups and Namespaces are used together to create “virtual”
>   containers that isolates the host environment from the processes
>   running in container. But since cgroups themselves are not
>   “virtualized”, the task is always able to see global cgroups view
>   through cgroupfs mount and via /proc/self/cgroup file.
>
>   $ cat /proc/self/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1
>
>   This exposure of cgroup names to the processes running inside a
>   container results in some problems:
>   (1) The container names are typically host-container-management-agent
>       (systemd, docker/libcontainer, etc.) data and leaking its name (or
>       leaking the hierarchy) reveals too much information about the host
>       system.
>   (2) It makes the container migration across machines (CRIU) more
>       difficult as the container names need to be unique across the
>       machines in the migration domain.
>   (3) It makes it difficult to run container management tools (like
>       docker/libcontainer, lmctfy, etc.) within virtual containers
>       without adding dependency on some state/agent present outside the
>       container.
>
>   Note that the feature proposed here is completely different than the
>   “ns cgroup” feature which existed in the linux kernel until recently.
>   The ns cgroup also attempted to connect cgroups and namespaces by
>   creating a new cgroup every time a new namespace was created. It did
>   not solve any of the above mentioned problems and was later dropped
>   from the kernel. Incidentally though, it used the same config option
>   name CONFIG_CGROUP_NS as used in my prototype!
>
> Introducing CGroup Namespaces
>   With unified cgroup hierarchy
>   (Documentation/cgroups/unified-hierarchy.txt), the containers can now
>   have a much more coherent cgroup view and its easy to associate a
>   container with a single cgroup. This also allows us to virtualize the
>   cgroup view for tasks inside the container.
>
>   The new CGroup Namespace allows a process to “unshare” its cgroup
>   hierarchy starting from the cgroup its currently in.
>   For Ex:
>   $ cat /proc/self/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1
>   $ ls -l /proc/self/ns/cgroup
>   lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
>   $ ~/unshare -c  # calls unshare(CLONE_NEWCGROUP) and exec’s /bin/bash
>   [ns]$ ls -l /proc/self/ns/cgroup
>   lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup ->
>   cgroup:[4026532183]
>   # From within new cgroupns, process sees that its in the root cgroup
>   [ns]$ cat /proc/self/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>
>   # From global cgroupns:
>   $ cat /proc/<pid>/cgroup
>   0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1
>
>   # Unshare cgroupns along with userns and mountns
>   # Following calls unshare(CLONE_NEWCGROUP|CLONE_NEWUSER|CLONE_NEWNS), then
>   # sets up uid/gid map and exec’s /bin/bash
>   $ ~/unshare -c -u -m
>
>   # Originally, we were in /batchjobs/c_job_id1 cgroup. Mount our own cgroup
>   # hierarchy.
>   [ns]$ mount -t cgroup cgroup /tmp/cgroup
>   [ns]$ ls -l /tmp/cgroup
>   total 0
>   -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
>   -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
>   -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
>   -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control
>
>   The cgroupns-root (/batchjobs/c_job_id1 in above example) becomes the
>   filesystem root for the namespace specific cgroupfs mount.
>
>   The virtualization of /proc/self/cgroup file combined with restricting
>   the view of cgroup hierarchy by namespace-private cgroupfs mount
>   should provide a completely isolated cgroup view inside the container.
>
>   In its current form, the cgroup namespaces patcheset provides following
>   behavior:
>
>   (1) The “root” cgroup for a cgroup namespace is the cgroup in which
>       the process calling unshare is running.
>       For ex. if a process in /batchjobs/c_job_id1 cgroup calls unshare,
>       cgroup /batchjobs/c_job_id1 becomes the cgroupns-root.
>       For the init_cgroup_ns, this is the real root (“/”) cgroup
>       (identified in code as cgrp_dfl_root.cgrp).
>
>   (2) The cgroupns-root cgroup does not change even if the namespace
>       creator process later moves to a different cgroup.
>       $ ~/unshare -c # unshare cgroupns in some cgroup
>       [ns]$ cat /proc/self/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>       [ns]$ mkdir sub_cgrp_1
>       [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
>       [ns]$ cat /proc/self/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>
>   (3) Each process gets its CGROUPNS specific view of
>       /proc/<pid>/cgroup.
>   (a) Processes running inside the cgroup namespace will be able to see
>       cgroup paths (in /proc/self/cgroup) only inside their root cgroup
>       [ns]$ sleep 100000 &  # From within unshared cgroupns
>       [1] 7353
>       [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
>       [ns]$ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
>
>   (b) From global cgroupns, the real cgroup path will be visible:
>       $ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1/sub_cgrp_1

This is a little weird.  Not sure it's a problem.

>
>   (c) From a sibling cgroupns (cgroupns root-ed at a sibling cgroup), no cgroup
>       path will be visible:
>       # ns2's cgroupns-root is at '/batchjobs/c_job_id2'
>       [ns2]$ cat /proc/7353/cgroup
>       [ns2]$
>       This is same as when cgroup hierarchy is not mounted at all.
>       (In correct container setup though, it should not be possible to
>        access PIDs in another container in the first place.)
>
>   (4) Processes inside a cgroupns are not allowed to move out of the
>       cgroupns-root. This is true even if a privileged process in global
>       cgroupns tries to move the process out of its cgroupns-root.
>
>       # From global cgroupns
>       $ cat /proc/7353/cgroup
>       0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1/sub_cgrp_1
>       # cgroupns-root for 7353 is /batchjobs/c_job_id1
>       $ echo 7353 > batchjobs/c_job_id2/cgroup.procs
>       -bash: echo: write error: Operation not permitted
>

>
>   (6) When some thread from a multi-threaded process unshares its
>       cgroup-namespace, the new cgroupns gets applied to the entire
>       process (all the threads). This should be OK since
>       unified-hierarchy only allows process-level containerization. So
>       all the threads in the process will have the same cgroup. And both
>       - changing cgroups and unsharing namespaces - are protected under
>       threadgroup_lock(task).

This seems odd to me.  Does unsharing the cgroupns unshare for all
tasks in the process?  If not, then I think that it shouldn't change
the cgroup either.

What did you end up doing to grant permission to unshare the cgroup ns?

--Andy
