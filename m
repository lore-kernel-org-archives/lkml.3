Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab3HGXly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:41:54 -0400
Received: from server506k.appriver.com ([50.56.144.157]:58912 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752651Ab3HGXlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:41:53 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 6:41:50 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-8/SG:2 8/7/2013 6:40:57 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.980149 Source White
X-Signature-Violations: 0-0-0-6045-c
X-Note-419: 15.6012 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 6:41:45 PM
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <20130807142755.5cd89e02e4286f7dca88b80d@linux-foundation.org>
Date: Wed, 7 Aug 2013 19:41:48 -0400
CC: <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <3F0FBDD9-129C-45F4-A20C-3EB2E8EFC9C8@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807135804.e62b75f6986e9568ab787562@linux-foundation.org> <8DFEA276-4EE1-44B4-9669-5634631D7BBC@coraid.com> <20130807141835.533816143f8b37175c50d58d@linux-foundation.org> <20130807142755.5cd89e02e4286f7dca88b80d@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 7, 2013, at 5:27 PM, Andrew Morton wrote:

> On Wed, 7 Aug 2013 14:18:35 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Wed, 7 Aug 2013 17:12:36 -0400 Ed Cashin <ecashin@coraid.com> wrote:
>> 
>>> 
>>> On Aug 7, 2013, at 4:58 PM, Andrew Morton wrote:
>>> 
>>>> On Thu, 1 Aug 2013 21:29:59 -0400 Ed Cashin <ecashin@coraid.com> wrote:
>>>> 
>>>>> As discussed previously,
>>>> 
>>>> I think I missed that.
>>>> 
>>>>> the fact that some users of the block
>>>>> layer provide bios that point to pages with a zero _count means
>>>>> that it is not OK for the network layer to do a put_page on the
>>>>> skb frags during an skb_linearize, so the aoe driver gets a
>>>>> reference to pages in bios and puts the reference before ending
>>>>> the bio.  And because it cannot use get_page on a page with a
>>>>> zero _count, it manipulates the value directly.
>>>> 
>>>> Eh?  What code is putting count==0 pages into bios?  That sounds very
>>>> weird and broken.
>>> 
>>> I thought so in 2007 but couldn't solicit a clear "this is wrong" consensus from the discussion.
>>> 
>>>  http://article.gmane.org/gmane.linux.kernel/499197
>>>  https://lkml.org/lkml/2007/1/19/56
>>>  https://lkml.org/lkml/2006/12/18/230
>>> 
>>> We were seeing zero-count pages in bios from XFS, but Christoph Hellwig pointed out that kmalloced pages can also come from ext3 when it's doing log recovery, and they'll have zero page counts.
>> 
>> aiiee!
>> 
>> It is (I suppose) reasonable to put kmalloced memory into a BIO's page
>> array.  And it is perfectly reasonable for a user of that bio to do a
>> get_page/put_page against that page.  It is utterly unreasonable for
>> the damn page to get freed as a result!
>> 
>> I'd claim that slab is broken.  The page is in use, so it should have an
>> elevated refcount, full stop.
>> 
> 
> err, no.  slab.c uses alloc_pages(), so the underlying page indeed has
> a proper refcount.  I'm still not understanding how this situation comes
> about.

It sounds like it's wrong to give block pages with a zero count, so why not just have aoe BUG_ON(compound_trans_head(bv->page->_count) == 0) until we're sure nobody does that anymore?

If that idea makes sense to you, I will submit a new patch to follow the one under discussion.

-- 
  Ed Cashin
  ecashin@coraid.com


