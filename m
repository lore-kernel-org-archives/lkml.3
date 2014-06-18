Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbaFRBIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:08:12 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58702 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaFRBIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:08:10 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET percpu/for-3.17] percpu: implement percpu_ref_reinit()
Date: Tue, 17 Jun 2014 21:07:59 -0400
Message-Id: <1403053685-28240-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, percpu_ref destruction - freeing the percpu counter -
happens when the percpu_ref is released.  This while a bit more
convenient restricts how percpu_ref can be used.  It can't be
initialized with static percpu area and it can't be reinitialized
without going through percpu allocation.

There are use cases which can take advantage of cycling percpu_ref
through init/release multiple times.  This patchset separates out
percpu_ref destruction into percpu_exit() which should be invoked
explicitly and introduces percpu_ref_reinit() which can be used to
recycle a released percpu_ref.

This patchset doesn't add any users.  Patchset to use this will soon
be posted.

This patchset contains the following six patches.

 0001-percpu-refcount-aio-use-percpu_ref_cancel_init-in-io.patch
 0002-percpu-refcount-one-bit-is-enough-for-REF_STATUS.patch
 0003-percpu-refcount-add-helpers-for-percpu_count-accesse.patch
 0004-percpu-refcount-use-unsigned-long-for-pcpu_count-poi.patch
 0005-percpu-refcount-require-percpu_ref-to-be-exited-expl.patch
 0006-percpu-refcount-implement-percpu_ref_reinit-and-perc.patch

0001-0004 are prep/cleanups.

0005 separates out percpu destruction into percpu_ref_exit() and 0006
implements percpu_ref_reinit().

This patchset is on top of percpu/for-3.17 6fbc07bbe2b5 ("percpu:
invoke __verify_pcpu_ptr() from the generic part of accessors and
operations").

diffstat follows.

 drivers/target/target_core_tpg.c |    4 +
 fs/aio.c                         |    6 +-
 include/linux/percpu-refcount.h  |   64 +++++++++++++++++++----------
 kernel/cgroup.c                  |    8 ++-
 lib/percpu-refcount.c            |   86 ++++++++++++++++++++++++---------------
 5 files changed, 109 insertions(+), 59 deletions(-)

Thanks.

--
tejun
