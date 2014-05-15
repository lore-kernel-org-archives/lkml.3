Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaEOSnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:43:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44521 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbaEOSnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:43:06 -0400
Message-ID: <53750A96.2020201@zytor.com>
Date: Thu, 15 May 2014 11:42:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Mel Gorman <mgorman@suse.de>, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 7/9] x86: skip check for spurious faults for non-present
 faults
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com> <1397571337-20409-8-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1397571337-20409-8-git-send-email-david.vrabel@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 07:15 AM, David Vrabel wrote:
> If a fault on a kernel address is due to a non-present page, then it
> cannot be the result of stale TLB entry from a protection change (RO
> to RW or NX to X).  Thus the pagetable walk in spurious_fault() can be
> skipped.

Erk... this code is screaming WTF to me.  The x86 architecture is such
that the CPU is responsible for avoiding these faults.

<dig> <dig> <dig>

5b727a3b0158a129827c21ce3bfb0ba997e8ddd0

    x86: ignore spurious faults

    When changing a kernel page from RO->RW, it's OK to leave stale TLB
    entries around, since doing a global flush is expensive and they
    pose no security problem.  They can, however, generate a spurious
    fault, which we should catch and simply return from (which will
    have the side-effect of reloading the TLB to the current PTE).

    This can occur when running under Xen, because it frequently changes
    kernel pages from RW->RO->RW to implement Xen's pagetable semantics.
    It could also occur when using CONFIG_DEBUG_PAGEALLOC, since it
    avoids doing a global TLB flush after changing page permissions.

    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
    Cc: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Again WTF?

Are we chasing hardware errata here?  Or did someone go off and *assume*
that the x86 hardware architecture work a certain way?  Or is there
something way more subtle going on?

I guess next step is mailing list archaeology...

Does anyone still have contacts with Jeremy, and if so, could they poke
him perhaps?

	-hpa

