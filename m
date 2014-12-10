Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaLJJh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:37:27 -0500
Received: from ozlabs.org ([103.22.144.67]:58010 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbaLJJhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:37:24 -0500
Message-ID: <1418204242.9279.4.camel@ellerman.id.au>
Subject: Re: [RFC PATCH 1/8] kprobes: Fix kallsyms lookup across powerpc
 ABIv1 and ABIv2
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Date: Wed, 10 Dec 2014 20:37:22 +1100
In-Reply-To: <7a96a9c262a818112955da93f8ff1ada1bfe5c59.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
	 <7a96a9c262a818112955da93f8ff1ada1bfe5c59.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 23:03 +0530, Naveen N. Rao wrote:
> Currently, all non-dot symbols are being treated as function descriptors
> in ABIv1. This is incorrect and is resulting in perf probe not working:

I don't understand that first sentence. With ABIv1 non-dot symbols *are*
function descriptors?

>   # perf probe do_fork
>   Added new event:
>   Failed to write event: Invalid argument
>     Error: Failed to add events.
>   # dmesg | tail -1
>   [192268.073063] Could not insert probe at _text+768432: -22
> 
> _text is being resolved incorrectly and is resulting in the above error.
> Fix this by changing how we lookup symbol addresses on ppc64. We first
> check for the dot variant of a symbol and look at the non-dot variant
> only if that fails. In this manner, we avoid having to look at the
> function descriptor.

I'm not clear that ppc_local_function_entry() makes sense. On ABIv2 you return
the local entry point, which is fine. But on ABIv1 you just return the
unmodified address, which will be the descriptor if you actually passed it a
function pointer. I think you're assuming that you're passed the text address,
but if that's the case the function is badly named at least.

I also don't understand why we need to ever guess which ABI we're using. We
know which ABI we're built with, so there should be no guess work required.

So at the very least this needs much more explanation.

But to be honest I'm not clear why it even needs a kernel change, don't we just
need perf to understand dot symbols?

cheers


