Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3FFWbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:31:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3FFWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:31:43 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PoKskDOgAAwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w6MdcgRnwfYA:10 a=VwQbUJbxAAAA:8 a=sSGdn24nJPWUM8SqEsUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130606222924.366792086@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Jun 2013 18:29:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/4 (no gpg)] [GIT PULL] tracing: Fixes with dealing with RCU and context tracking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resending, as my gpg addition to quilt seems to be messing up.
  This send is without adding gpg signing, which is unnecessary anyway
  as the tag to be pulled is a signed tag. ]

Linus,

This includes the same patches as my last pull request with
trace-fixes-v3.10-rc3-v2. I added two more fixes to this series.

This contains 4 fixes.

The first two fix the case where full RCU debugging is enabled, enabling
function tracing causes a live lock of the system. This is due to the added
debug checks in rcu_dereference_raw() that is used by the function tracer.
These checks are also traced by the function tracer as well as cause enough
overhead to the function tracer to slow down the system enough that
the time to finish an interrupt can take longer than when the next
interrupt is triggered, causing a live lock from the timer interrupt.

Talking this over with Paul McKenney, we came up with a fix that adds
a new rcu_dereference_raw_notrace() that does not perform these added checks,
and let the function tracer use that.

The third commit fixes a failed compile when branch tracing is enabled,
due to the conversion of the trace_test_buffer() selftest that the
branch trace wasn't converted for.

The forth patch fixes a bug caught by the RCU lockdep code where a
rcu_read_lock() is performed when rcu is disabled (either going to
or from idle, or user space). This happened on the irqsoff tracer
as it calls task_uid(). The fix here was to use current_uid() when
possible that doesn't use rcu locking. Which luckily, is always used
when irqsoff calls this code.


Please pull the latest trace-fixes-v3.10-rc3-v3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10-rc3-v3

Tag SHA1: 0e87101aa65ebfe736070474684d1b38fea4d805
Head SHA1: f17a5194859a82afe4164e938b92035b86c55794


Steven Rostedt (2):
      rcu: Add _notrace variation of rcu_dereference_raw() and hlist_for_each_entry_rcu()
      ftrace: Use the rcu _notrace variants for rcu_dereference_raw() and friends

Steven Rostedt (Red Hat) (2):
      tracing: Fix bad parameter passed in branch selftest
      tracing: Use current_uid() for critical time tracing

----
 include/linux/rculist.h       |   20 ++++++++++++++++++++
 include/linux/rcupdate.h      |    9 +++++++++
 kernel/trace/ftrace.c         |   18 +++++++++---------
 kernel/trace/trace.c          |   10 +++++++++-
 kernel/trace/trace_selftest.c |    2 +-
 5 files changed, 48 insertions(+), 11 deletions(-)
