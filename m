Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaDXVCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:02:23 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:55316 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaDXVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:02:21 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, nasa4836@gmail.com
Subject: [PATCHSET cgroup/for-3.16] cgroup: implement css->id
Date: Thu, 24 Apr 2014 17:02:07 -0400
Message-Id: <1398373333-1521-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Until now, cgroup->id has been used to identify all the associated
csses and css_from_id() takes cgroup ID and returns the matching css
by looking up the cgroup and then dereferencing the css associated
with it; however, now that the lifetimes of cgroup and css are
separate, this is incorrect and breaks on the unified hierarchy when a
controller is disabled and enabled back again before the previous
instance is released.

This series adds css->id which is a subsystem-unique ID and converts
css_from_id() to look up by the new css->id instead.  memcg is the
only user of css_from_id() and also converted to use css->id instead.

 0001-cgroup-make-flags-and-subsys_masks-unsigned-int.patch
 0002-cgroup-memcg-allocate-cgroup-ID-from-1.patch
 0003-cgroup-protect-cgroup_root-cgroup_idr-with-a-spinloc.patch
 0004-cgroup-use-RCU-free-in-create_css-failure-path.patch
 0005-cgroup-update-init_css-into-init_and_link_css.patch
 0006-cgroup-memcg-implement-css-id-and-convert-css_from_i.patch

0001-0003 are related prep/cleanups.

0004-0006 add css->id and convert css_from_id() and its user to it.

This patchset is on top of

  cgroup/for-3.16 f8f22e53a262 ("cgroup: implement dynamic subtree controller enable/disable on the default hierarchy")
+ [1] [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
+ [2] Misc comment / warning cleanups

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-css_id

diffstat follows.

 include/linux/cgroup.h |   21 ++++--
 kernel/cgroup.c        |  164 ++++++++++++++++++++++++++++++++-----------------
 mm/memcontrol.c        |   10 --
 3 files changed, 126 insertions(+), 69 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1397056052-2829-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/1397748555-6647-1-git-send-email-nasa4836@gmail.com
    http://lkml.kernel.org/g/1397748544-6570-1-git-send-email-nasa4836@gmail.com
    http://lkml.kernel.org/g/1397748534-6490-1-git-send-email-nasa4836@gmail.com
    http://lkml.kernel.org/g/1397757955.3104.11.camel@joe-AO725
