Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaFLQXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:23:34 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:50587 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaFLQXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:32 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET percpu/for-3.17] percpu: clean up percpu accessor and operation definitions
Date: Thu, 12 Jun 2014 12:23:17 -0400
Message-Id: <1402590209-31610-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Percpu accessor and operation definitions are very difficult to
follow.  Things are scattered around different header files without
specific reasons.  Definitions of different types are mixed and the
ordering sometimes is conventional.  Different definitions use
different styles and sometimes lack visual consistency for no good
reason.

The issues go deeper than skin-deep.  There's no clear distinction
between arch-specific and generic part of implementation making it
impossible for the generic layer to impose common feature or
restriction on top of arch-specific overrides.  The arch override
mechanism is broken in itself too. __this_cpu_*() operations are
defined in terms of raw_cpu_*_N() sub-ops and can't be overridden, so
if an arch overrides a raw_cpu_*() operation as whole, __this_cpu_*()
will continue using the generic implementation even though
semantically it's raw_cpu_*() + preemption sanity check.

This patchset contains the following 12 patches to clean up the whole
thing.

 0001-percpu-disallow-archs-from-overriding-SHIFT_PERCPU_P.patch
 0002-percpu-introduce-arch_raw_cpu_ptr.patch
 0003-percpu-include-asm-generic-percpu.h-should-contain-o.patch
 0004-percpu-move-accessors-from-include-linux-percpu.h-to.patch
 0005-percpu-reorganize-include-linux-percpu-defs.h.patch
 0006-percpu-only-allow-sized-arch-overrides-for-raw-this-.patch
 0007-percpu-move-generic-raw-this-_cpu_-_N-definitions-to.patch
 0008-percpu-move-raw-this-_cpu_-definitions-to-include-li.patch
 0009-percpu-reorder-macros-in-percpu-header-files.patch
 0010-percpu-use-raw_cpu_-to-define-__this_cpu_.patch
 0011-percpu-preffity-percpu-header-files.patch
 0012-percpu-invoke-__verify_pcpu_ptr-from-the-generic-par.patch

0001-0005 tidy up arch overrides, shuffle definitions around so that
each percpu header file serves specific purposes.

0006 disallows whole operation overrides for raw/this_cpu_*().  No
arch is using it and it makes it impossible to distinguish
arch-specific and generic parts of percpu operation definitions.

0007-0009 continues the reorganization.

0010 makes __this_cpu_*() ops use raw_cpu_*() opst instead of reaching
into raw_cpu_*_N() sub-ops.

0011 performs a bunch of cosmetic changes to make it less of an
eyesore.

0012 moves __verify_pcpu_ptr() invocations so that they're contained
in the generic layer and it's called only once per operation.  A
recent change added a data dependency barrier to __verify_pcpu_ptr()
so this makes a minute but actual difference for archs w/ non-noop
data dependency barrier FWIW.

This patchset is on top of

  linus master c31c24b8251f ("Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux")
+ [1] [PATCH RFC] percpu: add data dependency barrier in percpu accessors and operations

diffstat follows.  Thanks.

 arch/x86/include/asm/percpu.h |    3 
 include/asm-generic/percpu.h  |  410 +++++++++++++++++++++----
 include/linux/percpu-defs.h   |  397 +++++++++++++++++++++++-
 include/linux/percpu.h        |  673 ------------------------------------------
 4 files changed, 729 insertions(+), 754 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/20140612135630.GA23606@htj.dyndns.org
