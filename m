Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3AKJnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:43:12 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56883 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab3AKJnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:43:09 -0500
Message-ID: <50EFDEA8.2070505@imgtec.com>
Date: Fri, 11 Jan 2013 09:43:04 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Maynard Johnson <maynardj@us.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <oprofile-list@lists.sf.net>
Subject: Re: [PATCH v3 41/44] metag: OProfile
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-42-git-send-email-james.hogan@imgtec.com> <50EEF67F.4010703@us.ibm.com>
In-Reply-To: <50EEF67F.4010703@us.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/mixed;
	boundary="------------050702080800020604030507"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_09_43_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050702080800020604030507
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi Maynard,

On 10/01/13 17:12, Maynard Johnson wrote:
>> +static void kernel_backtrace_fp(unsigned long *fp, unsigned long *stack,
>> +				unsigned int depth)
>> +{
...
>> +#ifdef CONFIG_KALLSYMS
>> +		/* If we've reached TBIBoingVec then we're at an interrupt
>> +		 * entry point or a syscall entry point. The frame pointer
>> +		 * points to a pt_regs which can be used to continue tracing on
>> +		 * the other side of the boing.
>> +		 */
>> +		if (tbi_boing_size && addr >= tbi_boing_addr &&
>> +				addr < tbi_boing_addr + tbi_boing_size) {
>> +			struct pt_regs *regs = (struct pt_regs *)fp;
>> +			/* OProfile doesn't understand backtracing into
>> +			 * userland.
>> +			 */
> Since we can only get into kernel_backtrace_fp if user_mode(regs) == 0, why the if-statement?

Because this regs comes from the stack, so it could be a userland
context from the point of entry into the kernel.

>> +			if (!user_mode(regs) && --depth) {
>> +				oprofile_add_trace(regs->ctx.CurrPC);
>> +				metag_backtrace(regs, depth);
>> +			}
...
>> +
>> +/*
>> + * Unfortunately we don't have a native exception or interrupt for counter
>> + * overflow.
>> + *
>> + * OProfile on the other hand likes to have samples taken periodically, so
>> + * for now we just piggyback the timer interrupt to get the expected
>> + * behavior.
>> + */
>> +
> I presume an oprofile userspace patch is forthcoming.

Yes, unfortunately it's not included in our public buildroot tree yet,
but there's a slightly older patch (semantically identical) available in
the Pure ONE Flow release from http://www.pure.com/gpl/ in
metag-buildroot2/package/oprofile/oprofile-0.9.4-003-metag.patch and
also attached to this email.

It could probably do with some updating tbh though...

> As you probably know already, each event definition in oprofile
userspace requires a minimum 'count' value, which is the number of
events to occur before taking a sample.  With your userspace patch, you
should try to set min count values such that the fastest arrival rate
for the given event can be caught within (or near) one timer tick.

Yes, it appears the values are all left at 1000 in the patch which is
likely suboptimal.

>> +static int meta_timer_notify(struct pt_regs *regs)
>> +{
>> +	int i;
>> +	u32 val, total_val, sub_val;
>> +	u32 enabled_threads;
>> +
>> +	for (i = 0; i < NR_CNTRS; i++) {
>> +		if (!ctr[i].enabled)
>> +			continue;
>> +
>> +		/* Disable performance monitoring. */
>> +		enabled_threads = meta_read_counter(i);
>> +		meta_write_counter(i, 0);
>> +
>> +		sub_val = total_val = val = enabled_threads & PERF_COUNT_BITS;
>> +
>> +		if (val >= ctr[i].count) {
>> +			while (val > ctr[i].count) {
>> +				oprofile_add_sample(regs, i);
> I don't see a good reason for adding multiple samples using the same regs values.  As a matter of fact, it could really skew results under certain conditions.

I suspect the reasoning was to give more weight if the count is higher.
If that's not the usual way I'll change it.

Thanks for giving it a look.

Cheers
James

--------------050702080800020604030507
Content-Type: text/x-patch; name="oprofile-0.9.4-003-metag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="oprofile-0.9.4-003-metag.patch"

diff -ruNP oprofile-0.9.4.orig/daemon/opd_cookie.c oprofile-0.9.4/daemon/opd_cookie.c
--- oprofile-0.9.4.orig/daemon/opd_cookie.c	2008-05-21 13:30:15.000000000 +0100
+++ oprofile-0.9.4/daemon/opd_cookie.c	2009-12-01 17:10:37.000000000 +0000
@@ -64,7 +64,8 @@
 	|| (defined(__mips__) && (_MIPS_SIM == _MIPS_SIM_ABI32) \
 	    && defined(__MIPSEB__)) \
         || (defined(__arm__) && defined(__ARM_EABI__) \
-            && defined(__ARMEB__))
+            && defined(__ARMEB__)) \
+		|| (defined(__metag__))
 static inline int lookup_dcookie(cookie_t cookie, char * buf, size_t size)
 {
 	return syscall(__NR_lookup_dcookie, (unsigned long)(cookie >> 32),
diff -ruNP oprofile-0.9.4.orig/events/metag/events oprofile-0.9.4/events/metag/events
--- oprofile-0.9.4.orig/events/metag/events	1970-01-01 01:00:00.000000000 +0100
+++ oprofile-0.9.4/events/metag/events	2009-12-01 17:09:35.000000000 +0000
@@ -0,0 +1,12 @@
+# metag events
+#
+event:0x00 counters:0,1 um:threads minimum:1000 name:CYCLES_SUPERTHREADS : cycles with superthreads
+event:0x01 counters:0,1 um:threads minimum:1000 name:DCACHE_MISS : data cache misses
+event:0x02 counters:0,1 um:threads minimum:1000 name:CYCLES_WITH_REWINDS : cycles with rewinds and superthreads (for all threads)
+event:0x03 counters:0,1 um:threads minimum:1000 name:CYCLES_SINCE_START : cycles since execution start (for all threads)
+event:0x08 counters:0,1 um:threads minimum:1000 name:DCACHE_HITS : data cache hits
+event:0x09 counters:0,1 um:threads minimum:1000 name:ICACHE_HITS : instruction cache hits
+event:0x0a counters:0,1 um:threads minimum:1000 name:ICACHE_MISS : instruction cache misses
+event:0x0b counters:0,1 um:threads minimum:1000 name:CYCLES_DCACHE_STALLED : cycles data cache stalled at MMU
+event:0x0c counters:0,1 um:threads minimum:1000 name:CYCLES_ICACHE_STALLED : cycles instruction cache stalled at MMU
+event:0x0f counters:0,1 um:threads minimum:1000 name:EXTERNAL_EVENTS : external events selected by crossbar performance channel 0 register
diff -ruNP oprofile-0.9.4.orig/events/metag/unit_masks oprofile-0.9.4/events/metag/unit_masks
--- oprofile-0.9.4.orig/events/metag/unit_masks	1970-01-01 01:00:00.000000000 +0100
+++ oprofile-0.9.4/events/metag/unit_masks	2009-12-01 17:09:35.000000000 +0000
@@ -0,0 +1,10 @@
+# metag performance counters possible unit masks
+#
+# These are used to turn on performance counting for
+# particular threads.
+name:threads type:bitmask default:0x0f
+	0x01 Monitor Thread 1
+	0x02 Monitor Thread 2
+	0x03 Monitor Thread 3
+	0x04 Monitor Thread 4
+	0x0f Monitor all threads
diff -ruNP oprofile-0.9.4.orig/libop/op_cpu_type.c oprofile-0.9.4/libop/op_cpu_type.c
--- oprofile-0.9.4.orig/libop/op_cpu_type.c	2008-02-22 16:17:48.000000000 +0000
+++ oprofile-0.9.4/libop/op_cpu_type.c	2009-12-01 17:09:35.000000000 +0000
@@ -74,6 +74,7 @@
 	{ "ppc64 POWER5++", "ppc64/power5++", CPU_PPC64_POWER5pp, 6 },
 	{ "e300", "ppc/e300", CPU_PPC_E300, 4 },
 	{ "AVR32", "avr32", CPU_AVR32, 3 },
+	{ "metag", "metag", CPU_META, 2 },
 };
  
 static size_t const nr_cpu_descrs = sizeof(cpu_descrs) / sizeof(struct cpu_descr);
diff -ruNP oprofile-0.9.4.orig/libop/op_cpu_type.h oprofile-0.9.4/libop/op_cpu_type.h
--- oprofile-0.9.4.orig/libop/op_cpu_type.h	2008-02-22 16:17:48.000000000 +0000
+++ oprofile-0.9.4/libop/op_cpu_type.h	2009-12-01 17:09:35.000000000 +0000
@@ -72,6 +72,7 @@
 	CPU_PPC64_POWER5pp,  /**< ppc64 Power5++ family */
 	CPU_PPC_E300, /**< e300 */
 	CPU_AVR32, /**< AVR32 */
+	CPU_META, /**< META */
 	MAX_CPU_TYPE
 } op_cpu;
 
diff -ruNP oprofile-0.9.4.orig/libop/op_events.c oprofile-0.9.4/libop/op_events.c
--- oprofile-0.9.4.orig/libop/op_events.c	2008-02-22 16:17:48.000000000 +0000
+++ oprofile-0.9.4/libop/op_events.c	2009-12-01 17:09:35.000000000 +0000
@@ -852,6 +852,11 @@
 			descr->name = "CPU_CLK";
 			break;
 
+		case CPU_META:
+			descr->name = "CYCLES_SINCE_START";
+			descr->um = 0x01;	// Monitor thread 1 perf
+			break;
+
 		// don't use default, if someone add a cpu he wants a compiler
 		// warning if he forgets to handle it here.
 		case CPU_TIMER_INT:
diff -ruNP oprofile-0.9.4.orig/libutil/op_cpufreq.c oprofile-0.9.4/libutil/op_cpufreq.c
--- oprofile-0.9.4.orig/libutil/op_cpufreq.c	2003-11-04 04:26:45.000000000 +0000
+++ oprofile-0.9.4/libutil/op_cpufreq.c	2009-12-02 10:19:20.000000000 +0000
@@ -51,6 +51,9 @@
 			fval = uval / 1E6;
 			break;
 		}
+		/* metag */
+		if (sscanf(line, "Clocking: %lfMHz", &fval) == 1)
+			break;
 		/* s390 doesn't provide cpu freq, checked up to 2.6-test4 */
 
 		free(line);

--------------050702080800020604030507--

