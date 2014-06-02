Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaFBQpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:45:43 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40788 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaFBQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:45:41 -0400
Date: Mon, 2 Jun 2014 19:45:35 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        pbonzini@redhat.com, eranian@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140602164534.GD4715@minantech.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <20140530082136.GA4715@minantech.com>
 <20140530162424.GC8876@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530162424.GC8876@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:24:24AM -0700, Andi Kleen wrote:
> > > To avoid any problems with guest pages being swapped by the host we
> > > pin the pages when the PEBS buffer is setup, by intercepting
> > > that MSR.
> > It will avoid guest page to be swapped, but shadow paging code may still drop
> > shadow PT pages that build a mapping from DS virtual address to the guest page.
> 
> You're saying the EPT code could tear down the EPT mappings?

Under memory pressure yes. mmu_shrink_scan() calls
prepare_zap_oldest_mmu_page() which destroys oldest mmu pages like its
name says. As far as I can tell running nested guest can also result in
EPT mapping to be dropped since it will create a lot of shadow pages and
this will cause make_mmu_pages_available() to destroy some shadow pages
and it may choose EPT pages to destroy.

CCing Marcelo to confirm/correct.

> 
> OK that would need to be prevented too. Any suggestions how?
Only high level. Mark shadow pages involved in translation we want to keep and skip them in
prepare_zap_oldest_mmu_page().

> 
> > With EPT it is less likely to happen (but still possible IIRC depending on memory
> > pressure and how much memory shadow paging code is allowed to use), without EPT
> > it will happen for sure.
> 
> Don't care about the non EPT case, this is white listed only for EPT supporting 
> CPUs.
User may still disable EPT during module load, so pebs should be dropped
from a guest's cpuid in this case.

> 
> > There is nothing, as far as I can see, that says what will happen if the
> > condition is not met. I always interpreted it as undefined behaviour so
> > anything can happen including CPU dies completely.  You are saying above
> > on one hand that CPU cannot handle any kinds of faults during write to
> > DS area, but on the other hand a guest could only crash itself. Is this
> > architecturally guarantied?
> 
> You essentially would get random page faults, and the PEBS event will
> be cancelled. No hangs.
Is this a guest who will get those random page faults or a host?

> 
> It's not architecturally guaranteed, but we white list anyways so 
> we only care about the white listed CPUs at this point. For them
> I have confirmation that it works.
> 
> -Andi

--
			Gleb.
