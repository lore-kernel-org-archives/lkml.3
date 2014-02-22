Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaBVRo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:44:27 -0500
Received: from jcornwall.me ([198.58.100.172]:46028 "EHLO jcornwall.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaBVRo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:44:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 22 Feb 2014 11:44:24 -0600
From: Jay Cornwall <jay@jcornwall.me>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?Q?put=5Fpage=20on=20transparent=20huge=20page=20leaks?=
 =?UTF-8?Q?=3F?=
In-Reply-To: <20140222023144.GB18046@node.dhcp.inet.fi>
References: <ff08f2ccbcd50d2d353392a81defe619@jcornwall.me>
 <20140222023144.GB18046@node.dhcp.inet.fi>
Message-ID: <2f724688447dc8c8e599ff07fccb9fa4@jcornwall.me>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-21 20:31, Kirill A. Shutemov wrote:
> On Fri, Feb 21, 2014 at 11:23:39AM -0600, Jay Cornwall wrote:
>> I'm tracking a possible memory leak in iommu/amd. The driver uses this 
>> logic
>> to fault a page in response to a PRI from a device:
>> 
>> npages = get_user_pages(fault->state->task, fault->state->mm,
>>                         fault->address, 1, write, 0, &page, NULL);
>> 
>> if (npages == 1)
>>         put_page(page);
>> else
>>         ...
>> 
>> This works correctly when get_user_pages returns a 4KB page. When
>> transparent huge pages are enabled any 2MB page returned by this call
>> appears to leak on process exit. The non-cached memory usage stays 
>> elevated
>> by the set of faulted 2MB pages. This behavior is not observed when 
>> the
>> exception handler demand faults 2MB pages.
> 
> Could you show output of dump_page() on 2M pages for both points?

get_user_pages():
   page:ffffea000ffa00c0 count:0 mapcount:1 mapping:          (null) 
index:0x0
   page flags: 0x2fffe0000008000(tail)
   // page_count(page)=3 (head page)
put_page():
   page:ffffea000ffa00c0 count:0 mapcount:0 mapping:          (null) 
index:0x0
   page flags: 0x2fffe0000008000(tail)
   // page_count(page)=3 (head page)

Repeat on the same page.

get_user_pages():
   page:ffffea000ffa00c0 count:0 mapcount:1 mapping:          (null) 
index:0x0
   page flags: 0x2fffe0000008000(tail)
   // page_count(page)=4 (head page)
put_page():
   page:ffffea000ffa00c0 count:0 mapcount:0 mapping:          (null) 
index:0x0
   page flags: 0x2fffe0000008000(tail)
   // page_count(page)=4 (head page)

The head page appears to be leaking a reference. There is *no leak* if 
the driver faults the head page directly.

> My guess is that your page is PageTail(). Refcounting for tail pages is
> different: on get_page() we increase *->_mapcount* of tail and increase
> ->_count of relevant head page. ->_count of tail pages should always be
> zero, but it's 3 in your case which is odd.

That's correct, this is a tail page. page_count() references the head 
page:

   static inline int page_count(struct page *page)
   {
           return atomic_read(&compound_head(page)->_count);
   }

> BTW, I don't see where you take mmap_sem in 
> drivers/iommu/amd_iommu_v2.c,
> which is required for gup. Do I miss something?

You're right. I have a patch applied on my local branch to fix this.
