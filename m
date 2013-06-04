Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FDI1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:27:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58876 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3FDI1I convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 4 Jun 2013 04:27:08 -0400
Message-Id: <51ADC0F702000078000DAF5A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 04 Jun 2013 09:27:03 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mukesh Rathor" <mukesh.rathor@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] PVH: vcpu info placement, load
 selectors, and remove debug printk.
References: <1370306612-12984-1-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1370306612-12984-1-git-send-email-mukesh.rathor@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.06.13 at 02:43, Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> @@ -1327,6 +1329,18 @@ static void __init xen_setup_stackprotector(void)
>  	/* PVH TBD/FIXME: investigate setup_stack_canary_segment */
>  	if (xen_feature(XENFEAT_auto_translated_physmap)) {
>  		switch_to_new_gdt(0);
> +
> +		/* xen started us with null selectors. load them now */
> +		__asm__ __volatile__ (
> +			"movl %0,%%ds\n"
> +			"movl %0,%%ss\n"
> +			"pushq %%rax\n"
> +			"leaq 1f(%%rip),%%rax\n"
> +			"pushq %%rax\n"
> +			"retfq\n"
> +			"1:\n"
> +			: : "r" (__KERNEL_DS), "a" (__KERNEL_CS) : "memory");
> +

I can see why you want CS to be reloaded (and CS, other than the
comment says, clearly hasn't been holding a null selector up to here.

I can't immediately see why you'd need SS to be other than null, and
it completely escapes me why you'd need to DS (but not ES) to be
non-null.

Furthermore, is there any reason why you use "retfq" (Intel syntax)
when all assembly code otherwise uses AT&T syntax (the proper
equivalent here would be "lretq")?

And finally, please consistently use %<number> (which, once
fixed, will make clear that the second constraint really can be "r"),
and avoid using suffixes on moves to/from selector registers
(which, once fixed, will make clear that at least the first constraint
really can be relaxed to "rm").

Jan

