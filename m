Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3FETRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:17:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44053 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3FETRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:17:38 -0400
Date: Wed, 5 Jun 2013 12:17:06 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] PVH: vcpu info placement, load selectors,
 and remove debug printk.
Message-ID: <20130605121706.3a8211d6@mantra.us.oracle.com>
In-Reply-To: <51AEFED002000078000DB542@nat28.tlf.novell.com>
References: <1370306612-12984-1-git-send-email-mukesh.rathor@oracle.com>
	<51ADC0F702000078000DAF5A@nat28.tlf.novell.com>
	<20130604145304.117ac60f@mantra.us.oracle.com>
	<51AEFED002000078000DB542@nat28.tlf.novell.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jun 2013 08:03:12 +0100
"Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 04.06.13 at 23:53, Mukesh Rathor <mukesh.rathor@oracle.com>
> >>> wrote:
> > Following OK? :
> > 
> >         if (xen_feature(XENFEAT_auto_translated_physmap)) {
> >                 switch_to_new_gdt(0);
> > 
> >                 asm volatile (
> >                         "pushq %%rax\n"
> >                         "leaq 1f(%%rip),%%rax\n"
> >                         "pushq %%rax\n"
> >                         "lretq\n"
> >                         "1:\n"
> >                         : : "a" (__KERNEL_CS) : "memory");
> > 
> >                 return;
> >         }
> 
> While generally the choice of using %%rax instead of %0 here is
> a matter of taste to some degree, I still don't see why you can't
> use "r" as the constraint here in the first place.

The compiler mostly picks eax anyways, but good suggestion.

> Furthermore, assuming this sits in a function guaranteed to not be
> inlined, this has a latent bug (and if the assumption isn't right, the
> bug is real) in that the asm() modifies %rax without telling the
> compiler.

According to one of the unofficial asm tutorials i've here, the compiler
knows since it's input and doesn't need to be told. In fact
it'll barf if added to clobber list.

> This is how I would have done it:
> 
> 		unsigned long dummy;
> 
> 		asm volatile ("pushq %0\n"
> 			      "leaq 1f(%%rip),%0\n"
> 			      "pushq %0\n"
> 			      "lretq\n"
> 			      "1:\n"
> 			      : "=&r" (dummy) : "0" (__KERNEL_CS));
> 

Looks good. Thanks,
Mukesh

