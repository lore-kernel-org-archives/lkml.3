Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaAQQrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:47:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38953 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaAQQrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:47:46 -0500
Date: Fri, 17 Jan 2014 17:47:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Message-ID: <20140117164736.GE8715@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
 <20140112092019.GA3664@pd.tnic>
 <52D35ABB.8070904@intel.com>
 <20140113103808.GC5388@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 02:47:15PM +0000, Ren, Qiaowei wrote:
> > do_bounds
> > |->do_mpx_bt_fault
> >    |->allocate_bt
> >       |->sys_mmap_pgoff
> >          |->vm_mmap_pgoff
> >             |->do_mmap_pgoff
> >                |->mmap_region
> >                   |-> kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
> > 
> Sorry for my late reply.
>
> Petkov, could you please detail the problem? Memory allocation can't
> be done in the eception handler? I guess it is like do_page_fault(),
> right?

Right, so Steve and I played a couple of scenarios in IRC with this. So
#BR is comparable with #PF, AFAICT, and as expected we don't take any
locks when handling page faults in kernel space as we might deadlock.

Now, what happens if a thread is sleeping on some lock down that
GFP_KERNEL allocation path and another thread gets a #BR and goes that
same mmap_pgoff path and tries to grab that same lock?

Also, what happens if you take a #BR in NMI context, say the NMI
handler?

All I'm trying to say is, it might not be such a good idea to sleep in a
fault handler...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
