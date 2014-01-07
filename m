Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaAGRyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:54:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:31328 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaAGRy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="463022545"
From: "Luck, Tony" <tony.luck@intel.com>
To: Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>,
        "Morgan, Janet" <janet.morgan@intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] x86: Add check for number of available vectors before
 CPU down [v6]
Thread-Topic: [PATCH] x86: Add check for number of available vectors before
 CPU down [v6]
Thread-Index: AQHPC6afiqq2sJQfSkOOzC3HSb2lO5p5iFvw
Date: Tue, 7 Jan 2014 17:54:22 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D96D8F@ORSMSX106.amr.corp.intel.com>
References: <1389098827-12050-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1389098827-12050-1-git-send-email-prarit@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		irq = __this_cpu_read(vector_irq[vector]);
+		if (irq >= 0) {
+			desc = irq_to_desc(irq);
+			data = irq_desc_get_irq_data(desc);
+			cpumask_copy(&affinity_new, data->affinity);
+			cpu_clear(this_cpu, affinity_new);
+			/*
+			 * The check below determines if this irq requires
+			 * an empty vector_irq[irq] entry on an online
+			 * cpu.
+			 *
+			 * The code only counts active non-percpu irqs, and
+			 * those irqs that are not linked to on an online cpu.
+			 * The first test is trivial, the second is not.
+			 *
+			 * The second test takes into account the
+			 * account that a single irq may be mapped to multiple
+			 * cpu's vector_irq[] (for example IOAPIC cluster
+			 * mode).  In this case we have two
+			 * possibilities:
+			 *
+			 * 1) the resulting affinity mask is empty; that is
+			 * this the down'd cpu is the last cpu in the irq's
+			 * affinity mask, and
Code says "||" - so I think comment should say "or".
+			 *
+			 * 2) the resulting affinity mask is no longer
+			 * a subset of the online cpus but the affinity
+			 * mask is not zero; that is the down'd cpu is the
+			 * last online cpu in a user set affinity mask.
+			 *
+			 * In both possibilities, we need to remap the irq
+			 * to a new vector_irq[].
+			 *
+			 */
+			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
+			    (cpumask_empty(&affinity_new) ||
+			     !cpumask_subset(&affinity_new, &online_new)))
+				this_count++;
+		}

That's an impressive 6:1 ratio of lines-of-comment to lines-of-code!

Perhaps it would be less scary if the test were broken up into the easy/obvious part
and the one that has taken all these revisions to work out?  E.g.

			/* no need to count inactive or per-cpu irqs */
			if (!irq_has_action(irq) || irqd_is_per_cpu(data))
				continue;

			/*
			  * We need to look for a new home for this irq if:
				... paste in 1), 2) from above here ... (but s/and/or/ to match code)
			 */
			if (cpumask_empty(&affinity_new) ||
			    !cpumask_subset(&affinity_new, &online_new))
				this_count++;

-Tony
