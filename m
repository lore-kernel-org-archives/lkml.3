Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaBONWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 08:22:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:35999 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753092AbaBONWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:22:16 -0500
Message-Id: <20140215132057.012974140@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 15 Feb 2014 08:20:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: Two urgent fixes
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Two fixes in the tracing utility.

The first is a fix for the way the ring buffer stores timestamps.
After a restructure of the code was done, the ring buffer timestamp
logic missed the fact that the first event on a sub buffer is to have
a zero delta, as the full timestamp is stored on the sub buffer itself.
But because the delta was not cleared to zero, the timestamp for that
event will be calculated as the real timestamp + the delta from the
last timestamp. This can skew the timestamps of the events and
have them say they happened when they didn't really happen. That's bad.

The second fix is for modifying the function graph caller site.
When the stop machine was removed from updating the function tracing
code, it missed updating the function graph call site location.
It is still modified as if it is being done via stop machine. But it's not.
This can lead to a GPF and kernel crash if the function graph call site
happens to lie between cache lines and one CPU is executing it while
another CPU is doing the update. It would be a very hard condition to
hit, but the result is sever enough to have it fixed ASAP.

Please pull the latest trace-fixes-v3.14-rc2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.14-rc2

Tag SHA1: 390f3e6a6f910b3aea1cef47b9339b99d7f3576f
Head SHA1: 87fbb2ac6073a7039303517546a76074feb14c84


Steven Rostedt (Red Hat) (2):
      ring-buffer: Fix first commit on sub-buffer having non-zero delta
      ftrace/x86: Use breakpoints for converting function graph caller

----
 arch/x86/kernel/ftrace.c   | 83 ++++++++++++++++++++++++++--------------------
 kernel/trace/ring_buffer.c |  7 ++++
 2 files changed, 54 insertions(+), 36 deletions(-)
