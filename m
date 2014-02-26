Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaBZMNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:13:20 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53144 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaBZMNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:13:18 -0500
Date: Wed, 26 Feb 2014 19:12:59 +0700
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: davej@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140226121256.GA8494@debian.local>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530CCFD2.3050007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:16:02AM -0800, H. Peter Anvin wrote:
> On 02/25/2014 08:26 AM, Dave Jones wrote:
> > On Tue, Feb 25, 2014 at 02:45:57AM -0800, H. Peter Anvin wrote:
> >  > On 02/24/2014 10:01 PM, Chris Bainbridge wrote:
> >  > > Pentium M is PAE capable but does not indicate so in the CPUID response.
> >  > > This is an issue now that some distributions are no longer shipping
> >  > > non-PAE kernels (those distributions no longer boot on Pentium M). This
> >  > > small patch fixes the issue by forcing the PAE capability on Pentium M.
> >  > >
> >  > > For more discussion see https://bugs.launchpad.net/baltix/+bug/930447
> >  > >
> >  > 
> >  > 1. This patch doesn't match the discussion in the link.
> >  > 2. You would have to also enable this in the cpu testing code in
> >  >     arch/x86/boot.
> >  > 3. At the very least we need to print a serious warning that the CPU
> >  >     is being run outside its specifications.  I have no personal
> >  >     information about why this CPUID bit was disabled, but it could be
> >  >     that it was discovered in testing that it didn't work correctly in
> >  >     all circumstances (e.g. high temperature.)  This is very much "use
> >  >     at your own risk..."; you could get data corruption or even
> >  >     hardware damage.
> > 
> > About six years ago, we almost went down this same path for Fedora,
> > and I'm fairly sure the only reason we backed off and decided to not
> > pursue it was that we found some Pentium M's where it just didn't work.
> > 
> 
> OK, that *definitely* means that if we're doing this at all we're doing
> it via an explicit opt-in on the command line, and tainting the kernel
> in the process.
> 
> I don't know if anyone (Chris?) is interested enough in the problem to
> do such a patch, though.  I know I'm not too interested in spending a
> bunch of time on.
> 
> 	-hpa
> 

The basic findings of the bug discussion is that people are successfully
running PAE kernels on Pentium M (for some unknown reason Grub skips the
validate_cpu code in the kernel, so existing PAE kernels will run
unmodified, although they do fail when booted with syslinux), and people
are using a user-space hack to add "pae" to /proc/cpuinfo.

In all of the testing reported on the Launchpad bug and elsewhere, every
user who managed to boot a PAE kernel on Pentium M reported success.
There was a single report of failure, but the user encountered the "This
kernel requires the following features" message, so the failure was
caused by some issue of his boot setup not skipping the cpu validation
code, rather than a PAE failure in the Pentium M.

It is possible that PAE was disabled for technical reasons, or for
commercial reasons (e.g. to discourage vendors from building Pentium M
servers). We don't know. What we do know is that people are using PAE
kernels on Pentium M systems, and that not all are aware of the
implications (for a user with an existing install of Debian who apt-gets a
PAE kernel, it will install and boot (thanks to Grub) and no errors or
warnings will have been shown to indicate that their system is now
running "out of spec")

I have made the requested changes to the patch:
---
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4d3ff03..3220734 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -151,6 +151,16 @@ static void get_flags(void)
 			    : : "ebx");
 		}
 	}
+
+	if (cmdline_find_option_bool("forcepae")) {
+		puts("WARNING: Forcing PAE in CPU flags\n");
+		set_bit(X86_FEATURE_PAE, cpu.flags);
+	}
+	else if ((cpu.level == 6) && ((cpu.model == 9) || (cpu.model == 13))) {
+		puts("Pentium M: PAE is disabled, "
+		     "enable it with kernel argument \"forcepae\"\n"
+		     "(\"forcepae\" is unsupported and will taint the kernel)\n");
+	}
 }
 
 /* Returns a bitmask of which words we have error bits in */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bbe1b8b..1047098 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -196,6 +196,14 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
 	}
 }
 
+static int forcepae;
+static int __init forcepae_setup(char *__unused)
+{
+	forcepae = 1;
+	return 1;
+}
+__setup("forcepae", forcepae_setup);
+
 static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
@@ -226,6 +234,15 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
+	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
+	 */
+	if (forcepae) {
+		printk(KERN_WARNING "PAE forced!\n");
+		set_cpu_cap(c, X86_FEATURE_PAE);
+		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
+	}
+
+	/*
 	 * P4 Xeon errata 037 workaround.
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
