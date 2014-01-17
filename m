Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaAQRLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:11:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17640 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaAQRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:10:57 -0500
Date: Fri, 17 Jan 2014 12:10:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Message-ID: <20140117121054.399b94a9@gandalf.local.home>
In-Reply-To: <20140117164736.GE8715@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
	<1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
	<20140112092019.GA3664@pd.tnic>
	<52D35ABB.8070904@intel.com>
	<20140113103808.GC5388@pd.tnic>
	<9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>
	<20140117164736.GE8715@pd.tnic>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014 17:47:36 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Jan 17, 2014 at 02:47:15PM +0000, Ren, Qiaowei wrote:
> > > do_bounds
> > > |->do_mpx_bt_fault
> > >    |->allocate_bt
> > >       |->sys_mmap_pgoff
> > >          |->vm_mmap_pgoff
> > >             |->do_mmap_pgoff
> > >                |->mmap_region
> > >                   |-> kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
> > > 
> > Sorry for my late reply.
> >
> > Petkov, could you please detail the problem? Memory allocation can't
> > be done in the eception handler? I guess it is like do_page_fault(),
> > right?
> 
> Right, so Steve and I played a couple of scenarios in IRC with this. So
> #BR is comparable with #PF, AFAICT, and as expected we don't take any
> locks when handling page faults in kernel space as we might deadlock.
> 
> Now, what happens if a thread is sleeping on some lock down that
> GFP_KERNEL allocation path and another thread gets a #BR and goes that
> same mmap_pgoff path and tries to grab that same lock?
> 
> Also, what happens if you take a #BR in NMI context, say the NMI
> handler?
> 
> All I'm trying to say is, it might not be such a good idea to sleep in a
> fault handler...
> 

Or do what #PF does. Check if the fault happened in the kernel and go
one path (probably follow what do_fault() does), otherwise if it is
userspace, it's ok to sleep or grab locks or whatever you want.

-- Steve
