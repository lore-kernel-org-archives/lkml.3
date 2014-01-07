Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaAGSqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:46:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaAGSqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:46:31 -0500
Message-ID: <52CC4B77.9090401@redhat.com>
Date: Tue, 07 Jan 2014 13:46:15 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>,
        "Morgan, Janet" <janet.morgan@intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        chen gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v6]
References: <1389098827-12050-1-git-send-email-prarit@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31D96D8F@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D96D8F@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/07/2014 12:54 PM, Luck, Tony wrote:
> +	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
> +		irq = __this_cpu_read(vector_irq[vector]);
> +		if (irq >= 0) {
> +			desc = irq_to_desc(irq);
> +			data = irq_desc_get_irq_data(desc);
> +			cpumask_copy(&affinity_new, data->affinity);
> +			cpu_clear(this_cpu, affinity_new);
> +			/*
> +			 * The check below determines if this irq requires
> +			 * an empty vector_irq[irq] entry on an online
> +			 * cpu.
> +			 *
> +			 * The code only counts active non-percpu irqs, and
> +			 * those irqs that are not linked to on an online cpu.
> +			 * The first test is trivial, the second is not.
> +			 *
> +			 * The second test takes into account the
> +			 * account that a single irq may be mapped to multiple
> +			 * cpu's vector_irq[] (for example IOAPIC cluster
> +			 * mode).  In this case we have two
> +			 * possibilities:
> +			 *
> +			 * 1) the resulting affinity mask is empty; that is
> +			 * this the down'd cpu is the last cpu in the irq's
> +			 * affinity mask, and
> Code says "||" - so I think comment should say "or".
> +			 *
> +			 * 2) the resulting affinity mask is no longer
> +			 * a subset of the online cpus but the affinity
> +			 * mask is not zero; that is the down'd cpu is the
> +			 * last online cpu in a user set affinity mask.
> +			 *
> +			 * In both possibilities, we need to remap the irq
> +			 * to a new vector_irq[].
> +			 *
> +			 */
> +			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
> +			    (cpumask_empty(&affinity_new) ||
> +			     !cpumask_subset(&affinity_new, &online_new)))
> +				this_count++;
> +		}
> 
> That's an impressive 6:1 ratio of lines-of-comment to lines-of-code!

Heh -- I couldn't decide if I should keep it all together in one comment or
divide it up.  I guess it does look less scary if I divide it up.  So how about
(sorry for the cut-and-paste)


        for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
                irq = __this_cpu_read(vector_irq[vector]);
                if (irq >= 0) {
                        desc = irq_to_desc(irq);
                        data = irq_desc_get_irq_data(desc);
                        cpumask_copy(&affinity_new, data->affinity);
                        cpu_clear(this_cpu, affinity_new);

                        /* Do not count inactive or per-cpu irqs. */
                        if (!irq_has_action(irq) || irqd_is_per_cpu(data))
                                continue;

                        /*
                         * A single irq may be mapped to multiple
                         * cpu's vector_irq[] (for example IOAPIC cluster
                         * mode).  In this case we have two
                         * possibilities:
                         *
                         * 1) the resulting affinity mask is empty; that is
                         * this the down'd cpu is the last cpu in the irq's
                         * affinity mask, or
                         *
                         * 2) the resulting affinity mask is no longer
                         * a subset of the online cpus but the affinity
                         * mask is not zero; that is the down'd cpu is the
                         * last online cpu in a user set affinity mask.
                         */
                        if (cpumask_empty(&affinity_new) ||
                            !cpumask_subset(&affinity_new, &online_new))
                                this_count++;
                }
        }


Everyone okay with that?

P.
