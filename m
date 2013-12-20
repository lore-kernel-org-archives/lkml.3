Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3LTH1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:27:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3LTH1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:27:16 -0500
Date: Fri, 20 Dec 2013 15:25:57 +0800
From: Baoquan He <bhe@redhat.com>
To: Bill Sumner <bill.sumner@hp.com>
Cc: indou.takao@jp.fujitsu.com, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        ddutile@redhat.com, doug.hatch@hp.com, ishii.hironobu@jp.fujitsu.com,
        bhelgaas@google.com, dwmw2@infradead.org
Subject: Re: [PATCHv2 4/6] Crashdump-Accepting-Active-IOMMU-Copy-Translations
Message-ID: <20131220072557.GA4382@dhcp-16-105.nay.redhat.com>
References: <1387507787-14163-1-git-send-email-bill.sumner@hp.com>
 <1387507787-14163-5-git-send-email-bill.sumner@hp.com>
 <20131220060429.GB32194@dhcp-16-116.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220060429.GB32194@dhcp-16-116.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 at 02:04pm, Baoquan He wrote:
> On 12/19/13 at 07:49pm, Bill Sumner wrote:
> 
> > +static int copy_page_addr(u64 page_addr, u32 shift, u32 bus, u32 devfn,
> > +				u64 pte, struct dmar_domain *domain,
> > +				void *parms)
> > +{
> > +	struct copy_page_addr_parms *ppap = parms;
> > +
> > +	u64 page_size = ((u64)1 << shift);	/* page_size */
> > +	u64 pfn_lo;				/* For reserving IOVA range */
> > +	u64 pfn_hi;				/* For reserving IOVA range */
> > +	struct iova *iova_p;			/* For reserving IOVA range */
> > +
> > +	if (!ppap) {
> > +		pr_err("ERROR: ppap is NULL: 0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
> > +			bus, bus, devfn, devfn,  page_addr,
> > +			page_size, page_size);
> > +		return 0;
> > +	}
> > +
> 
> > +	/* Prepare for a new page */
> > +	ppap->first     = 0;		/* Not first-time anymore */
> > +	ppap->bus       = bus;
> > +	ppap->devfn     = devfn;
> > +	ppap->shift     = shift;
> > +	ppap->pte       = pte;
> > +	ppap->next_addr = page_addr + page_size; /* Next-expected page_addr */
> > +
> > +	ppap->page_addr = page_addr;	/* Addr(new page) */
> > +	ppap->page_size = page_size;	/* Size(new page) */
> > +
> > +	ppap->domain    = domain;	/* adr(domain for the new range) */
> 
> Here I am confused, ppap is used to collect the copied ranges and
> necessary information. To my understanding, this domain is the
> dmar_domain which the 1st device is on. When ppat->last is set to 1,
> among the whole collected range, there may be many domains. I just feel
> not good for this. Is it OK to define a specific lock for ppap
> structure, possibly? Please correct me if I am wrong.

Well, check it again. It's not about the lock. Just all address is
recorded in one dmar_domain.
