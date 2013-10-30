Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3J3XXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3J3XXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:23:15 -0400
Date: Thu, 31 Oct 2013 01:26:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        gleb@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131030232605.GA28823@redhat.com>
References: <20131030190929.GA7153@redhat.com>
 <20131030201552.GP4126@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030201552.GP4126@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Paul, could you review this patch please?
> > Documentation/memory-barriers.txt says that unlock has a weaker
> > uni-directional barrier, but in practice srcu_read_unlock calls
> > smp_mb().
> > 
> > Is it OK to rely on this? If not, can I add
> > smp_mb__after_srcu_read_unlock (making it an empty macro for now)
> > so we can avoid an actual extra smp_mb()?
> 
> Please use smp_mb__after_srcu_read_unlock().  After all, it was not
> that long ago that srcu_read_unlock() contained no memory barriers,
> and perhaps some day it won't need to once again.
> 
> 							Thanx, Paul
>

Thanks!
Something like this will be enough?
 
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index c114614..9b058ee 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -237,4 +237,18 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__srcu_read_unlock(sp, idx);
 }
 
+/**
+ * smp_mb__after_srcu_read_unlock - ensure full ordering after srcu_read_unlock
+ *
+ * Converts the preceding srcu_read_unlock into a two-way memory barrier.
+ *
+ * Call this after srcu_read_unlock, to guarantee that all memory operations
+ * that occur after smp_mb__after_srcu_read_unlock will appear to happen after
+ * the preceding srcu_read_unlock.
+ */
+static inline void smp_mb__after_srcu_read_unlock(void)
+{
+	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
+}
+
 #endif
