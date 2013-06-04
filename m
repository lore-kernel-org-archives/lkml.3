Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab3FDVx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:53:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3FDVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:53:24 -0400
Date: Tue, 4 Jun 2013 14:53:04 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] PVH: vcpu info placement, load selectors,
 and remove debug printk.
Message-ID: <20130604145304.117ac60f@mantra.us.oracle.com>
In-Reply-To: <51ADC0F702000078000DAF5A@nat28.tlf.novell.com>
References: <1370306612-12984-1-git-send-email-mukesh.rathor@oracle.com>
	<51ADC0F702000078000DAF5A@nat28.tlf.novell.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jun 2013 09:27:03 +0100
"Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 04.06.13 at 02:43, Mukesh Rathor <mukesh.rathor@oracle.com>
> >>> wrote:
> > @@ -1327,6 +1329,18 @@ static void __init
> > xen_setup_stackprotector(void) /* PVH TBD/FIXME: investigate
> > setup_stack_canary_segment */ if
> > (xen_feature(XENFEAT_auto_translated_physmap))
> > { switch_to_new_gdt(0); +
> > +		/* xen started us with null selectors. load them
> > now */
> > +		__asm__ __volatile__ (
> > +			"movl %0,%%ds\n"
> > +			"movl %0,%%ss\n"
> > +			"pushq %%rax\n"
> > +			"leaq 1f(%%rip),%%rax\n"
> > +			"pushq %%rax\n"
> > +			"retfq\n"
> > +			"1:\n"
> > +			: : "r" (__KERNEL_DS), "a" (__KERNEL_CS) :
> > "memory"); +
> 
> I can see why you want CS to be reloaded (and CS, other than the
> comment says, clearly hasn't been holding a null selector up to here.
> 
> I can't immediately see why you'd need SS to be other than null, and
> it completely escapes me why you'd need to DS (but not ES) to be
> non-null.
> 
> Furthermore, is there any reason why you use "retfq" (Intel syntax)
> when all assembly code otherwise uses AT&T syntax (the proper
> equivalent here would be "lretq")?
> 
> And finally, please consistently use %<number> (which, once
> fixed, will make clear that the second constraint really can be "r"),
> and avoid using suffixes on moves to/from selector registers
> (which, once fixed, will make clear that at least the first constraint
> really can be relaxed to "rm").

Following OK? :

        if (xen_feature(XENFEAT_auto_translated_physmap)) {
                switch_to_new_gdt(0);

                asm volatile (
                        "pushq %%rax\n"
                        "leaq 1f(%%rip),%%rax\n"
                        "pushq %%rax\n"
                        "lretq\n"
                        "1:\n"
                        : : "a" (__KERNEL_CS) : "memory");

                return;
        }

thanks,
Mukesh

