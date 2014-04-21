Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaDUWrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:47:03 -0400
Received: from mxip6-inbound.gatech.edu ([130.207.182.15]:23472 "EHLO
	mxip6-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbaDUWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:46:59 -0400
X-RemoteIP: 130.207.185.162
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 80115325
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.97,898,1389762000"; 
   d="scan'208";a="80115325"
X-GT-Spam-Rating: (0%)
Message-ID: <5355A006.9090502@gatech.edu>
Date: Mon, 21 Apr 2014 18:47:34 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: usage of rcu_dereference_raw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Apr 21, 2014 at 6:03 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>>   do most of the uses of rcu_dereference_raw() need to be changed to use other
>>   dereference functions or are there cases where its usage is valid?
>
> The second call from iwl_op_mode_dvm_stop() -might- be valid.  For it
> to be valid, there must be a grace period between the time that the
> field was made inaccessible to readers and the time that iwl_uninit_drv()
> was called.  Usually something like synchronize_rcu() waits for the
> needed grace period.

So there are valid use cases of the rcu_dereference_raw() in scenarios where
we can verify that a grace period has passed.

Thank you for the info. Mind adding it as a comment as in the patch below?

add comment for rcu_dereference_raw

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rcupdate.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..af40a86 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -662,7 +662,13 @@ static inline void rcu_preempt_sleep_check(void)
     __rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
                 __rcu)
 
-#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
+/* rcu_dereference_raw() - rcu_dereference with no checking
+ * @p: The pointer to read, prior to dereferencing
+ *
+ * Use this to dereference a rcu pointer if you are sure that there exists a
+ * grace period between the time this pointer was made inaccessible to readers
+ */
+#define rcu_dereference_raw(p) rcu_dereference_check(p, 1)
 
 /*
  * The tracing infrastructure traces RCU (we want that), but unfortunately
-- 
1.7.9.5


-- 
Pranith
