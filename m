Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3FEHDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:03:24 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45826 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3FEHDX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 5 Jun 2013 03:03:23 -0400
Message-Id: <51AEFED002000078000DB542@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 05 Jun 2013 08:03:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mukesh Rathor" <mukesh.rathor@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] PVH: vcpu info placement, load
 selectors, and remove debug printk.
References: <1370306612-12984-1-git-send-email-mukesh.rathor@oracle.com>
 <51ADC0F702000078000DAF5A@nat28.tlf.novell.com>
 <20130604145304.117ac60f@mantra.us.oracle.com>
In-Reply-To: <20130604145304.117ac60f@mantra.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.06.13 at 23:53, Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> Following OK? :
> 
>         if (xen_feature(XENFEAT_auto_translated_physmap)) {
>                 switch_to_new_gdt(0);
> 
>                 asm volatile (
>                         "pushq %%rax\n"
>                         "leaq 1f(%%rip),%%rax\n"
>                         "pushq %%rax\n"
>                         "lretq\n"
>                         "1:\n"
>                         : : "a" (__KERNEL_CS) : "memory");
> 
>                 return;
>         }

While generally the choice of using %%rax instead of %0 here is
a matter of taste to some degree, I still don't see why you can't
use "r" as the constraint here in the first place.

Furthermore, assuming this sits in a function guaranteed to not be
inlined, this has a latent bug (and if the assumption isn't right, the
bug is real) in that the asm() modifies %rax without telling the
compiler.

This is how I would have done it:

		unsigned long dummy;

		asm volatile ("pushq %0\n"
			      "leaq 1f(%%rip),%0\n"
			      "pushq %0\n"
			      "lretq\n"
			      "1:\n"
			      : "=&r" (dummy) : "0" (__KERNEL_CS));

(also dropping the memory clobber, as I don't see what you
need this for).

Jan

