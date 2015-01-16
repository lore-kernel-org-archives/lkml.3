Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbbAPKWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:22:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:33010 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbbAPKWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:22:09 -0500
Date: Fri, 16 Jan 2015 11:21:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 00/23] x86: Cleanup apic/ioapic/x2apic setup code
In-Reply-To: <54B8DBC1.6080205@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501161120560.5526@nanos>
References: <20150115210458.625399149@linutronix.de> <54B8DBC1.6080205@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Jiang Liu wrote:
> On 2015/1/16 5:22, Thomas Gleixner wrote:
> > While reviewing Jiangs interrupt remapping patch set, I had several
> > serious WTF moments when trying to understand what that code is doing.
> > 
> > The main issues I've seen are:
> > 
> >     - Blindly copy and pasted code
> > 
> >     - Random places which initialize bits and pieces
> > 
> >     - Code which got mindlessly expanded with duct tape and glue
> >       without considering readability and maintainability.
> > 
> >     - Missing inline stubs which result in a ifdef nightmare
> > 
> >     - Superflous inline stubs to artificially avoid sensible ifdefs
> > 
> > The deeper I looked the more I started to get grumpy about that maze
> > and finally sat down and cleaned it up seriously. One bug I fixed on
> > the way (surprise, surprise) got folded into Jiangs series which is
> > now in tip/x86/apic. The other one is not that crucial and cant be
> > fixed in the previous code without adding more mess.
> > 
> > The following patch series applies on top of tip/x86/apic. It cleans
> > up and consolidates the apic/ioapic/x2apic setup functions.
> > 
> > Please give it a proper review and testing.
> Hi Thomas,
> 
> Have done following test matrix:
> 1) Hardware X2apic capable: yes, preenabled by BIOS: no,
>    Kernel: x2apic capable smp
> 1.1) boot: ok
> 1.2) boot with "nox2apic": ok
> 1.3) boot with "nointremap": ok with CPU in physical flat mode
> 
> 2) Hardware X2apic capable: yes, preenabled by BIOS: no,
>    Kernel: x2apic incapable smp
> 2.1) boot: ok
> 
> 3) Hardware X2apic capable: yes, preenabled by BIOS: yes
> 3.1) x2apic capable kernel: ok
> 3.2) x2apic incapable kernel: hang with a blank screen(panic)
>    Kernel: x2apic capable smp
> 
> 4) Hardware X2apic capable: no
> 4.1) boot x2apic capable smp kernel: ok
> 4.2) boot x2apic incapable up kernel: ok
> 4.3) boot xen domain0 with x2apic capable smp kernel: ok
> 
> 5) x86_32, UP, IO_APIC disabled
> 5.1) boot: panic with following call stack:
> do_ono_initcall()->APIC_init_uniprocessor()->setup_local_APIC().
> I can't capture the full log message due to lack of serial console.
> It seems we have trouble with:
> early_initcall(APIC_init_uniprocessor);

Hmm, worked here. Lemme find some other machine.

