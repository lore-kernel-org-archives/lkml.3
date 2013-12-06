Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3LFU17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:27:59 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38680 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3LFU15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:27:57 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, vdavydov@parallels.com
Subject: [PATCHSET REPOST cgroup/for-3.14] cgroup: factor out css creation into create_css()
Date: Fri,  6 Dec 2013 15:27:45 -0500
Message-Id: <1386361672-27791-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is repost of the following.

 http://thread.gmane.org/gmane.linux.kernel.cgroups/8981

It got reviewed and acked then but I somehow forgot apply and Vladimir
reporting the same bug that the first patch in the original patch
fixed reminded me.  The first patch is already applied to
cgroup/for-3.13-fixes which is pulled into for-3.14 for this series.

While the patches are not completely identical, the adjustments are
trivial.  css_id got ripped out in the meantime, so "[PATCH 4/9]
cgroup: move css_id commit from cgroup_populate_dir() to online_css()"
is dropped and the patches are refreshed to reflect the dropping of
css_id handling in cgroup_create().  I'm applying the series to
cgroup/for-3.14.

The original patchset description follows.  Thanks and sorry about the
messup.

For unified hierarchy, a css's (cgroup_subsys_state) lifetime will be
different from that of the associated cgroup.  css's may be created
and destroyed dynamically over the lifetime of a single cgroup.  The
previous changes decoupled css destruction from cgroup's.  This
patchset decouples css creation from cgroup's.

This patchset contains the following seven patches.

 0001-cgroup-css-iterations-and-css_from_dir-are-safe-unde.patch
 0002-cgroup-make-for_each_subsys-useable-under-cgroup_roo.patch
 0003-cgroup-reorder-operations-in-cgroup_create.patch
 0004-cgroup-combine-css-handling-loops-in-cgroup_create.patch
 0005-cgroup-factor-out-cgroup_subsys_state-creation-into-.patch
 0006-cgroup-implement-for_each_css.patch
 0007-cgroup-remove-for_each_root_subsys.patch

0001-0002 are prep patches.

0003-0005 collect css creation operations into single loop and factor
it out into create_css().

0006-0007 are somewhat tangential.  As everything is css based now and
the enabled set of css's might be differ depending on the specific
cgroup in the future, they introduce for_each_css() and replace most
uses of for_each_root_subsys() with it.  The two left overs are
opencoded and for_each_root_subsys() and the related logic are
removed.

This patchset shouldn't bring any userland noticeable behavior
changes.  It's on top of cgroup/for-3.12 d1625964da ("cgroup: fix
cgroup_css() invocation in css_from_id()") and available in the
following git branch.

 include/linux/cgroup.h |    9 -
 kernel/cgroup.c        |  300 ++++++++++++++++++++++++++-----------------------
 2 files changed, 161 insertions(+), 148 deletions(-)

--
tejun
