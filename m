Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3LKW7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:59:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab3LKW7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:59:12 -0500
Message-ID: <52A8EE38.2060004@suse.cz>
Date: Wed, 11 Dec 2013 23:59:04 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: joern@logfs.org, mgorman@suse.de, Michel Lespinasse <walken@google.com>,
        riel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kernel BUG in munlock_vma_pages_range
References: <52A3D0C3.1080504@oracle.com> <52A58E8A.3050401@suse.cz> <52A5F83F.4000207@oracle.com> <52A5F9EE.4010605@suse.cz> <52A6275F.4040007@oracle.com>
In-Reply-To: <52A6275F.4040007@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 09:26 PM, Sasha Levin wrote:
> On 12/09/2013 12:12 PM, Vlastimil Babka wrote:
>> On 12/09/2013 06:05 PM, Sasha Levin wrote:
>>> On 12/09/2013 04:34 AM, Vlastimil Babka wrote:
>>>> Hello, I will look at it, thanks.
>>>> Do you have specific reproduction instructions?
>>>
>>> Not really, the fuzzer hit it once and I've been unable to trigger it again. Looking at
>>> the piece of code involved it might have had something to do with hugetlbfs, so I'll crank
>>> up testing on that part.
>>
>> Thanks. Do you have trinity log and the .config file? I'm currently unable to even boot linux-next
>> with my config/setup due to a GPF.
>> Looking at code I wouldn't expect that it could encounter a tail page, without first encountering a
>> head page and skipping the whole huge page. At least in THP case, as TLB pages should be split when
>> a vma is split. As for hugetlbfs, it should be skipped for mlock/munlock operations completely. One
>> of these assumptions is probably failing here...
> 
> If it helps, I've added a dump_page() in case we hit a tail page there and got:
> 
> [  980.172299] page:ffffea003e5e8040 count:0 mapcount:1 mapping:          (null) index:0
> x0
> [  980.173412] page flags: 0x2fffff80008000(tail)
> 
> I can also add anything else in there to get other debug output if you think of something else useful.

Please try the following. Thanks in advance.

------8<------
diff --git a/mm/mlock.c b/mm/mlock.c
index d480cd6..c81b7c3 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -436,11 +436,14 @@ static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
+	unsigned long orig_start = start;
+	unsigned int page_increm = 0;
+
 	vma->vm_flags &= ~VM_LOCKED;

 	while (start < end) {
 		struct page *page = NULL;
-		unsigned int page_mask, page_increm;
+		unsigned int page_mask;
 		struct pagevec pvec;
 		struct zone *zone;
 		int zoneid;
@@ -457,6 +460,22 @@ void munlock_vma_pages_range(struct vm_area_struct *vma,
 				&page_mask);

 		if (page && !IS_ERR(page)) {
+			if (PageTail(page)) {
+				struct page *first_page;
+				dump_page(page);
+				printk("start=%lu pfn=%lu orig_start=%lu "
+				       "page_increm=%d "
+				       "vm_start=%lu vm_end=%lu vm_flags=%lu\n",
+					start, page_to_pfn(page), orig_start,
+					page_increm,
+					vma->vm_start, vma->vm_end,
+					vma->vm_flags);
+				first_page = page->first_page;
+				printk("first_page pfn=%lu\n",
+						page_to_pfn(first_page));
+				dump_page(first_page);
+				VM_BUG_ON(true);
+			}
 			if (PageTransHuge(page)) {
 				lock_page(page);
 				/*


