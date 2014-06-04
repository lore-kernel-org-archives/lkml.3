Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaFDMn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:43:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:36058 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaFDMn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:43:56 -0400
Date: Wed, 4 Jun 2014 14:43:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: Re: [PATCH 2/2 v2] x86, make check_irq_vectors_for_cpu_disable()
 aware of numa node irqs
In-Reply-To: <1400160305-17774-3-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.10.1406041421370.3319@nanos>
References: <1400160305-17774-1-git-send-email-prarit@redhat.com> <1400160305-17774-3-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Prarit Bhargava wrote:
> +/* This array is used to keep track of how many empty vectors each cpu has. */
> +static int empty_vectors[NR_CPUS];
> +

No way! The whole vector accounting is a steaming pile of sh*t.

This needs to be fixed at the root of the problem, not by sh*tting on
top of the existing pile!

And the root of the problem is, that we do not have a uniform way to
access the empty vectors. Instead we have a bitmap, constants a
variable upper limit and the vector array. And you certainly noticed
that.

So why on earth are you trying to "fix" the issue by doing loops and
hoops on cpu unplug instead of doing a proper accounting in the first
place? It's all known prior to the point where you unplug a cpu.

FYI, don't try and add some crappy accounting hackery into the
existing vector allocation code. It's doomed.

Jiang is currently rewriting the ioapic code to use irq domains to
support physical ioapic hotplug. The next step is to move the
underlying vector allocation to irqdomains. When this happens we can
add the proper accounting.

That will allow us to support that unplug thing proper including
things like multi-MSI, which you cannot support with your bandaid
hackery at all.

Thanks,

	tglx
