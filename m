Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbaJaTTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:19:13 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:64994 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaJaTTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:19:10 -0400
From: Aditya Kali <adityakali@google.com>
To: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, ebiederm@xmission.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com
Cc: containers@lists.linux-foundation.org, jnagal@google.com
Subject: [PATCHv2 0/7] CGroup Namespaces
Date: Fri, 31 Oct 2014 12:18:54 -0700
Message-Id: <1414783141-6947-1-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <adityakali-cgroupns>
References: <adityakali-cgroupns>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another attempt at Cgroup Namespace patch-set. This incorporates
suggestions on previous patch-set.

Changes from V1:
1. No pinning of processes within cgroupns. Tasks can be freely moved
   across cgroups even outside of their cgroupns-root. Usual DAC/MAC policies
   apply as before.
2. Path in /proc/<pid>/cgroup is now always shown and is relative to
   cgroupns-root. So path can contain '/..' strings depending on cgroupns-root
   of the reader and cgroup of <pid>.
3. setns() does not require the process to first move under target
   cgroupns-root.

Changes form RFC (V0):
1. setns support for cgroupns
2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
   mounts the cgroup hierarcy with cgroupns-root as the filesystem root.
3. writes to cgroup files outside of cgroupns-root are not allowed
4. visibility of /proc/<pid>/cgroup is further restricted by not showing
   anything if the <pid> is in a sibling cgroupns and its cgroup falls outside
   your cgroupns-root.

More details in the writeup below.

Background
  Cgroups and Namespaces are used together to create “virtual”
  containers that isolates the host environment from the processes
  running in container. But since cgroups themselves are not
  “virtualized”, the task is always able to see global cgroups view
  through cgroupfs mount and via /proc/self/cgroup file.

  $ cat /proc/self/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1

  This exposure of cgroup names to the processes running inside a
  container results in some problems:
  (1) The container names are typically host-container-management-agent
      (systemd, docker/libcontainer, etc.) data and leaking its name (or
      leaking the hierarchy) reveals too much information about the host
      system.
  (2) It makes the container migration across machines (CRIU) more
      difficult as the container names need to be unique across the
      machines in the migration domain.
  (3) It makes it difficult to run container management tools (like
      docker/libcontainer, lmctfy, etc.) within virtual containers
      without adding dependency on some state/agent present outside the
      container.

  Note that the feature proposed here is completely different than the
  “ns cgroup” feature which existed in the linux kernel until recently.
  The ns cgroup also attempted to connect cgroups and namespaces by
  creating a new cgroup every time a new namespace was created. It did
  not solve any of the above mentioned problems and was later dropped
  from the kernel. Incidentally though, it used the same config option
  name CONFIG_CGROUP_NS as used in my prototype!

