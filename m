Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaLDDQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:16:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41845 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbaLDDQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:16:43 -0500
Date: Wed, 3 Dec 2014 22:15:53 -0500
From: Chris Mason <clm@fb.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141204031553.GA20193@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com>
 <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
 <CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
 <alpine.DEB.2.11.1412032137210.16275@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412032137210.16275@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-04_02:2014-12-03,2014-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=42.9673870319736
 compositescore=0.182402046397986 urlsuspect_oldscore=0.182402046397986
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=29 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412040032
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I asked Dave for his lockups from 3.17-rc1, and they were in the
flush_tlb code waiting for remote CPUs to finish flushing.  It feels
like that's a common theme, and there are a few commits there between
3.16 and 3.17.

One guess is that trinity is generating a huge number of tlb
invalidations over sparse and horrible ranges.  Perhaps the old code was
falling back to full tlb flushes before Dave Hansen's string of fixes?

commit a5102476a24bce364b74f1110005542a2c964103
Author: Dave Hansen <dave.hansen@linux.intel.com>

    x86/mm: Set TLB flush tunable to sane value (33)

This entirely untested diff forces full tlb flushes on the remote CPUs.
It adds a few parens for good luck, but the nr_pages var is only sent to
ftrace, so it's not the bug we're looking for.

I'm only changing the flushes done on remote CPUs.  The local CPU is
still doing up to 33 fine grained flushes.  That may or may not be a
good idea, but my hand waiving only makes sense to me if we've got a
long string of fine grained flushes from tons of procs fanning out to
the remote CPUs.

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index ee61c36..72c4ff0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -120,7 +120,7 @@ static void flush_tlb_func(void *info)
 		} else {
 			unsigned long addr;
 			unsigned long nr_pages =
-				f->flush_end - f->flush_start / PAGE_SIZE;
+				(f->flush_end - f->flush_start) / PAGE_SIZE;
 			addr = f->flush_start;
 			while (addr < f->flush_end) {
 				__flush_tlb_single(addr);
@@ -214,10 +214,8 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	}
 	trace_tlb_flush(TLB_LOCAL_MM_SHOOTDOWN, base_pages_to_flush);
 out:
-	if (base_pages_to_flush == TLB_FLUSH_ALL) {
-		start = 0UL;
-		end = TLB_FLUSH_ALL;
-	}
+	start = 0UL;
+	end = TLB_FLUSH_ALL;
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, start, end);
 	preempt_enable();
