Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935459Ab3DJLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:16:26 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51077 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3DJLQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:16:25 -0400
Date: Wed, 10 Apr 2013 13:16:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130410111620.GB29752@gmail.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408165916.GA3672@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> On Mon, Apr 08, 2013 at 09:11:06AM -0700, H. Peter Anvin wrote:
> > On 04/08/2013 08:57 AM, Ingo Molnar wrote:
> > > 
> > > I think the original commit:
> > > 
> > >   f96972f2dc63 kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
> > > 
> > > actually regressed your 1024 CPU systems, and should possibly be reverted or fixed 
> > > in some other fashion - such as by migrating to the primary CPU (on architectures 
> > > that require that), instead of hotplug offlining every secondary CPU on every 
> > > architecture!
> > > 
> > > Alternatively, disable_nonboot_cpus() could perhaps be improved to down CPUs in 
> > > parallel: issue the CPU-down requests to every CPU, then wait for them to complete 
> > > - instead of the loop over every CPU?
> > > 
> > > This would be the conceptual counter part to parallel boot up of CPUs - something 
> > > SGI might be interested in as well?
> > > 
> > 
> > Migrating to the boot processor and then calling stop_machine() to
> > defang any other processors should be sufficient, no?
> > 
> > I don't know if there is any reason to deschedule all tasks?
> 
> My reading of the original commit indicated that some architecture's
> firmware needs the boot cpu to be the one initiating reboot.
> 
> If that is correct, then I can not see why a stop_machine() implementation
> will not work.
> 
> Since this is in generic kernel code, how can I proceed?

I think rebooting on the same CPU where we booted up is something worth having in 
general, as a firmware robustness feature. (assuming the CPU in question is still 
online)

We have similar constraints in the suspend code for example - some x86 firmware 
breaks if suspend related ACPI calls are not done on the boot CPU ...

So how about restoring the old "just reboot, don't shut down the others" behavior, 
extended with a "reboot on the CPU that booted up" reboot affinity logic?

That should fix the 1024 CPUs regression, and it should also keep those ARM 
systems working - without any special casing.

Of course I'd also be entirely happy about having true parallel shutdown...

It does not have to be entirely threaded: I bet most of the shutdown latency is in 
a few paranoia udelay()s or so, where some simple global lock could be dropped.

Thanks,

	Ingo
