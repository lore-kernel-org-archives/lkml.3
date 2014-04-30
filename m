Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbaD3Mlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:41:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40956 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbaD3Mln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:41:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,958,1389744000"; 
   d="scan'208";a="126282370"
Message-ID: <5360EF70.20202@citrix.com>
Date: Wed, 30 Apr 2014 13:41:20 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 7/9] x86: skip check for spurious faults for non-present
 faults
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com> <1397571337-20409-8-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1397571337-20409-8-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/14 15:15, David Vrabel wrote:
> If a fault on a kernel address is due to a non-present page, then it
> cannot be the result of stale TLB entry from a protection change (RO
> to RW or NX to X).  Thus the pagetable walk in spurious_fault() can be
> skipped.
> 
> This avoids spurious_fault() oopsing in some cases if the pagetables
> it attempts to walk are not accessible.  This obscures the location of
> the original fault.
> 
> This also fixes a crash with Xen PV guests when they access entries in
> the M2P corresponding to device MMIO regions.  The M2P is mapped
> (read-only) by Xen into the kernel address space of the guest and this
> mapping may contains holes for non-RAM regions.  Read faults will
> result in calls to spurious_fault(), but because the page tables for
> the M2P mappings are not accessible by the guest the pagetable walk
> would fault.
> 
> This was not normally a problem as MMIO mappings would not normally
> result in a M2P lookup because of the use of the _PAGE_IOMAP bit the
> PTE.  However, removing the _PAGE_IOMAP bit requires M2P lookups for
> MMIO mappings as well.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> x86 maintainers, this is a prerequisite for removing Xen's usage of
> _PAGE_IOMAP so I think this is best merged via the Xen tree.

Peter, any opinion on this patch?

David
