Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaF0VJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:09:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56125 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaF0VJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:09:46 -0400
Date: Fri, 27 Jun 2014 16:09:39 -0500
From: Brian W Hart <hartb@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, Stratos Karafotis <stratosk@semaphore.gr>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] cpufreq: make table sentinal macros unsigned to match use
Message-ID: <20140627210939.GB24604@oc3347516403.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062721-0928-0000-0000-0000030778D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5eeaf1f18973 (cpufreq: Fix build error on some platforms that
use cpufreq_for_each_*) moved function cpufreq_next_valid() to a public
header.  Warnings are now generated when objects including that header
are built with -Wsign-compare (as an out-of-tree module might be):

.../include/linux/cpufreq.h: In function ‘cpufreq_next_valid’:
.../include/linux/cpufreq.h:519:27: warning: comparison between signed
and unsigned integer expressions [-Wsign-compare]
  while ((*pos)->frequency != CPUFREQ_TABLE_END)
                           ^
.../include/linux/cpufreq.h:520:25: warning: comparison between signed
and unsigned integer expressions [-Wsign-compare]
   if ((*pos)->frequency != CPUFREQ_ENTRY_INVALID)
                         ^

Constants CPUFREQ_ENTRY_INVALID and CPUFREQ_TABLE_END are signed, but
are used with unsigned member 'frequency' of cpufreq_frequency_table.
Update the macro definitions to be explicitly unsigned to match their
use.

This also corrects potentially wrong behavior of clk_rate_table_iter()
if unsigned long is wider than usigned int.

Signed-off-by: Brian W Hart <hartb@linux.vnet.ibm.com>
---
These macros are fairly broadly used in the kernel so I was bit leery
of changing them, but after inspection I think it's fine.  I found 102
uses of the macros, of which:

99 are uses with cpufreq_frequency_table.frequency (95) or with local
   variables of the same type as frequency (4).  These should be just
   fine with this change--we're just making explicit a conversion that
   was previously implicit.

 2 are uses with a local variable of different type (unsigned long) than
   'frequency' (in drivers/sh/clk/core.c).  One of these uses is safe;
   the other (in clk_rate_table_iter()) is broken if unsigned long
   is wider than unsigned int.  As a side-effect, this patch corrects
   the potential misbehavior there.

 1 is a use in macro cpufreq_for_each_entry() with what _should_ be the
   frequency member of a cpufreq_frequency_table, provided the caller it
   well-behaved.  There are 18 callers of this macro; all are well-behaved.
   So these should also be safe.

 include/linux/cpufreq.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ec4112d..8f8ae95 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -482,8 +482,8 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
  *********************************************************************/
 
 /* Special Values of .frequency field */
-#define CPUFREQ_ENTRY_INVALID	~0
-#define CPUFREQ_TABLE_END	~1
+#define CPUFREQ_ENTRY_INVALID	~0u
+#define CPUFREQ_TABLE_END	~1u
 /* Special Values of .flags field */
 #define CPUFREQ_BOOST_FREQ	(1 << 0)
 
-- 
1.7.1

