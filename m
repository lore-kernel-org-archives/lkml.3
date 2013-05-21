Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3EUOwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:52:55 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45614 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3EUOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:52:52 -0400
Date: Tue, 21 May 2013 16:52:43 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: Lost IPIs during CPU Hotplug
Message-ID: <20130521145243.GA29150@osiris>
References: <20130520123743.GA4108@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520123743.GA4108@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052114-3548-0000-0000-000005741038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 02:37:43PM +0200, Heiko Carstens wrote:
> I just got a dump from a system running a 3.0.something kernel, however I
> think the problem exists with current kernels as well.
> 
> Testcase was some I/O intense workload together with cpu hotplug stress.
> 
> When trying to bring a cpu online we got an endless loop on the cpu that
> issued the cpu_up and called smp_call_function_single() within its cpu
> hotplug notifier:

[...]

> It looks to me like the IPI(s) was lost when cpu 3 was brought down before:

[...]

> So it looks to me like yet another CPU_DYING cpu hotplug notifier is needed
> for the generic smp code, which looks for pending IPIs on the to be brought
> down cpu and executes them.
> 
> Does that make sense?

Ok, I was able to reproduce it. And the fix should be in the s390 specific
arch code within __cpu_disable() just before the cpu gets removed from the
cpu online mask.
No idea why this never has been seen before.

