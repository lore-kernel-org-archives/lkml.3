Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaAQRPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:15:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31269 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752415AbaAQRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:14:59 -0500
Date: Fri, 17 Jan 2014 12:14:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Message-ID: <20140117121457.0847cde3@gandalf.local.home>
In-Reply-To: <52D95F77.4030908@zytor.com>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
	<1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
	<20140112092019.GA3664@pd.tnic>
	<52D35ABB.8070904@intel.com>
	<20140113103808.GC5388@pd.tnic>
	<9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>
	<20140117164736.GE8715@pd.tnic>
	<52D95F77.4030908@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014 08:51:03 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 01/17/2014 08:47 AM, Borislav Petkov wrote:
> > 
> > Right, so Steve and I played a couple of scenarios in IRC with this. So
> > #BR is comparable with #PF, AFAICT, and as expected we don't take any
> > locks when handling page faults in kernel space as we might deadlock.
> > 
> > Now, what happens if a thread is sleeping on some lock down that
> > GFP_KERNEL allocation path and another thread gets a #BR and goes that
> > same mmap_pgoff path and tries to grab that same lock?
> 
> It goes to sleep.  Same as if we take a page fault and have to page
> something in.

Yep, which is what I was explaining to Boris on IRC.

> 
> > Also, what happens if you take a #BR in NMI context, say the NMI
> > handler?
> 
> You should never, ever do that.  We should never take a #BR in the
> kernel, full stop -- if we do it is panic time.

Right. It should actually do what a page fault does too. If we page
fault in NMI, it reports it and crashes.

> 
> > All I'm trying to say is, it might not be such a good idea to sleep in a
> > fault handler...
> 
> A fault handler from user space is really nothing other than a different
> kind of system call.  It is nothing magic about it.

Exactly. I was saying that #BR should be just like #PF, as it can
detect bugs in the kernel too. The first thing the handler should do is
check to see if the fault occurred in userspace or kernel space. If it
is userspace, then there's no restrictions. If it is kernel space then
we should do the bare minimum to report the bug and then kill whatever
task happened to do it.

-- Steve
