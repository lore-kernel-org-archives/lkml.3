Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaCYQwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:52:04 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:33488 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbaCYQwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:52:02 -0400
Date: Tue, 25 Mar 2014 11:51:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Sasha Levin <sasha.levin@oracle.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
In-Reply-To: <5331A6C3.2000303@oracle.com>
Message-ID: <alpine.DEB.2.10.1403251150330.16870@nuc>
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Sasha Levin wrote:

> I have a lead on this. Consider the following:
>
>   kmem_cache_alloc
> 	__slab_alloc
> 		local_irq_save()
> 		deactivate_slab
> 			__cmpxchg_double_slab
> 				slab_unlock
> 					__bit_spin_unlock
> 						preempt_enable
> 		[ Page Fault ]
>
> With this trace, it manifests as a "BUG: sleeping function called from invalid
> context at arch/x86/mm/fault.c" on a might_sleep() in the page fault handler
> (which is an issue on it's own), but I suspect it's also the cause of the
> trace
> above - preemption enabled and a race that removed the page.
>
> Could someone confirm please?

The preempt count is incremented earlier in bit_spin_lock so the
preempt_enable() should not do anything.

