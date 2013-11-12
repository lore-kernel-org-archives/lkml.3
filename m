Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3KLSeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:34:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3KLSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:34:19 -0500
Date: Tue, 12 Nov 2013 19:34:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does Itanium permit speculative stores?
Message-ID: <20131112183404.GH21461@twins.programming.kicks-ass.net>
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:00:26PM +0000, Luck, Tony wrote:
> The "ACCESS_ONCE" macro casts to volatile - which will make gcc generate
> ordered "ld.acq" and "st.rel" instructions for your code snippets. So I think
> you should be fine.

Hurm.. so:

+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("st4.rel [%0]=%1"				\
+				: "=r" (p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("st8.rel [%0]=%1"				\
+				: "=r" (p) : "r" (v) : "memory");	\
+		break;							\
+	}								\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1;						\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("ld4.acq %0=[%1]"				\
+				: "=r" (___p1) : "r" (p) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("ld8.acq %0=[%1]"				\
+				: "=r" (___p1) : "r" (p) : "memory");	\
+		break;							\
+	}								\
+	___p1;								\
+})

That all can be written as:

+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	___p1;								\
+})

On ia64? Totally much simpler!
