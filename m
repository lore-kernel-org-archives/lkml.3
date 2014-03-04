Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbaCDUnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:43:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:36882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156AbaCDUna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:43:30 -0500
Message-Id: <20140304202425.102779779@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 04 Mar 2014 20:43:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/5] genirq: Sanitize irq_set_affinity callbacks
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my last tree wide sweep of irq controller related oddities I
discovered that some controllers have an broken implementation versus
selecting a single target cpu from the given cpu mask.

The core merily guarantees that at least one of the cpus in the mask
is online.

If the controller callback does not restrict the search for a single
target to the online cpus it might run into the following situation:

     Assume 4 cores online: online mask = 0x0f

     Offline Core 1 	    online mask = 0x0d

     Set affinity to 0xe    is valid due to online mask 0xd

     cpumask_first(0xe)     picks core 1, which is offline

The following series takes care of this. The patches should be tagged
stable if there are no objections.

I'm pondering to extend the core functionality to select a target cpu
before calling into irq_set_affinity() to prevent future copy and
paste failures and get rid of all the duplicated code.

Thanks,

	tglx





