Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaIZXbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:31:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:4806 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbaIZXbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:31:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,606,1406617200"; 
   d="scan'208";a="579750839"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        torvalds@linux-foundation.org,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: [PATCH 2/2] x86: Only do a single page fault for copy_from_user_nmi
Date: Fri, 26 Sep 2014 16:31:17 -0700
Message-Id: <1411774277-4198-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When copy_from_user_nmi faults the copy_user_tail code ends
up "replaying" the page faults to compute the exact tail bytes,
(added with 112958).

So we do an expensive page fault. And then we do it *again*.

This ends up being very expensive in the PMI handler for any
page fault on a stack access, and is one the more common
causes for the NMI handler exceeding its runtime limit.

  1)   0.109 us    |        copy_from_user_nmi();
  1)               |        copy_from_user_nmi() {
  1)               |          __do_page_fault() {
  1)               |            bad_area_nosemaphore() {
  1)               |              __bad_area_nosemaphore() {
  1)               |                no_context() {
  1)               |                  fixup_exception() {
  1)               |                    search_exception_tables() {
  1)   0.079 us    |                      search_extable();
  1)   0.409 us    |                    }
  1)   0.757 us    |                  }
  1)   1.106 us    |                }
  1)   1.466 us    |              }
  1)   1.793 us    |            }
  1)   2.233 us    |          }
  1)               |          copy_user_handle_tail() {
  1)               |            __do_page_fault() {
  1)               |              bad_area_nosemaphore() {
  1)               |                __bad_area_nosemaphore() {
  1)               |                  no_context() {
  1)               |                    fixup_exception() {
  1)               |                      search_exception_tables() {
  1)   0.060 us    |                        search_extable();
  1)   0.412 us    |                      }
  1)   0.764 us    |                    }
  1)   1.074 us    |                  }
  1)   1.389 us    |                }
  1)   1.665 us    |              }
  1)   2.002 us    |            }
  1)   2.784 us    |          }
  1)   6.230 us    |        }

The NMI code actually doesn't care about the exact tail value. It only
needs to know if a fault happened (!= 0)

So check for in_nmi() in copy_user_tail and don't bother with the exact
tail check. This way we save the extra ~2.7us.

In theory we could also duplicate the whole copy_*_ path for cases
where the caller doesn't care about the exact bytes. But that
seems overkill for just this issue, and I'm not sure anyone
else cares about how fast this is. The simpler check works
as well for now.

Cc: torvalds@linux-foundation.org
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lib/usercopy_64.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index c905e89..1b581e7 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -67,6 +67,9 @@ EXPORT_SYMBOL(copy_in_user);
  * Try to copy last bytes and clear the rest if needed.
  * Since protection fault in copy_from/to_user is not a normal situation,
  * it is not necessary to optimize tail handling.
+ *
+ * It can be somewhat common in NMI handlers doing backtraces.
+ * So don't bother here with returning the exact tail.
  */
 __visible unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
@@ -74,6 +77,11 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	char c;
 	unsigned zero_len;
 
+	if (in_nmi()) {
+		len = 1; /* users only care about != 0 */
+		goto out;
+	}
+
 	for (; len; --len, to++) {
 		if (__get_user_nocheck(c, from++, sizeof(char)))
 			break;
@@ -84,6 +92,7 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
 		if (__put_user_nocheck(c, to++, sizeof(char)))
 			break;
+out:
 	clac();
 	return len;
 }
-- 
1.9.3

