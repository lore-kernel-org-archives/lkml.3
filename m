Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaLJK1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:27:18 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42359 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaLJK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:27:16 -0500
Date: Wed, 10 Dec 2014 15:56:34 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Subject: Re: [RFC PATCH 1/8] kprobes: Fix kallsyms lookup across powerpc
 ABIv1 and ABIv2
Message-ID: <20141210102634.GA16045@naverao1-tp.in.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <7a96a9c262a818112955da93f8ff1ada1bfe5c59.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <1418204242.9279.4.camel@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418204242.9279.4.camel@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121010-0009-0000-0000-000002D47DA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 08:37PM, Michael Ellerman wrote:
> On Tue, 2014-12-09 at 23:03 +0530, Naveen N. Rao wrote:
> > Currently, all non-dot symbols are being treated as function descriptors
> > in ABIv1. This is incorrect and is resulting in perf probe not working:
> 
> I don't understand that first sentence. With ABIv1 non-dot symbols *are*
> function descriptors?

Not always. '_text' is an example of a symbol that is not a function 
descriptor. However, most functions have a dot variant constituting the 
actual entry point and a non-dot variant constituting the function 
descriptor.

> 
> >   # perf probe do_fork
> >   Added new event:
> >   Failed to write event: Invalid argument
> >     Error: Failed to add events.
> >   # dmesg | tail -1
> >   [192268.073063] Could not insert probe at _text+768432: -22
> > 
> > _text is being resolved incorrectly and is resulting in the above error.
> > Fix this by changing how we lookup symbol addresses on ppc64. We first
> > check for the dot variant of a symbol and look at the non-dot variant
> > only if that fails. In this manner, we avoid having to look at the
> > function descriptor.
> 
> I'm not clear that ppc_local_function_entry() makes sense. On ABIv2 you return
> the local entry point, which is fine. But on ABIv1 you just return the
> unmodified address, which will be the descriptor if you actually passed it a
> function pointer. I think you're assuming that you're passed the text address,
> but if that's the case the function is badly named at least.
> 
> I also don't understand why we need to ever guess which ABI we're using. We
> know which ABI we're built with, so there should be no guess work required.
> 
> So at the very least this needs much more explanation.
> 
> But to be honest I'm not clear why it even needs a kernel change, don't we just
> need perf to understand dot symbols?

The problem in this case is in the kernel. perf probe is now basing all 
probe addresses on _text and writes, for example, "p:probe/do_fork 
_text+768432" to /sys/kernel/debug/tracing/kprobe_events.

This ends up in kprobe_lookup_name() for resolving address of _text, 
which invokes ppc_function_entry(), which ends up thinking _text is a 
function descriptor.

Even though we know we are compiled for ABIv1, there is no easy way to 
identify if a given symbol is the actual entry point or if it is a 
function descriptor. To address this, my approach is to always check for 
a dot symbol first and if that exists, we know we have the actual 
function entry. If not, we know this isn't a function descriptor (since 
there is no related dot symbol).

I agree that the function is named badly though. The real problem is 
that kprobe_lookup_name is a macro and I can't have a #ifdef to call 
ppc_function_entry() only for ABIv2.

Thoughts? Suggestions?

Thanks,
Naveen

