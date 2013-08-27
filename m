Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3H0Kn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:43:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41012 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3H0KnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:43:25 -0400
Date: Tue, 27 Aug 2013 18:34:22 +0800
From: larmbr <nasa4836@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, dhowells@redhat.com, nasa4836@gmail.com
Subject: [PATCH] Documentation/memory-barriers: fix a error that mistakes a
 CPU notion in Section Transitivity
Message-ID: <20130827103422.GA17355@larmbr-lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory-barriers document may has a error in Section TRANSITIVITY.

For transitivity, see a example below, given that

* CPU 2's load from X follows CPU 1's store to X, and 
  CPU 2's load from Y preceds CPU 3's store to Y.


 CPU 1                   CPU 2                   CPU 3
 ======================= ======================= =======================
         { X = 0, Y = 0 }
 STORE X=1               LOAD X                  STORE Y=1
                         <read barrier>          <general barrier>
                         LOAD Y                  LOAD X

The <read barrier> in CPU 2 is inadquate, because it could _only_ guarantees
that load operation _happen before_ load operation after the barrier, with
respect to CPU 3, which constrained by a general barrier, but provide _NO_
guarantee that CPU 1' store X will happen before the <read barrier>.

Therefore, if this example runs on a system where CPUs 1 and 3 share a store buffer
or a level of cache, CPU 3 might have early access to CPU 1's writes.

The original text has mistaken CPU 2 for CPU 3, so this patch fixes this, and adds
a paragraph to explain why a <full barrier> should guarantee this.

Signed-off-by: Zhan Jianyu <nasa4836@gmail.com>
---
Documentation/memory-barriers.txt |   11 +++++++++--
1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index fa5d8a9..590a5a9 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -992,6 +992,13 @@ transitivity.  Therefore, in the above example, if CPU 2's load from X
 returns 1 and its load from Y returns 0, then CPU 3's load from X must
 also return 1.
 
+The key point is that CPU 1's storing 1 to X preceds CPU 2's loading 1
+from X, and CPU 2's loading 0 from Y preceds CPU 3's storing 1 to Y,
+which implies a ordering that the general barrier in CPU 2 guarantees:
+all store and load operations must happen before those after the barrier
+with respect to view of CPU 3, which constrained by a general barrier, too.
+Thus, CPU 3's load from X must return 1.
+
 However, transitivity is -not- guaranteed for read or write barriers.
 For example, suppose that CPU 2's general barrier in the above example
 is changed to a read barrier as shown below:
@@ -1009,8 +1016,8 @@ and CPU 3's load from X to return 0.
 
 The key point is that although CPU 2's read barrier orders its pair
 of loads, it does not guarantee to order CPU 1's store.  Therefore, if
-this example runs on a system where CPUs 1 and 2 share a store buffer
-or a level of cache, CPU 2 might have early access to CPU 1's writes.
+this example runs on a system where CPUs 1 and 3 share a store buffer
+or a level of cache, CPU 3 might have early access to CPU 1's writes.
 General barriers are therefore required to ensure that all CPUs agree
 on the combined order of CPU 1's and CPU 2's accesses.
 
