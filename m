Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3HDQHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 12:07:35 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63927 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3HDQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 12:07:34 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to memcg
Date: Sun,  4 Aug 2013 12:07:21 -0400
Message-Id: <1375632446-2581-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Like many other things in cgroup, cgroup_event is way too flexible and
complex - it strives to provide completely flexible event monitoring
facility in cgroup proper which allows any number of users to monitor
custom events.  This is overboard, to say the least, and I strongly
think that cgroup should not any new usages of this facility and
preferably deprecate the existing usages if at all possible.

Fortunately, memcg along with vmpressure is the only user of the
facility and gets to keep it.  This patchset makes cgroup_event
specific to memcg, moves all related code into mm/memcontrol.c and
renames it to mem_cgroup_event so that its usage can't spread to other
subsystems and later deprecation and cleanup can be localized.

Note that after this patchset, cgroup.event_control file exists only
for the hierarchy which has memcg attached to it.  This is a userland
visible change but unlikely to be noticeable as the file has never
been meaningful outside memcg.  If this ever becomes problematic, we
can add a dummy file on hierarchies w/o memcg when !sane_behavior.

This patchset is consited of the following five patches.

 0001-cgroup-implement-CFTYPE_NO_PREFIX.patch
 0002-cgroup-export-__cgroup_from_dentry-and-__cgroup_dput.patch
 0003-cgroup-memcg-move-cgroup_event-implementation-to-mem.patch
 0004-cgroup-memcg-move-cgroup-event_list-_lock-and-event-.patch
 0005-memcg-rename-cgroup_event-to-mem_cgroup_event.patch

The patchset is on top of

  cgroup/for-3.12 61584e3f4 ("cgroup: Merge branch 'for-3.11-fixes' into for-3.12")
+ [1] cgroup: use cgroup_subsys_state as the primary subsystem interface handle

and available in the following branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg_event

diffstat follows.

 Documentation/cgroups/cgroups.txt |   19 --
 include/linux/cgroup.h            |   29 ---
 include/linux/vmpressure.h        |    1
 kernel/cgroup.c                   |  265 +--------------------------------
 mm/memcontrol.c                   |  302 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 315 insertions(+), 301 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2013/8/1/722
