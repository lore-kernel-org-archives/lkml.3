Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbaKMT4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:56:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526AbaKMT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:56:43 -0500
Date: Thu, 13 Nov 2014 14:56:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 4/8] xen: Delay invalidating extra memory
Message-ID: <20141113195621.GB13039@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-5-git-send-email-jgross@suse.com>
 <20141112221021.GC7549@laptop.dumpdata.com>
 <54645474.4040605@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54645474.4040605@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 07:49:24AM +0100, Juergen Gross wrote:
> On 11/12/2014 11:10 PM, Konrad Rzeszutek Wilk wrote:
> >>@@ -376,12 +374,14 @@ void __init xen_build_dynamic_phys_to_machine(void)
> >>  	unsigned long max_pfn;
> >>  	unsigned long pfn;
> >>
> >>-	 if (xen_feature(XENFEAT_auto_translated_physmap))
> >>+	if (xen_feature(XENFEAT_auto_translated_physmap))
> >
> >Spurious change.
> 
> I'll remove it.
> 
> >
> >.. snip..
> >>diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> >>index 0e5f9b6..8d5985b 100644
> >>--- a/arch/x86/xen/setup.c
> >>+++ b/arch/x86/xen/setup.c
> >>@@ -75,7 +75,6 @@ static unsigned long xen_remap_mfn __initdata = INVALID_P2M_ENTRY;
> >>
> >>  static void __init xen_add_extra_mem(u64 start, u64 size)
> >>  {
> >>-	unsigned long pfn;
> >>  	int i;
> >>
> >>  	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
> >>@@ -95,17 +94,74 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
> >>  		printk(KERN_WARNING "Warning: not enough extra memory regions\n");
> >>
> >>  	memblock_reserve(start, size);
> >>+}
> >>
> >>-	xen_max_p2m_pfn = PFN_DOWN(start + size);
> >>-	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
> >>-		unsigned long mfn = pfn_to_mfn(pfn);
> >>+static void __init xen_del_extra_mem(u64 start, u64 size)
> >>+{
> >>+	int i;
> >>+	u64 start_r, size_r;
> >>
> >>-		if (WARN_ONCE(mfn == pfn, "Trying to over-write 1-1 mapping (pfn: %lx)\n", pfn))
> >>-			continue;
> >>-		WARN_ONCE(mfn != INVALID_P2M_ENTRY, "Trying to remove %lx which has %lx mfn!\n",
> >>-			  pfn, mfn);
> >>+	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
> >>+		start_r = xen_extra_mem[i].start;
> >>+		size_r = xen_extra_mem[i].size;
> >>+
> >>+		/* Start of region. */
> >>+		if (start_r == start) {
> >>+			BUG_ON(size > size_r);
> >>+			xen_extra_mem[i].start += size;
> >>+			xen_extra_mem[i].size -= size;
> >>+			break;
> >>+		}
> >>+		/* End of region. */
> >>+		if (start_r + size_r == start + size) {
> >>+			BUG_ON(size > size_r);
> >>+			xen_extra_mem[i].size -= size;
> >>+			break;
> >>+		}
> >>+		/* Mid of region. */
> >>+		if (start > start_r && start < start_r + size_r) {
> >>+			BUG_ON(start + size > start_r + size_r);
> >>+			xen_extra_mem[i].size = start - start_r;
> >>+			xen_add_extra_mem(start + size, start_r + size_r -
> >>+					  (start + size));
> >
> >Which ends up calling 'memblock_reserve' for an region it already has
> >reserved. Should we call memblock_free(start_r, size_r - size) before calling this?
> >
> >Or is that not neccessary as memblock_* is pretty smart about this sort of thing?
> 
> Regions marked via memblock_reserve() are allowed to overlap. I can add
> a comment.

Thank you!
> 
> 
> Juergen
> 
