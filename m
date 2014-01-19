Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaASMum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:50:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:46587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaASMuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:50:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,684,1384329600"; 
   d="scan'208";a="461244050"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Thread-Topic: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Thread-Index: AQHPDzsFvFwJDOMjVUqdOlZ/jiA8spqASnOAgAGzAYD///USAIAHFB8w//+cbgCAAAD3gIAABq6AgANZyXA=
Date: Sun, 19 Jan 2014 12:50:14 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014E7A9F@SHSMSX102.ccr.corp.intel.com>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
	<1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
	<20140112092019.GA3664@pd.tnic>	<52D35ABB.8070904@intel.com>
	<20140113103808.GC5388@pd.tnic>
	<9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>
	<20140117164736.GE8715@pd.tnic>	<52D95F77.4030908@zytor.com>
 <20140117121457.0847cde3@gandalf.local.home>
In-Reply-To: <20140117121457.0847cde3@gandalf.local.home>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Saturday, January 18, 2014 1:15 AM
> To: H. Peter Anvin
> Cc: Borislav Petkov; Ren, Qiaowei; Thomas Gleixner; Ingo Molnar;
> x86@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
> bound tables
> 
> On Fri, 17 Jan 2014 08:51:03 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 01/17/2014 08:47 AM, Borislav Petkov wrote:
> > >
> > > Right, so Steve and I played a couple of scenarios in IRC with this.
> > > So #BR is comparable with #PF, AFAICT, and as expected we don't take
> > > any locks when handling page faults in kernel space as we might deadlock.
> > >
> > > Now, what happens if a thread is sleeping on some lock down that
> > > GFP_KERNEL allocation path and another thread gets a #BR and goes
> > > that same mmap_pgoff path and tries to grab that same lock?
> >
> > It goes to sleep.  Same as if we take a page fault and have to page
> > something in.
> 
> Yep, which is what I was explaining to Boris on IRC.
> 
> >
> > > Also, what happens if you take a #BR in NMI context, say the NMI
> > > handler?
> >
> > You should never, ever do that.  We should never take a #BR in the
> > kernel, full stop -- if we do it is panic time.
> 
> Right. It should actually do what a page fault does too. If we page fault in NMI,
> it reports it and crashes.
> 
> >
> > > All I'm trying to say is, it might not be such a good idea to sleep
> > > in a fault handler...
> >
> > A fault handler from user space is really nothing other than a
> > different kind of system call.  It is nothing magic about it.
> 
> Exactly. I was saying that #BR should be just like #PF, as it can detect bugs in
> the kernel too. The first thing the handler should do is check to see if the fault
> occurred in userspace or kernel space. If it is userspace, then there's no
> restrictions. If it is kernel space then we should do the bare minimum to report
> the bug and then kill whatever task happened to do it.
> 
Yes. I guess I know what you mean and this detection is necessary.

The following check should be added into at the beginning of this handler.

        if (!user_mode(regs)) {
                if (!fixup_exception(regs)) {
                        tsk->thread.error_code = error_code;
                        tsk->thread.trap_nr = trapnr;
                        die(str, regs, error_code);
                }
        }

Thanks,
Qiaowei

