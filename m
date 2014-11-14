Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161342AbaKNQsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:48:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161316AbaKNQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:48:08 -0500
Date: Fri, 14 Nov 2014 11:47:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
Message-ID: <20141114164741.GA8198@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-3-git-send-email-jgross@suse.com>
 <20141112214506.GA5922@laptop.dumpdata.com>
 <54644E48.3040506@suse.com>
 <20141113195605.GA13039@laptop.dumpdata.com>
 <54658ABF.5050708@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54658ABF.5050708@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 05:53:19AM +0100, Juergen Gross wrote:
> On 11/13/2014 08:56 PM, Konrad Rzeszutek Wilk wrote:
> >>>>+	mfn_save = virt_to_mfn(buf);
> >>>>+
> >>>>+	while (xen_remap_mfn != INVALID_P2M_ENTRY) {
> >>>
> >>>So the 'list' is constructed by going forward - that is from low-numbered
> >>>PFNs to higher numbered ones. But the 'xen_remap_mfn' is going the
> >>>other way - from the highest PFN to the lowest PFN.
> >>>
> >>>Won't that mean we will restore the chunks of memory in the wrong
> >>>order? That is we will still restore them in chunks size, but the
> >>>chunks will be in descending order instead of ascending?
> >>
> >>No, the information where to put each chunk is contained in the chunk
> >>data. I can add a comment explaining this.
> >
> >Right, the MFNs in a "chunks" are going to be restored in the right order.
> >
> >I was thinking that the "chunks" (so a set of MFNs) will be restored in
> >the opposite order that they are written to.
> >
> >And oddly enough the "chunks" are done in 512-3 = 509 MFNs at once?
> 
> More don't fit on a single page due to the other info needed. So: yes.

But you could use two pages - one for the structure and the other
for the list of MFNs. That would fix the problem of having only
509 MFNs being contingous per chunk when restoring.

Anyhow the point I had that I am worried is that we do not restore the
MFNs in the same order. We do it in "chunk" size which is OK (so the 509 MFNs
at once)- but the order we traverse the restoration process is the opposite of
the save process. Say we have 4MB of contingous MFNs, so two (err, three)
chunks. The first one we iterate is from 0->509, the second is 510->1018, the
last is 1019->1023. When we restore (remap) we start with the last 'chunk'
so we end up restoring them: 1019->1023, 510->1018, 0->509 order.

If we go with using two pages - one for the structure and one for the
list of PFNs, we could expand the structure to have an 'next' and 'prev'
MFN. When you then traverse in 'xen_remap_memory' you could do:

mfn = xen_remap_mfn;
while (mfn != INVALID_P2M_ENTRY) {
	xen_remap_mfn = mfn;
	set_pte_mfn(buf, mfn, PAGE_KERNEL);
	mfn = xen_remap_buf.next_area_mfn;
}

And then you can start from this updated xen_remap_mfn which will
start with the first chunk that has been set. Thought at this point
it does not matter whether we have a seperate page for the MFNs as
the restoration/remap process will put them in the save order
that they were saved.

> 
> >
> >>
> >>>
> >>>>+		/* Map the remap information */
> >>>>+		set_pte_mfn(buf, xen_remap_mfn, PAGE_KERNEL);
> >>>>+
> >>>>+		BUG_ON(xen_remap_mfn != xen_remap_buf.mfns[0]);
> >>>>+
> >>>>+		free = 0;
> >>>>+		pfn = xen_remap_buf.target_pfn;
> >>>>+		for (i = 0; i < xen_remap_buf.size; i++) {
> >>>>+			mfn = xen_remap_buf.mfns[i];
> >>>>+			if (!released && xen_update_mem_tables(pfn, mfn)) {
> >>>>+				remapped++;
> >>>
> >>>If we fail 'xen_update_mem_tables' we will on the next chunk (so i+1) keep on
> >>>freeing pages instead of trying to remap. Is that intentional? Could we
> >>>try to remap?
> >>
> >>Hmm, I'm not sure this is worth the effort. What could lead to failure
> >>here? I suspect we could even just BUG() on failure. What do you think?
> >
> >I was hoping that this question would lead to making this loop a bit
> >simpler as you would have to spread some of the code in the loop
> >into functions.
> >
> >And keep 'remmaped' and 'released' reset every loop.
> >
> >However, if it makes the code more complex - then please
> >forget my question.
> 
> Using BUG() instead would make the code less complex. Do you really
> think xen_update_mem_tables() would ever fail in a sane system?
> 
> - set_phys_to_machine() would fail only on a memory shortage. Just
>   going on without adding more memory wouldn't lead to a healthy system,
>   I think.
> - The hypervisor calls would fail only in case of parameter errors.
>   This should never happen, so dying seems to be the correct reaction.
> 
> David, what do you think?
> 
> 
> Juergen
