Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3A2Gu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:50:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3A2Guy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:50:54 -0500
Date: Tue, 29 Jan 2013 08:50:49 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-ID: <20130129065049.GF22871@redhat.com>
References: <20130124220027.11061.76400.stgit@bling.home>
 <20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <5101FBE8.9000206@linux.vnet.ibm.com>
 <20130128105903.GA22871@redhat.com>
 <51073CC3.8030105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51073CC3.8030105@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 11:06:43AM +0800, Xiao Guangrong wrote:
> On 01/28/2013 06:59 PM, Gleb Natapov wrote:
> > On Fri, Jan 25, 2013 at 11:28:40AM +0800, Xiao Guangrong wrote:
> >> On 01/25/2013 09:17 AM, Takuya Yoshikawa wrote:
> >>> On Thu, 24 Jan 2013 15:03:57 -0700
> >>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>
> >>>> A couple patches to make KVM IOMMU support honor read-only mappings.
> >>>> This causes an un-map, re-map when the read-only flag changes and
> >>>> makes use of it when setting IOMMU attributes.  Thanks,
> >>>
> >>> Looks good to me.
> >>>
> >>> I think I can naturally update my patch after this gets merged.
> >>>
> >>
> >> Please wait.
> >>
> >> The commit c972f3b1 changed the write-protect behaviour - it does
> >> wirte-protection only when dirty flag is set.
> >> [ I did not see this commit when we discussed the problem before. ]
> >>
> >> Further more, i notice that write-protect is not enough, when do sync
> >> shadow page:
> >>
> >> FNAME(sync_page):
> >>
> >> 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
> >>
> >> 		set_spte(vcpu, &sp->spt[i], pte_access,
> >> 			 PT_PAGE_TABLE_LEVEL, gfn,
> >> 			 spte_to_pfn(sp->spt[i]), true, false,
> >> 			 host_writable);
> >>
> >> It sets spte based on the old value that means the readonly flag check
> >> is missed. We need to call kvm_arch_flush_shadow_all under this case.
> > Why not just disallow changing memory region KVM_MEM_READONLY flag
> > without deleting the region?
> 
> It will introduce some restriction when VM-sharing-mem is being implemented,
> but we need to do some optimization for it, at least, properly write-protect
> readonly pages (fix sync_page()) instead of zap_all_page.
> 
What is VM-sharing-mem?

> So, i guess we can do the simple fix first.
> 
By simple fix you mean calling kvm_arch_flush_shadow_all() on READONLY
flag change?

--
			Gleb.
