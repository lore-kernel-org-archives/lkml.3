Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaB1PaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:30:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:57451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751925AbaB1PaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:30:07 -0500
Date: Fri, 28 Feb 2014 10:30:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228103005.0dbe31e1@gandalf.local.home>
In-Reply-To: <20140228102000.0e953a46@gandalf.local.home>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<20140224193043.GP6835@laptop.programming.kicks-ass.net>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<20140228102000.0e953a46@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 10:20:00 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Below is a patch that should fix this. Please remove all other patches
> and try this out.

Updated patch, as Peter Zijlstra on IRC asked me if the
exception_enter() can be traced. And looking at it, it sure can be.

-- Steve

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6dea040..f606b67 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1271,9 +1271,15 @@ dotraplinkage void __kprobes
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	unsigned long cr2;
 
+	/* The trace might fault, save the cr2 register */
+	cr2 = read_cr2();
 	prev_state = exception_enter();
 	trace_page_fault_entries(regs, error_code);
+	/* Put back the original cr2 if needed */
+	if (cr2 != read_cr2())
+		write_cr2(cr2);
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
