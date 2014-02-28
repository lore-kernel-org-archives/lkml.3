Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaB1Q3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:29:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:17088 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751974AbaB1Q3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:29:48 -0500
Date: Fri, 28 Feb 2014 11:29:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228112946.1f194397@gandalf.local.home>
In-Reply-To: <5310B60F.30806@zytor.com>
References: <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
	<20140228154026.GH9987@twins.programming.kicks-ass.net>
	<5310B60F.30806@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 08:15:11 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Well, I was talking about the assumption spelled out in the comment
> above copy_from_user_nmi() which pretty much states "cr2 is safe because
> cr2 is saved/restored in the NMI wrappers."

Yeah, it seems that the name "copy_from_user_nmi()" is a misnomer. As
it can be called outside of nmi context. Perhaps we should have a
copy_from_user_trace() that does the save and restore of the cr2.

As that's the only place that faults, it may be the best answer.

Arnaldo,

Can you test this patch and see if it fixes the bug for you too. Vince
already said it fixes it for him.

I'm attaching it below (it's from H. Peter).

Peter Z., as both Jiri's and my patch fixed the callers of the problem
area, and as we have been discussing, there may be more problem areas,
I'm thinking the best solution is to just use H. Peter's patch instead.
And then we should rename it to copy_from_user_trace().

-- Steve


diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index ddf9ecb..938e45c 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -10,6 +10,8 @@
 #include <asm/word-at-a-time.h>
 #include <linux/sched.h>
 
+#include <asm/processor.h>
+
 /*
  * We rely on the nested NMI work to allow atomic faults from the NMI path; the
  * nested NMI paths are careful to preserve CR2.
@@ -18,6 +20,7 @@ unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
+	unsigned long cr2;
 
 	if (__range_not_ok(from, n, TASK_SIZE))
 		return 0;
@@ -27,9 +30,11 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	 * disable pagefaults so that its behaviour is consistent even when
 	 * called form other contexts.
 	 */
+	cr2 = read_cr2();
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(to, from, n);
 	pagefault_enable();
+	write_cr2(cr2);
 
 	return ret;
 }

