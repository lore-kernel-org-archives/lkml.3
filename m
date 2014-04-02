Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaDBNRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:17:19 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48046 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaDBNRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:17:17 -0400
Message-ID: <533C0DD9.1050809@gopivotal.com>
Date: Wed, 02 Apr 2014 14:17:13 +0100
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] control groups: documentation improvements
References: <20140310113928.GC18700@gnimac.gopivotal.com> <20140310140724.GA25290@htj.dyndns.org> <531DC971.6020208@gopivotal.com> <20140310142014.GC25290@htj.dyndns.org> <5321D6FA.4040500@gopivotal.com> <53225C69.3010202@huawei.com> <53230475.5050805@gopivotal.com> <20140314140136.GF12613@htj.dyndns.org> <53230C7E.7060607@gopivotal.com> <533C05D8.8020600@gopivotal.com>
In-Reply-To: <533C05D8.8020600@gopivotal.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glyn Normington<gnormington@gopivotal.com>

Various clarifications to make the control groups documentation
easier to understand, especially for newcomers.

Delete the phrase "set of parameters" which obfuscates the
definition of cgroup.

Crisp up the definition of subsystem.

Explain the term "partition".

Describe the representation of the cgroup virtual filesystem,
since this is not specifically described later in the document.

Clarify that subsystems may be attached to multiple hierarchies,
although this isn't very useful, and explain what happens.

Document how to create a hierarchy with no associated subsystems.

Use the term "task" in preference to "process" everywhere,
for consistency.

Related LKML thread:

http://lkml.iu.edu//hypermail/linux/kernel/1402.0/02419.html

Signed-off-by: Glyn Normington<gnormington@gopivotal.com>
---
Kernel version: Linux 3.14-rc5.

diff --git a/Documentation/cgroups/cgroups.txt 
b/Documentation/cgroups/cgroups.txt
index 821de56..f086b70 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -24,6 +24,7 @@ CONTENTS:
    2.1 Basic Usage
    2.2 Attaching processes
    2.3 Mounting hierarchies by name
+  2.4 Mounting hierarchies with no subsystems
  3. Kernel API
    3.1 Overview
    3.2 Synchronization
@@ -43,24 +44,29 @@ specialized behaviour.

  Definitions:

-A *cgroup* associates a set of tasks with a set of parameters for one
-or more subsystems.
+A *cgroup* associates a set of tasks with zero or more subsystems.

-A *subsystem* is a module that makes use of the task grouping
-facilities provided by cgroups to treat groups of tasks in
-particular ways. A subsystem is typically a "resource controller" that
+A *subsystem* is a module that treats the tasks of each cgroup in a
+particular way. A subsystem is typically a "resource controller" that
  schedules a resource or applies per-cgroup limits, but it may be
-anything that wants to act on a group of processes, e.g. a
-virtualization subsystem.
+anything that wants to act on a group of tasks, e.g. a virtualization
+subsystem.

-A *hierarchy* is a set of cgroups arranged in a tree, such that
-every task in the system is in exactly one of the cgroups in the
-hierarchy, and a set of subsystems; each subsystem has system-specific
-state attached to each cgroup in the hierarchy.  Each hierarchy has
-an instance of the cgroup virtual filesystem associated with it.
+A *hierarchy* is a non-empty set of cgroups arranged in a tree and a
+set of subsystems such that the cgroups in the hierarchy
+partition all the tasks in the system (in other words, every task in the
+system is in exactly one of the cgroups in the hierarchy) and each
+subsystem attaches its own state to each cgroup in the hierarchy.

-At any one time there may be multiple active hierarchies of task
-cgroups. Each hierarchy is a partition of all tasks in the system.
+There may be zero or more active hierarchies. Each hierarchy has an
+instance of the cgroup virtual filesystem associated with it. The tree
+of cgroups is represented by the directory tree in the cgroup virtual
+filesystem.
+
+The sets of subsystems participating in distinct hierarchies are either
+identical or disjoint. If the sets are identical, the virtual filesystems
+associated with the hierarchies have identical content and a change in
+one is automatically reflected in all the others.

  User-level code may create and destroy cgroups by name in an
  instance of the cgroup virtual file system, specify and query to
@@ -69,9 +75,9 @@ a cgroup. Those creations and assignments only affect 
the hierarchy
  associated with that instance of the cgroup file system.

  On their own, the only use for cgroups is for simple job
-tracking. The intention is that other subsystems hook into the generic
+tracking. The intention is that subsystems hook into the generic
  cgroup support to provide new attributes for cgroups, such as
-accounting/limiting the resources which processes in a cgroup can
+accounting/limiting the resources which tasks in a cgroup can
  access. For example, cpusets (see Documentation/cgroups/cpusets.txt) allow
  you to associate a set of CPUs and a set of memory nodes with the
  tasks in each cgroup.
@@ -79,12 +85,12 @@ tasks in each cgroup.
  1.2 Why are cgroups needed ?
  ----------------------------

-There are multiple efforts to provide process aggregations in the
+There are multiple efforts to provide task aggregations in the
  Linux kernel, mainly for resource-tracking purposes. Such efforts
  include cpusets, CKRM/ResGroups, UserBeanCounters, and virtual server
  namespaces. These all require the basic notion of a
-grouping/partitioning of processes, with newly forked processes ending
-up in the same group (cgroup) as their parent process.
+grouping/partitioning of tasks, with newly forked tasks ending
+up in the same group (cgroup) as their parent task.

  The kernel cgroup patch provides the minimum essential kernel
  mechanisms required to efficiently implement such groups. It has
@@ -418,11 +424,11 @@ To remove a cgroup, just use rmdir:
  # rmdir my_sub_cs

  This will fail if the cgroup is in use (has cgroups inside, or
-has processes attached, or is held alive by other subsystem-specific
+has tasks attached, or is held alive by other subsystem-specific
  reference).

-2.2 Attaching processes
------------------------
+2.2 Attaching tasks
+-------------------

  # /bin/echo PID > tasks

@@ -450,7 +456,7 @@ move it into a new cgroup (possibly the root cgroup) 
by writing to the
  new cgroup's tasks file.

  Note: Due to some restrictions enforced by some cgroup subsystems, moving
-a process to another cgroup can fail.
+a task to another cgroup can fail.

  2.3 Mounting hierarchies by name
  --------------------------------
@@ -471,6 +477,13 @@ you give a subsystem a name.
  The name of the subsystem appears as part of the hierarchy description
  in /proc/mounts and /proc/<pid>/cgroups.

+2.4 Mounting hierarchies with no subsystems
+-------------------------------------------
+
+To mount a hierarchy with no associated subsystems, specify a name
+for the hierarchy and the dummy subsystem name "none".  For example:
+
+# mount -t cgroup -o name=hier0,none hier0 /sys/fs/cgroup/h0

  3. Kernel API
  =============
@@ -658,7 +671,7 @@ A: bash's builtin 'echo' command does not check 
calls to write() against
     errors. If you use it in the cgroup file system, you won't be
     able to tell whether a command succeeded or failed.

-Q: When I attach processes, only the first of the line gets really 
attached !
+Q: When I attach tasks, only the first of the line gets really attached !
  A: We can only return one error code per call to write(). So you 
should also
     put only ONE PID.


