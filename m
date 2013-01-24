Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946002Ab3AXVfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:35:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:40046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab3AXVOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Ahern <dsahern@gmail.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 12/46] perf x86: revert 20b279 - require exclude_guest to use PEBS - kernel side
Date: Thu, 24 Jan 2013 13:12:50 -0800
Message-Id: <20130124211140.167271154@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@gmail.com>

commit a706d965dcfdff73bf2bad1c300f8119900714c7 upstream.

This patch is brought to you by the letter 'H'.

Commit 20b279 breaks compatiblity with older perf binaries when run with
precise modifier (:p or :pp) by requiring the exclude_guest attribute to be
set. Older binaries default exclude_guest to 0 (ie., wanting guest-based
samples) unless host only profiling is requested (:H modifier). The workaround
for older binaries is to add H to the modifier list (e.g., -e cycles:ppH -
toggles exclude_guest to 1). This was deemed unacceptable by Linus:

https://lkml.org/lkml/2012/12/12/570

Between family in town and the fresh snow in Breckenridge there is no time left
to be working on the proper fix for this over the holidays. In the New Year I
have more pressing problems to resolve -- like some memory leaks in perf which
are proving to be elusive -- although the aforementioned snow is probably why
they are proving to be elusive. Either way I do not have any spare time to work
on this and from the time I have managed to spend on it the solution is more
difficult than just moving to a new exclude_guest flag (does not work) or
flipping the logic to include_guest (which is not as trivial as one would
think).

So, two options: silently force exclude_guest on as suggested by Gleb which
means no impact to older perf binaries or revert the original patch which
caused the breakage.

This patch does the latter -- reverts the original patch that introduced the
regression. The problem can be revisited in the future as time allows.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1356749767-17322-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -340,9 +340,6 @@ int x86_setup_perfctr(struct perf_event
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
-
-		if (!attr->exclude_guest)
-			return -EOPNOTSUPP;
 	}
 
 	hwc->config |= config;
@@ -385,9 +382,6 @@ int x86_pmu_hw_config(struct perf_event
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
-		if (!event->attr.exclude_guest)
-			return -EOPNOTSUPP;
-
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;


