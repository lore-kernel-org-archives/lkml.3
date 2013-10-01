Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3JAWvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:51:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33107 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab3JAWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:51:00 -0400
Message-ID: <1380667842.2081.33.camel@dabdike>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in
 print_worker_info() before use
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: Tejun Heo <tj@kernel.org>, Libin <huawei.libin@huawei.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Date: Tue, 01 Oct 2013 15:50:42 -0700
In-Reply-To: <524B47A8.1010701@gmx.de>
References: <20131001203520.GA8248@p100.box>
	  <20131001204352.GA27149@mtj.dyndns.org> <1380663645.2081.29.camel@dabdike>
	 <524B47A8.1010701@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 00:07 +0200, Helge Deller wrote:
> On 10/01/2013 11:40 PM, James Bottomley wrote:
> > On Tue, 2013-10-01 at 16:43 -0400, Tejun Heo wrote:
> >> Hello,
> >>
> >> On Tue, Oct 01, 2013 at 10:35:20PM +0200, Helge Deller wrote:
> >>> print_worker_info() includes no validity check on the pwq and wq
> >>> pointers before handing them over to the probe_kernel_read() functions.
> >>>
> >>> It seems that most architectures don't care about that, but at least on
> >>> the parisc architecture this leads to a kernel crash since accesses to
> >>> page zero are protected by the kernel for security reasons.
> >>>
> >>> Fix this problem by verifying the contents of pwq and wq before usage.
> >>> Even if probe_kernel_read() usually prevents such crashes by disabling
> >>> page faults, clean code should always include such checks. 
> >>>
> >>> Without this fix issuing "echo t > /proc/sysrq-trigger" will immediately
> >>> crash the Linux kernel on the parisc architecture.
> >>
> >> Hmm... um had similar problem but the root cause here is that the arch
> >> isn't implementing probe_kernel_read() properly.  We really have no
> >> idea what the pointer value may be at the dump point and that's why we
> >> use probe_kernel_read().  If something like the above is necessary for
> >> the time being, the correct place would be the arch
> >> probe_kernel_read() implementation.  James, would it be difficult
> >> implement proper probe_kernel_read() on parisc?
> > 
> > The problem seems to be that some traps bypass our exception table
> > handling.  
> 
> Yes, that's correct.
> It's trap #26 and we directly call parisc_terminate() for fault_space==0
> without checking the exception table.
> See my patch I posted a few hours ago which fixes this:
> https://patchwork.kernel.org/patch/2971701/

That doesn't quite look right ... I guessed it was probably access
rights, so we should do an exception table fixup, so isn't this the fix?
because we shouldn't call do_page_fault if there's no exception table.

James

---
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 04e47c6..25a088a 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -684,6 +684,8 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 		/* Fall Through */
 	case 26: 
 		/* PCXL: Data memory access rights trap */
+		if (!user_mode(regs) && fixup_exception(regs))
+			return;
 		fault_address = regs->ior;
 		fault_space   = regs->isr;
 		break;