Introducing CGroup Namespaces
  With unified cgroup hierarchy
  (Documentation/cgroups/unified-hierarchy.txt), the containers can now
  have a much more coherent cgroup view and its easy to associate a
  container with a single cgroup. This also allows us to virtualize the
  cgroup view for tasks inside the container.

  The new CGroup Namespace allows a process to “unshare” its cgroup
  hierarchy starting from the cgroup its currently in.
  For Ex:
  $ cat /proc/self/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1
  $ ls -l /proc/self/ns/cgroup
  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
  $ ~/unshare -c  # calls unshare(CLONE_NEWCGROUP) and exec’s /bin/bash
  [ns]$ ls -l /proc/self/ns/cgroup
  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup ->
  cgroup:[4026532183]
  # From within new cgroupns, process sees that its in the root cgroup
  [ns]$ cat /proc/self/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/

  # From global cgroupns:
  $ cat /proc/<pid>/cgroup
  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1

  # Unshare cgroupns along with userns and mountns
  # Following calls unshare(CLONE_NEWCGROUP|CLONE_NEWUSER|CLONE_NEWNS), then
  # sets up uid/gid map and exec’s /bin/bash
  $ ~/unshare -c -u -m

  # Originally, we were in /batchjobs/c_job_id1 cgroup. Mount our own cgroup
  # hierarchy.
  [ns]$ mount -t cgroup cgroup /tmp/cgroup
  [ns]$ ls -l /tmp/cgroup
  total 0
  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
  -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
  -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control

  The cgroupns-root (/batchjobs/c_job_id1 in above example) becomes the
  filesystem root for the namespace specific cgroupfs mount.

  The virtualization of /proc/self/cgroup file combined with restricting
  the view of cgroup hierarchy by namespace-private cgroupfs mount
  should provide a completely isolated cgroup view inside the container.

  In its current form, the cgroup namespaces patcheset provides following
  behavior:

  (1) The “root” cgroup for a cgroup namespace is the cgroup in which
      the process calling unshare is running.
      For ex. if a process in /batchjobs/c_job_id1 cgroup calls unshare,
      cgroup /batchjobs/c_job_id1 becomes the cgroupns-root.
      For the init_cgroup_ns, this is the real root (“/”) cgroup
      (identified in code as cgrp_dfl_root.cgrp).

  (2) The cgroupns-root cgroup does not change even if the namespace
      creator process later moves to a different cgroup.
      $ ~/unshare -c # unshare cgroupns in some cgroup
      [ns]$ cat /proc/self/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
      [ns]$ mkdir sub_cgrp_1
      [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
      [ns]$ cat /proc/self/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1

  (3) Each process gets its CGROUPNS specific view of /proc/<pid>/cgroup
  (a) Processes running inside the cgroup namespace will be able to see
      cgroup paths (in /proc/self/cgroup) only inside their root cgroup
      [ns]$ sleep 100000 &  # From within unshared cgroupns
      [1] 7353
      [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
      [ns]$ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1

  (b) From global cgroupns, the real cgroup path will be visible:
      $ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/c_job_id1/sub_cgrp_1

  (c) From a sibling cgroupns (cgroupns root-ed at a different cgroup), cgroup
      path relative to its own cgroupns-root will be shown:
      # ns2's cgroupns-root is at '/batchjobs/c_job_id2'
      [ns2]$ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../c_job_id2/sub_cgrp_1
      [ns2]$
      Note that the relative path always starts with '/' to indicate that its
      relative to the cgroupns-root of the caller.

  (4) Processes inside a cgroupns can move in-and-out of the cgroupns-root
      (if they have proper access to external cgroups).
      # From inside cgroupns (with cgroupns-root at /batchjobs/c_job_id1), and
      # assuming that the global hierarchy is still accessible inside cgroupns:
      $ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
      $ echo 7353 > batchjobs/c_job_id2/cgroup.procs
      $ cat /proc/7353/cgroup
      0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../c_job_id2

      Note that this kind of setup is not encouraged. A task inside cgroupns
      should only be exposed to its own cgroupns hierarchy. Otherwise it makes
      the virtualization of /proc/<pid>/cgroup less useful.

  (5) Setns to another cgroup namespace is allowed when:
      (a) the process has CAP_SYS_ADMIN in its current userns
      (b) the process has CAP_SYS_ADMIN in the target cgroupns' userns
      No implicit cgroup changes happen with attaching to another cgroupns. It
      is expected that the somone moves the attaching process under the target
      cgroupns-root.

  (6) When some thread from a multi-threaded process unshares its
      cgroup-namespace, the new cgroupns gets applied to the entire
      process (all the threads). This should be OK since
      unified-hierarchy only allows process-level containerization. So
      all the threads in the process will have the same cgroup. And both
      - changing cgroups and unsharing namespaces - are protected under
      threadgroup_lock(task).

  (7) The cgroup namespace is alive as long as there is atleast 1
      process inside it. When the last process exits, the cgroup
      namespace is destroyed. The cgroupns-root and the actual cgroups
      remain though.

  (8) 'mount -t cgroup cgroup <mntpt>' when called from within cgroupns mounts
      the unified cgroup hierarchy with cgroupns-root as the filesystem root.
      The process needs CAP_SYS_ADMIN in its userns and mntns.

Implementation
  The current patch-set is based on top of Tejun Heo's cgroup tree (for-next
  branch). Its fairly non-intrusive and provides above mentioned
  features.

Possible extensions of CGROUPNS:
  (1) The Documentation/cgroups/unified-hierarchy.txt mentions use of
      capabilities to restrict cgroups to administrative users. CGroup
      namespaces could be of help here. With cgroup namespaces, it might
      be possible to delegate administration of sub-cgroups under a
      cgroupns-root to the cgroupns owner.

---

 fs/kernfs/dir.c                  | 194 ++++++++++++++++++++++++++++++++++-----
 fs/kernfs/mount.c                |  48 ++++++++++
 fs/proc/namespaces.c             |   1 +
 include/linux/cgroup.h           |  41 ++++++++-
 include/linux/cgroup_namespace.h |  36 ++++++++
 include/linux/kernfs.h           |   5 +
 include/linux/nsproxy.h          |   2 +
 include/linux/proc_ns.h          |   4 +
 include/uapi/linux/sched.h       |   3 +-
 kernel/Makefile                  |   2 +-
 kernel/cgroup.c                  | 108 +++++++++++++++++-----
 kernel/cgroup_namespace.c        | 148 +++++++++++++++++++++++++++++
 kernel/fork.c                    |   2 +-
 kernel/nsproxy.c                 |  19 +++-
 14 files changed, 561 insertions(+), 52 deletions(-)
 create mode 100644 include/linux/cgroup_namespace.h
 create mode 100644 kernel/cgroup_namespace.c

 [PATCHv2 1/7] kernfs: Add API to generate relative kernfs path
 [PATCHv2 2/7] sched: new clone flag CLONE_NEWCGROUP for cgroup
 [PATCHv2 3/7] cgroup: add function to get task's cgroup on default
 [PATCHv2 4/7] cgroup: export cgroup_get() and cgroup_put()
 [PATCHv2 5/7] cgroup: introduce cgroup namespaces
 [PATCHv2 6/7] cgroup: cgroup namespace setns support
 [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
