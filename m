Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3AOS2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:28:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55895 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3AOS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:28:21 -0500
Date: Tue, 15 Jan 2013 10:19:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: lttng-dev@lists.lttng.org, linux-kernel@vger.kernel.org,
        rp@svcs.cs.pdx.edu
Cc: mathieu.desnoyers@efficios.com, laijs@cn.fujitsu.com,
        shemminger@vyatta.com, stern@rowland.harvard.edu,
        khlebnikov@openvz.org
Subject: [PATCH] Add ACCESS_ONCE() to avoid compiler splitting assignments
Message-ID: <20130115181936.GA30319@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011518-9360-0000-0000-00000F3C0D0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted by Konstantin Khlebnikov, gcc can split assignment of
constants to long variables (https://lkml.org/lkml/2013/1/15/141),
though assignment of NULL (0) is OK.  Assuming that a gcc bug is
fixed (http://gcc.gnu.org/bugzilla/attachment.cgi?id=29169&action=diff
has a patch), making the store be volatile keeps gcc from splitting.

This commit therefore applies ACCESS_ONCE() to CMM_STORE_SHARED(),
which is the underlying primitive used by rcu_assign_pointer().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/urcu/system.h b/urcu/system.h
index 2a45f22..7a1887e 100644
--- a/urcu/system.h
+++ b/urcu/system.h
@@ -49,7 +49,7 @@
  */
 #define CMM_STORE_SHARED(x, v)		\
 	({				\
-		__typeof__(x) _v = _CMM_STORE_SHARED(x, v);	\
+		__typeof__(x) CMM_ACCESS_ONCE(_v) = _CMM_STORE_SHARED(x, v);	\
 		cmm_smp_wmc();		\
 		_v;			\
 	})

