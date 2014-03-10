Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaCJLje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:39:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48646 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaCJLjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:39:33 -0400
Date: Mon, 10 Mar 2014 11:39:28 +0000
From: Glyn Normington <gnormington@gopivotal.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, gnormington@gopivotal.com
Subject: [PATCH] control groups: documentation improvements
Message-ID: <20140310113928.GC18700@gnimac.gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glyn Normington <gnormington@gopivotal.com>

Various clarifications to make the control groups documentation
easier to understand, especially for newcomers.

Delete the phrase "set of parameters" which obfuscates the
definition of cgroup.

Crisp up the definition of subsystem.

Explain the term "partition".

Clarify that each hierarchy must be associated with at least one
subsystem.

Describe the representation of the cgroup virtual filesystem,
since this is not specifically described later in the document.

Clarify that subsystems may be attached to multiple hierarchies,
although this isn't very useful, and explain what happens.

Use the term "task" in preference to "process" everywhere,
for consistency.

The following formal model of control groups helped in producing
the above clarifications:

https://github.com/Zteve/container-specs/raw/master/cgroups/cgroups.pdf

Related LKML thread:

http://lkml.iu.edu//hypermail/linux/kernel/1402.0/02419.html

Signed-off-by: Glyn Normington <gnormington@gopivotal.com>
---
Kernel version: Linux 3.14-rc5.

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 821de56..003330a 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -43,24 +43,29 @@ specialized behaviour.
 
 Definitions:
 
-A *cgroup* associates a set of tasks with a set of parameters for one
-or more subsystems.
+A *cgroup* associates a set of tasks with one or more subsystems.
 
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
+non-empty set of subsystems such that the cgroups in the hierarchy
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
@@ -69,9 +74,9 @@ a cgroup. Those creations and assignments only affect the hierarchy
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
@@ -79,12 +84,12 @@ tasks in each cgroup.
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
@@ -418,11 +423,11 @@ To remove a cgroup, just use rmdir:
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
 
@@ -450,7 +455,7 @@ move it into a new cgroup (possibly the root cgroup) by writing to the
 new cgroup's tasks file.
 
 Note: Due to some restrictions enforced by some cgroup subsystems, moving
-a process to another cgroup can fail.
+a task to another cgroup can fail.
 
 2.3 Mounting hierarchies by name
 --------------------------------
@@ -658,7 +663,7 @@ A: bash's builtin 'echo' command does not check calls to write() against
    errors. If you use it in the cgroup file system, you won't be
    able to tell whether a command succeeded or failed.
 
-Q: When I attach processes, only the first of the line gets really attached !
+Q: When I attach tasks, only the first of the line gets really attached !
 A: We can only return one error code per call to write(). So you should also
    put only ONE PID.
 

