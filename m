Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3CVNJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3CVNJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:30 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 0/7] uretprobes: return probes implementation
Date: Fri, 22 Mar 2013 14:08:57 +0100
Message-Id: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

  this is core implementation of the uretprobes. This enables a breakpoint
on function's return for the tools such as perf.

  Introduce additional handler* for uprobe consumer that makes possible the
distinguish uprobe from uretprobe. Note, behind every uretprobe a regular
uprobe with return probe handler(rp_handler). Once hit the uprobe that has
rp_handler, we hijack the return address of the probed function and replacing
it with the address of trampoline. Trampoline is the preallocated page in
probed task's xol area that filled with breakpoint opcode. In turn, when the
return breakpoint is hit, invoke the rp_handler.

  The patchset shouldn't be difficult to read and hopefully the comments to
commits will help.
  Please, review.


patchset in git:
  http://github.com/arapov/linux-aa/commits/uretprobes_v0

RFC reviews:
  v4: https://lkml.org/lkml/2013/3/4/246
  v3: https://lkml.org/lkml/2013/2/28/148
  v2: https://lkml.org/lkml/2013/1/9/157
  v1: https://lkml.org/lkml/2012/12/21/133

thanks,
Anton.

Anton Arapov (7):
  uretprobes: preparation patch
  uretprobes: extract fill_page() and trampoline implementation
  uretprobes/x86: hijack return address
  uretprobes: return probe entry, prepare_uretprobe()
  uretprobes: return probe exit, invoke handlers
  uretprobes: limit the depth of return probe nestedness
  uretprobes: remove -ENOSYS as return probes implemented

 arch/x86/include/asm/uprobes.h |   1 +
 arch/x86/kernel/uprobes.c      |  29 ++++++
 include/linux/uprobes.h        |   5 +
 kernel/events/uprobes.c        | 205 ++++++++++++++++++++++++++++++++++++++---
 4 files changed, 229 insertions(+), 11 deletions(-)

-- 
1.8.1.4
