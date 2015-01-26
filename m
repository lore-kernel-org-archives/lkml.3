Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbbAZMkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:40:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbbAZMkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:40:33 -0500
Message-ID: <54C635BF.6010906@suse.cz>
Date: Mon, 26 Jan 2015 13:40:31 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mm/thp: Allocate transparent hugepages on local node
References: <1421753671-16793-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20150120164832.abe2e47b760e1a8d7bb6055b@linux-foundation.org> <54C62803.8010105@suse.cz> <20150126121309.GD25833@node.dhcp.inet.fi>
In-Reply-To: <20150126121309.GD25833@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 01:13 PM, Kirill A. Shutemov wrote:
> On Mon, Jan 26, 2015 at 12:41:55PM +0100, Vlastimil Babka wrote:
>> On 01/21/2015 01:48 AM, Andrew Morton wrote:
>> > On Tue, 20 Jan 2015 17:04:31 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> >> + * Should be called with the mm_sem of the vma hold.
>> > 
>> > That's a pretty cruddy sentence, isn't it?  Copied from
>> > alloc_pages_vma().  "vma->vm_mm->mmap_sem" would be better.
>> > 
>> > And it should tell us whether mmap_sem required a down_read or a
>> > down_write.  What purpose is it serving?
>> 
>> This is already said for mmap_sem further above this comment line, which
>> should be just deleted (and from alloc_hugepage_vma comment too).
>> 
>> >> + *
>> >> + */
>> >> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>> >> +				unsigned long addr, int order)
>> > 
>> > This pointlessly bloats the kernel if CONFIG_TRANSPARENT_HUGEPAGE=n?
>> > 
>> > 
>> > 
>> > --- a/mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node-fix
>> > +++ a/mm/mempolicy.c
>> 
>> How about this cleanup on top? I'm not fully decided on the GFP_TRANSHUGE test.
>> This is potentially false positive, although I doubt anything else uses the same
>> gfp mask bits.
> 
> This info on gfp mask should be in commit message.

Right. Wanted to get some consensus first.

> And what about WARN_ON_ONCE() if we the matching bits with
> !TRANSPARENT_HUGEPAGE?

Hmm, can't say I like that, but could work.

>> 
>> Should "hugepage" be extra bool parameter instead? Should I #ifdef the parameter
>> only for CONFIG_TRANSPARENT_HUGEPAGE, or is it not worth the ugliness?
> 
> Do we have spare gfp bit? ;)

Seems we have defined 24 out of 32. Not too much to spare, and the use case here
is very narrow.
