Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaAZNcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:32:09 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45642 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaAZNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:32:07 -0500
Date: Sun, 26 Jan 2014 14:32:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86: allocate cpumask during check irq vectors
Message-ID: <20140126133203.GA1370@gmail.com>
References: <1390611565-18709-1-git-send-email-yinghai@kernel.org>
 <20140125080232.GA20935@gmail.com>
 <52E4FE02.2020004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E4FE02.2020004@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

> On 01/25/2014 03:02 AM, Ingo Molnar wrote:
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Fix warning:
> >> arch/x86/kernel/irq.c: In function check_irq_vectors_for_cpu_disable:
> >> arch/x86/kernel/irq.c:337:1: warning: the frame size of 2052 bytes is larger than 2048 bytes
> >>
> >> when NR_CPUS=8192
> >>
> >> We should use zalloc_cpumask_var() instead.
> >>
> >> -v2: update to GFP_ATOMIC instead and free the allocated cpumask at last.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Prarit Bhargava <prarit@redhat.com>
> >>
> >> ---
> >>  arch/x86/kernel/irq.c |   24 +++++++++++++++++-------
> >>  1 file changed, 17 insertions(+), 7 deletions(-)
> >>
> >> Index: linux-2.6/arch/x86/kernel/irq.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/kernel/irq.c
> >> +++ linux-2.6/arch/x86/kernel/irq.c
> >> @@ -277,11 +277,18 @@ int check_irq_vectors_for_cpu_disable(vo
> >>  	unsigned int this_cpu, vector, this_count, count;
> >>  	struct irq_desc *desc;
> >>  	struct irq_data *data;
> >> -	struct cpumask affinity_new, online_new;
> >> +	cpumask_var_t affinity_new, online_new;
> >> +
> >> +	if (!alloc_cpumask_var(&affinity_new, GFP_ATOMIC))
> >> +		return -ENOMEM;
> >> +	if (!alloc_cpumask_var(&online_new, GFP_ATOMIC)) {
> >> +		free_cpumask_var(affinity_new);
> >> +		return -ENOMEM;
> >> +	}
> > 
> > Atomic allocations can fail easily if the system is under duress.
> 
> Then the hotplug attempt will fail which IMO is okay. [...]

Which is not OK at all for reliable operation, if the system has 
otherwise gobs of RAM, which just don't happen to be atomic 
allocatable!

> [...]  With GFP_KERNEL we might hang the system.

Yes, that's a bug that should be fixed - but not via GFP_ATOMIC, which 
adds insult to injury.

Thanks,

	Ingo
