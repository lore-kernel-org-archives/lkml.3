Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaJWLa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46254 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaJWLaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:24 -0400
Subject: [PATCH v2 0/5] module: Remove stop_machine from module unloading
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 23 Oct 2014 15:26:36 -0400
Message-ID: <20141023192636.10463.45031.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the second version of removing stop_machine() from
module unloading patchset.

Currently, each module unloading calls stop_machine()s 2 times.
One is for safely removing module from lists and one is to
check the reference counter. However, both are not necessary
for those purposes (required by current implementation).

First, we can use RCU for the list operation, we just need
a synchronize_rcu right before cleaning up.
Second, the reference counter can be checked atomically by
using atomic_t, instead of per-cpu module_ref.

In v2, the series updated as below;

 - Fix to initialize return value in 1/5.
 - Remove module LOCKUP code(v1 4/5).
 - Split v1 5/5 into replacing module_ref with atomic_t and
   removing stop_machine patches.
 - Also, add BUG_ON and WARN_ON for the cases if the
   reference counter becomes a negative value.

Thank you,


---

Masami Hiramatsu (5):
      module: Wait for RCU synchronizing before releasing a module
      module: Unlink module with RCU synchronizing instead of stop_machine
      lib/bug: Use RCU list ops for module_bug_list
      module: Replace module_ref with atomic_t refcnt
      module: Remove stop_machine from module unloading


 include/linux/module.h        |   16 ------
 include/trace/events/module.h |    2 -
 kernel/module.c               |  117 ++++++++++++++++-------------------------
 lib/bug.c                     |   20 +++++--
 4 files changed, 63 insertions(+), 92 deletions(-)

--
Masami HIRAMATSU
Software Platform Research Dpt. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

