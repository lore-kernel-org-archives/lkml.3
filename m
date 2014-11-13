Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbaKMT4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:56:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24419 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526AbaKMT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:56:30 -0500
Date: Thu, 13 Nov 2014 14:56:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
Message-ID: <20141113195605.GA13039@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-3-git-send-email-jgross@suse.com>
 <20141112214506.GA5922@laptop.dumpdata.com>
 <54644E48.3040506@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54644E48.3040506@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+	mfn_save = virt_to_mfn(buf);
> >>+
> >>+	while (xen_remap_mfn != INVALID_P2M_ENTRY) {
> >
> >So the 'list' is constructed by going forward - that is from low-numbered
> >PFNs to higher numbered ones. But the 'xen_remap_mfn' is going the
> >other way - from the highest PFN to the lowest PFN.
> >
> >Won't that mean we will restore the chunks of memory in the wrong
> >order? That is we will still restore them in chunks size, but the
> >chunks will be in descending order instead of ascending?
> 
> No, the information where to put each chunk is contained in the chunk
> data. I can add a comment explaining this.

Right, the MFNs in a "chunks" are going to be restored in the right order.

I was thinking that the "chunks" (so a set of MFNs) will be restored in
the opposite order that they are written to. 

And oddly enough the "chunks" are done in 512-3 = 509 MFNs at once?

> 
> >
> >>+		/* Map the remap information */
> >>+		set_pte_mfn(buf, xen_remap_mfn, PAGE_KERNEL);
> >>+
> >>+		BUG_ON(xen_remap_mfn != xen_remap_buf.mfns[0]);
> >>+
> >>+		free = 0;
> >>+		pfn = xen_remap_buf.target_pfn;
> >>+		for (i = 0; i < xen_remap_buf.size; i++) {
> >>+			mfn = xen_remap_buf.mfns[i];
> >>+			if (!released && xen_update_mem_tables(pfn, mfn)) {
> >>+				remapped++;
> >
> >If we fail 'xen_update_mem_tables' we will on the next chunk (so i+1) keep on
> >freeing pages instead of trying to remap. Is that intentional? Could we
> >try to remap?
> 
> Hmm, I'm not sure this is worth the effort. What could lead to failure
> here? I suspect we could even just BUG() on failure. What do you think?

I was hoping that this question would lead to making this loop a bit
simpler as you would have to spread some of the code in the loop
into functions.

And keep 'remmaped' and 'released' reset every loop.

However, if it makes the code more complex - then please
forget my question.
