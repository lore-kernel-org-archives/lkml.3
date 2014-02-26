Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaBZRHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:07:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaBZRHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:07:06 -0500
Date: Wed, 26 Feb 2014 10:49:49 -0500
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140226154949.GA770@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
 <20140226131852.GA22690@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226131852.GA22690@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:18:52PM +0100, Borislav Petkov wrote:
 > On Wed, Feb 26, 2014 at 07:12:59PM +0700, Chris Bainbridge wrote:
 > > @@ -226,6 +234,15 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 > >  		clear_cpu_cap(c, X86_FEATURE_SEP);
 > >  
 > >  	/*
 > > +	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
 > > +	 */
 > > +	if (forcepae) {
 > > +		printk(KERN_WARNING "PAE forced!\n");
 > > +		set_cpu_cap(c, X86_FEATURE_PAE);
 > > +		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
 > 
 > This is certainly the wrong taint flag. We'd need a new one or to
 > repurpose another one as I suggested in a previous mail.

I'd suggest repurposing 'S'. Instead of 'unsafe smp', it could mean
"out of Spec". We currently only use that flag on some ancient athlon xp,
so there's not going to be any kind of collision.

Start with the below maybe ?

	Dave

Rename TAINT_UNSAFE_SMP to TAINT_CPU_OUT_OF_SPEC, so we can repurpose the
flag to encompass a wider range of problems.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c67ffa686064..7ec4119b381c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -218,7 +218,7 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	 */
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
-	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
+	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 196d1ea86df0..08fb02477641 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -458,7 +458,7 @@ extern enum system_states {
 
 #define TAINT_PROPRIETARY_MODULE	0
 #define TAINT_FORCED_MODULE		1
-#define TAINT_UNSAFE_SMP		2
+#define TAINT_CPU_OUT_OF_SPEC		2
 #define TAINT_FORCED_RMMOD		3
 #define TAINT_MACHINE_CHECK		4
 #define TAINT_BAD_PAGE			5
diff --git a/kernel/module.c b/kernel/module.c
index d24fcf29cb64..ca2c1aded7ee 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1015,7 +1015,7 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 		buf[l++] = 'C';
 	/*
 	 * TAINT_FORCED_RMMOD: could be added.
-	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
+	 * TAINT_CPU_OUT_OF_SPEC, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
 	 * apply to modules.
 	 */
 	return l;
diff --git a/kernel/panic.c b/kernel/panic.c
index 2feab00c73ba..6900b83d17f5 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -199,7 +199,7 @@ struct tnt {
 static const struct tnt tnts[] = {
 	{ TAINT_PROPRIETARY_MODULE,	'P', 'G' },
 	{ TAINT_FORCED_MODULE,		'F', ' ' },
-	{ TAINT_UNSAFE_SMP,		'S', ' ' },
+	{ TAINT_CPU_OUT_OF_SPEC,	'S', ' ' },
 	{ TAINT_FORCED_RMMOD,		'R', ' ' },
 	{ TAINT_MACHINE_CHECK,		'M', ' ' },
 	{ TAINT_BAD_PAGE,		'B', ' ' },
