Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaFBTKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaFBTKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:10:06 -0400
Date: Mon, 2 Jun 2014 16:09:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        peterz@infradead.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140602190907.GA7590@amt.cnet>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <20140530082136.GA4715@minantech.com>
 <20140530162424.GC8876@tassilo.jf.intel.com>
 <20140602164534.GD4715@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602164534.GD4715@minantech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 07:45:35PM +0300, Gleb Natapov wrote:
> On Fri, May 30, 2014 at 09:24:24AM -0700, Andi Kleen wrote:
> > > > To avoid any problems with guest pages being swapped by the host we
> > > > pin the pages when the PEBS buffer is setup, by intercepting
> > > > that MSR.
> > > It will avoid guest page to be swapped, but shadow paging code may still drop
> > > shadow PT pages that build a mapping from DS virtual address to the guest page.
> > 
> > You're saying the EPT code could tear down the EPT mappings?
> 
> Under memory pressure yes. mmu_shrink_scan() calls
> prepare_zap_oldest_mmu_page() which destroys oldest mmu pages like its
> name says. As far as I can tell running nested guest can also result in
> EPT mapping to be dropped since it will create a lot of shadow pages and
> this will cause make_mmu_pages_available() to destroy some shadow pages
> and it may choose EPT pages to destroy.
> 
> CCing Marcelo to confirm/correct.

Yes. Given SLAB pressure any shadow pages can be deleted except pinned 
via root_count=1 ones.

> > OK that would need to be prevented too. Any suggestions how?
> Only high level. Mark shadow pages involved in translation we want to keep and skip them in
> prepare_zap_oldest_mmu_page().

Should special case such translations so that they are not zapped
(either via page deletion or single entry EPT deletion). Them
and any other their parents, bummer.

Maybe its cleaner to check that DS area is EPT mapped before VM-entry.

No way the processor can generate VM-exits ?

Is it not an option to fake a DS-save area in the host (and trap
any accesses to the DS_AREA MSR from the guest) ? 
Then before notifying the PEBS event, copy from that host area to 
guests address. Slow probably.

