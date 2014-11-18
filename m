Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaKRRIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:08:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbaKRRIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:08:30 -0500
Date: Tue, 18 Nov 2014 17:08:25 +0000
From: Mel Gorman <mgorman@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
Message-ID: <20141118170825.GD2725@suse.de>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de>
 <877fyugrmc.fsf@linux.vnet.ibm.com>
 <20141118160112.GC2725@suse.de>
 <87y4r879k5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87y4r879k5.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:03:30PM +0530, Aneesh Kumar K.V wrote:
> > diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
> > index 5a236f0..46152aa 100644
> > --- a/arch/powerpc/mm/copro_fault.c
> > +++ b/arch/powerpc/mm/copro_fault.c
> > @@ -64,7 +64,12 @@ int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
> >  		if (!(vma->vm_flags & VM_WRITE))
> >  			goto out_unlock;
> >  	} else {
> > -		if (dsisr & DSISR_PROTFAULT)
> > +		/*
> > +		 * protfault should only happen due to us
> > +		 * mapping a region readonly temporarily. PROT_NONE
> > +		 * is also covered by the VMA check above.
> > +		 */
> > +		if (WARN_ON_ONCE(dsisr & DSISR_PROTFAULT))
> >  			goto out_unlock;
> >  		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
> >  			goto out_unlock;
> 
> 
> we should do that DSISR_PROTFAILT check after vma->vm_flags. It is not
> that we will not hit DSISR_PROTFAULT, what we want to ensure here is that
> we get a prot fault only for cases convered by that vma check. So
> everything should be taking the if (!(vma->vm_flags & (VM_READ |
> VM_EXEC))) branch if it is a protfault. If not we would like to know
> about that. And hence the idea of not using WARN_ON_ONCE. I was also not
> sure whether we want to enable that always. The reason for keeping that
> within CONFIG_DEBUG_VM is to make sure that nobody ends up depending on
> PROTFAULT outside the vma check convered. So expectations is that
> developers working on feature will run with DEBUG_VM enable and finds
> this warning. We don't expect to hit this otherwise.
> 

/me slaps self. It's clear now and updated accordingly. Thanks.

-- 
Mel Gorman
SUSE Labs
