Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbbATFxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:53:38 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55873 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbbATFxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:53:34 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm/thp: Allocate transparent hugepages on local node
In-Reply-To: <54BD308A.4080905@suse.cz>
References: <1421393196-20915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20150116160204.544e2bcf9627f5a4043ebf8d@linux-foundation.org> <54BD308A.4080905@suse.cz>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 11:22:58 +0530
Message-ID: <87fvb6uhfp.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012005-0009-0000-0000-000000D2517F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlastimil Babka <vbabka@suse.cz> writes:

> On 01/17/2015 01:02 AM, Andrew Morton wrote:
>> On Fri, 16 Jan 2015 12:56:36 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> 
>>> This make sure that we try to allocate hugepages from local node if
>>> allowed by mempolicy. If we can't, we fallback to small page allocation
>>> based on mempolicy. This is based on the observation that allocating pages
>>> on local node is more beneficial than allocating hugepages on remote node.
>> 
>> The changelog is a bit incomplete.  It doesn't describe the current
>> behaviour, nor what is wrong with it.  What are the before-and-after
>> effects of this change?
>> 
>> And what might be the user-visible effects?
>> 
>>> --- a/mm/mempolicy.c
>>> +++ b/mm/mempolicy.c
>>> @@ -2030,6 +2030,46 @@ retry_cpuset:
>>>  	return page;
>>>  }
>>>  
>>> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>>> +				unsigned long addr, int order)
>> 
>> alloc_pages_vma() is nicely documented.  alloc_hugepage_vma() is not
>> documented at all.  This makes it a bit had for readers to work out the
>> difference!
>> 
>> Is it possible to scrunch them both into the same function?  Probably
>> too messy?
>
> Hm that could work, alloc_pages_vma already has an if (MPOL_INTERLEAVE) part, so
> just put the THP specialities into an "else if (huge_page)" part there?
>
> You could probably test for GFP_TRANSHUGE the same way as __alloc_pages_slowpath
> does. There might be false positives theoretically, but is there anything else
> that would use these flags and not be a THP?
>

is that check correct ? ie, 

if ((gfp & GFP_TRANSHUGE) == GFP_TRANSHUGE)

may not always indicate transparent hugepage if defrag = 0 . With defrag
cleared, we remove __GFP_WAIT from GFP_TRANSHUGE.

static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
{
	return (GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT)) | extra_gfp;
}

-aneesh

