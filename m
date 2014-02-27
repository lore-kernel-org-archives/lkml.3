Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaB0QUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:20:55 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49986 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaB0QUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:20:53 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 27 Feb 2014 08:20:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Jones <drjones@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 03/46] kernel: Move prototype declaration to header file
 include/linux/cpu.h
Message-ID: <20140227162042.GG26756@thin>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <2f6da4289a80fcde70aec12f65c135fbf719e338.1393493276.git.rashika.kheria@gmail.com>
 <1393513469.6784.58.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1393513469.6784.58.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:04:29AM -0700, Toshi Kani wrote:
> On Thu, 2014-02-27 at 16:42 +0530, Rashika Kheria wrote:
> > Add prototype declaration to header file include/linux/cpu.h because
> > they are used by more than one file.
> > 
> > This eliminates the following warning in kernel/cpu.c:
> > kernel/cpu.c:512:13: warning: no previous prototype for ‘arch_enable_nonboot_cpus_begin’ [-Wmissing-prototypes]
> > kernel/cpu.c:516:13: warning: no previous prototype for ‘arch_enable_nonboot_cpus_end’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  arch/x86/kernel/smpboot.c |    1 +
> >  include/linux/cpu.h       |    2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index a32da80..e428764 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -49,6 +49,7 @@
> >  #include <linux/bootmem.h>
> >  #include <linux/err.h>
> >  #include <linux/nmi.h>
> > +#include <linux/cpu.h>
> >  #include <linux/tboot.h>
> >  #include <linux/stackprotector.h>
> >  #include <linux/gfp.h>
> > diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> > index 03e235ad..9f633b0 100644
> > --- a/include/linux/cpu.h
> > +++ b/include/linux/cpu.h
> > @@ -38,6 +38,8 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
> >  
> >  extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
> >  extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
> > +void arch_enable_nonboot_cpus_begin(void);
> > +void arch_enable_nonboot_cpus_end(void);
> 
> Can we simply include linux/smp.h, which defines them already?

Ah, looks like those prototypes were only added to linux/smp.h very
recently, to fix this exact issue, in:

commit fb37bb04d6c8d6c44e61d9da189dcfa6aa0f135e
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Mon Feb 10 14:25:49 2014 -0800

    smp.h: fix x86+cpu.c sparse warnings about arch nonboot CPU calls

    Use what we already do for arch_disable_smp_support() to fix these:

      arch/x86/kernel/smpboot.c:1155:6: warning: symbol 'arch_enable_nonboot_cpus_begin' was not declared. Should it be static?
      arch/x86/kernel/smpboot.c:1160:6: warning: symbol 'arch_enable_nonboot_cpus_end' was not declared. Should it be static?
      kernel/cpu.c:512:13: warning: symbol 'arch_enable_nonboot_cpus_begin' was not declared. Should it be static?
      kernel/cpu.c:516:13: warning: symbol 'arch_enable_nonboot_cpus_end' was not declared. Should it be static?
