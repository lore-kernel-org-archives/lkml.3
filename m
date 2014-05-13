Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbaEMIxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:53:45 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:2570 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbaEMIxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:53:41 -0400
Message-ID: <5371DD92.5080304@imgtec.com>
Date: Tue, 13 May 2014 09:53:38 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in __compiletime_assert()
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>	 <5370CFAC.40705@imgtec.com>	 <20140512141642.5eb526deed5ea32ad5bced72@linux-foundation.org> <1399966293.4137.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399966293.4137.5.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On 13/05/14 08:31, Johannes Berg wrote:
> On Mon, 2014-05-12 at 14:16 -0700, Andrew Morton wrote:
> 
>>> I don't understand why your patch should break things, I suspect it's
>>> related to the sparse behaviour you're trying to work around, but can we
>>> please drop this patch until a more portable workaround can be found?
>>
>> Older gcc's often have this problem.
>>
>> I suppose that build bustage is more serious than sparse false
>> positives so yes, let's please try to find an alternative.
> 
> Since most people probably don't use sparse without compiling (in fact
> it's pretty difficult to do so) I'll just send a patch to disable
> __compiletime_assert for sparse - any objections?

I came up with the hack below yesterday evening. Is that the sort of
thing you mean? (feel free to use this or do something else, just my
2p).

Cheers
James


Subject: [PATCH] compiler.h: avoid sparse errors in
 __compiletime_error_fallback()

Usually, BUG_ON and friends aren't even evaluated in sparse, but
recently compiletime_assert_atomic_type() was added, and that now
results in a sparse warning every time it is used.

The reason turns out to be the temporary variable, after it sparse no
longer considers the value to be a constant, and results in a warning
and an error. The error is the more annoying part of this as it
suppresses any further warnings in the same file, hiding other problems.

Unfortunately the condition cannot be simply expanded out to avoid the
temporary variable since it breaks compiletime_assert on old versions of
GCC such as GCC 4.2.4 which the latest metag compiler is based on.

Therefore #ifndef __CHECKER__ out the __compiletime_error_fallback which
uses the potentially negative size array to trigger a conditional
compiler error, so that sparse doesn't see it.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Luciano Coelho <luciano.coelho@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
It's not particularly pretty, if you can think of a better solution that
doesn't break old GCC I'm all ears.
---
 include/linux/compiler.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index ee7239ea1583..64fdfe1cfcf0 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -323,9 +323,18 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
-# define __compiletime_error_fallback(condition) \
+/*
+ * Sparse complains of variable sized arrays due to the temporary variable in
+ * __compiletime_assert. Unfortunately we can't just expand it out to make
+ * sparse see a constant array size without breaking compiletime_assert on old
+ * versions of GCC (e.g. 4.2.4), so hide the array from sparse altogether.
+ */
+# ifndef __CHECKER__
+#  define __compiletime_error_fallback(condition) \
 	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
-#else
+# endif
+#endif
+#ifndef __compiletime_error_fallback
 # define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
-- 
1.9.3
