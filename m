Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbaKSTo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:44:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21097 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbaKSToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:44:25 -0500
Date: Wed, 19 Nov 2014 14:43:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
Message-ID: <20141119194350.GA18117@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-3-git-send-email-jgross@suse.com>
 <20141112214506.GA5922@laptop.dumpdata.com>
 <54644E48.3040506@suse.com>
 <20141113195605.GA13039@laptop.dumpdata.com>
 <54658ABF.5050708@suse.com>
 <20141114164741.GA8198@laptop.dumpdata.com>
 <5466385E.6040009@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5466385E.6040009@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 06:14:06PM +0100, Juergen Gross wrote:
> On 11/14/2014 05:47 PM, Konrad Rzeszutek Wilk wrote:
> >On Fri, Nov 14, 2014 at 05:53:19AM +0100, Juergen Gross wrote:
> >>On 11/13/2014 08:56 PM, Konrad Rzeszutek Wilk wrote:
> >>>>>>+	mfn_save = virt_to_mfn(buf);
> >>>>>>+
> >>>>>>+	while (xen_remap_mfn != INVALID_P2M_ENTRY) {
> >>>>>
> >>>>>So the 'list' is constructed by going forward - that is from low-numbered
> >>>>>PFNs to higher numbered ones. But the 'xen_remap_mfn' is going the
> >>>>>other way - from the highest PFN to the lowest PFN.
> >>>>>
> >>>>>Won't that mean we will restore the chunks of memory in the wrong
> >>>>>order? That is we will still restore them in chunks size, but the
> >>>>>chunks will be in descending order instead of ascending?
> >>>>
> >>>>No, the information where to put each chunk is contained in the chunk
> >>>>data. I can add a comment explaining this.
> >>>
> >>>Right, the MFNs in a "chunks" are going to be restored in the right order.
> >>>
> >>>I was thinking that the "chunks" (so a set of MFNs) will be restored in
> >>>the opposite order that they are written to.
> >>>
> >>>And oddly enough the "chunks" are done in 512-3 = 509 MFNs at once?
> >>
> >>More don't fit on a single page due to the other info needed. So: yes.
> >
> >But you could use two pages - one for the structure and the other
> >for the list of MFNs. That would fix the problem of having only
> >509 MFNs being contingous per chunk when restoring.
> 
> That's no problem (see below).
> 
> >Anyhow the point I had that I am worried is that we do not restore the
> >MFNs in the same order. We do it in "chunk" size which is OK (so the 509 MFNs
> >at once)- but the order we traverse the restoration process is the opposite of
> >the save process. Say we have 4MB of contingous MFNs, so two (err, three)
> >chunks. The first one we iterate is from 0->509, the second is 510->1018, the
> >last is 1019->1023. When we restore (remap) we start with the last 'chunk'
> >so we end up restoring them: 1019->1023, 510->1018, 0->509 order.
> 
> No. When building up the chunks we save in each chunk where to put it
> on remap. So in your example 0-509 should be mapped at <dest>+0,
> 510-1018 at <dest>+510, and 1019-1023 at <dest>+1019.
> 
> When remapping we map 1019-1023 to <dest>+1019, 510-1018 at <dest>+510
> and last 0-509 at <dest>+0. So we do the mapping in reverse order, but
> to the correct pfns.

Excellent! Could a condensed version of that explanation be put in the code ?

> 
> Juergen
