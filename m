Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694Ab3DCQCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:02:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760957Ab3DCQCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:02:35 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 0/9] uretprobes: Return uprobes implementation
Date: Wed,  3 Apr 2013 18:00:30 +0200
Message-Id: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

Uretprobes' core implementation. Enables a function's return probes in uprobe-
based event tracing.

Patchset introduce additional handler (ret_handler) in uprobe consumer that
defines uretprobe.

There is a regular uprobe with return probe handler behind every uretprobe.
Once hit the uprobe that has ret_handler set, we hijack the return address of
the probed function and replace it with the address of trampoline. Trampoline
is a preallocated page in probed task's xol area that filled with breakpoint
opcode. In turn, when the return breakpoint is hit, we invoke the ret_handler.

The patchset shouldn't be difficult to read and hopefully the comments to
commits will help. Please, review.

patchset in git:
  http://github.com/arapov/linux-aa/commits/uretprobes_v1

previous versions:
  v0: https://lkml.org/lkml/2013/3/22/218

RFC reviews:
  RFCv4: https://lkml.org/lkml/2013/3/4/246
  RFCv3: https://lkml.org/lkml/2013/2/28/148
  RFCv2: https://lkml.org/lkml/2013/1/9/157
  RFCv1: https://lkml.org/lkml/2012/12/21/133

thanks,
Anton.

Anton Arapov (9):
  uretprobes: Introduce uprobe_consumer->ret_handler()
  uretprobes: Reserve the first slot in xol_vma for trampoline
  uretprobes/x86: Hijack return address
  uretprobes/ppc: Hijack return address
  uretprobes: Return probe entry, prepare_uretprobe()
  uretprobes: Return probe exit, invoke handlers
  uretprobes: Limit the depth of return probe nestedness
  uretprobes: Remove -ENOSYS as return probes implemented
  uretprobes: Documentation update
 
 Documentation/trace/uprobetracer.txt | 126 +++++++++++++---------
 arch/powerpc/include/asm/uprobes.h   |   1 +
 arch/powerpc/kernel/uprobes.c        |  13 +++
 arch/x86/include/asm/uprobes.h       |   1 +
 arch/x86/kernel/uprobes.c            |  29 +++++
 include/linux/uprobes.h              |   7 ++
 kernel/events/uprobes.c              | 202 +++++++++++++++++++++++++++++++++--
 7 files changed, 320 insertions(+), 59 deletions(-)

-- 
1.8.1.4
