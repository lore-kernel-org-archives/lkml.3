Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3H1VD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:03:59 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47852 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3H1VD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:03:56 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.12] cgroup: factor out css creation into create_css()
Date: Wed, 28 Aug 2013 17:03:40 -0400
Message-Id: <1377723829-22814-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For unified hierarchy, a css's (cgroup_subsys_state) lifetime will be
different from that of the associated cgroup.  css's may be created
and destroyed dynamically over the lifetime of a single cgroup.  The
previous changes decoupled css destruction from cgroup's.  This
patchset decouples css creation from cgroup's.

This patchset contains the following nine patches.

 0001-cgroup-fix-css-leaks-on-online_css-failure.patch
 0002-cgroup-css-iterations-and-css_from_dir-are-safe-unde.patch
 0003-cgroup-make-for_each_subsys-useable-under-cgroup_roo.patch
 0004-cgroup-move-css_id-commit-from-cgroup_populate_dir-t.patch
 0005-cgroup-reorder-operations-in-cgroup_create.patch
 0006-cgroup-combine-css-handling-loops-in-cgroup_create.patch
 0007-cgroup-factor-out-cgroup_subsys_state-creation-into-.patch
 0008-cgroup-implement-for_each_css.patch
 0009-cgroup-remove-for_each_root_subsys.patch

0001 is a fix for an existing leak issue in the creation error
handling path.

0002-0004 are prep patches.  Note that 0004 will conflict with css_id
removal patch.

0005-0007 collect css creation operations into single loop and factor
it out into create_css().

0008-0009 are somewhat tangential.  As everything is css based now and
the enabled set of css's might be differ depending on the specific
cgroup in the future, they introduce for_each_css() and replace most
uses of for_each_root_subsys() with it.  The two left overs are
opencoded and for_each_root_subsys() and the related logic are
removed.

This patchset shouldn't bring any userland noticeable behavior
changes.  It's on top of cgroup/for-3.12 d1625964da ("cgroup: fix
cgroup_css() invocation in css_from_id()") and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-create_css

diffstat follows.

 include/linux/cgroup.h |   10 -
 kernel/cgroup.c        |  348 ++++++++++++++++++++++++++-----------------------
 2 files changed, 187 insertions(+), 171 deletions(-)

Thanks.

--
tejun
