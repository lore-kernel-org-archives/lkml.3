Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3HHAuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 20:50:17 -0400
Received: from server506b.appriver.com ([50.56.144.14]:49955 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933522Ab3HHAuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 20:50:15 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 7:50:12 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-34/SG:2 8/7/2013 7:49:41 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.976312 Source White
X-Signature-Violations: 0-0-0-7671-c
X-Note-419: 15.6008 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 7:49:53 PM
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
In-Reply-To: <20130807170548.b4bb3355d3aec8f280c7feff@linux-foundation.org>
Date: Wed, 7 Aug 2013 20:50:09 -0400
CC: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <6E6337F8-28E9-4361-A7E5-063C6AFFE5BD@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org> <EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com> <20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org> <782613DB-4C38-450C-BBC2-E14FA64D44AC@coraid.com> <20130807163507.954590c479a07886a8ae6cb1@linux-foundation.org> <FA421A63-C90D-42A2-B5A3-0B55AB22673F@coraid.com> <20130807170548.b4bb3355d3aec8f280c7feff@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 7, 2013, at 8:05 PM, Andrew Morton wrote:

> On Wed, 7 Aug 2013 19:54:45 -0400 Ed Cashin <ecashin@coraid.com> wrote:
> 
>>> +bio_pageinc(struct bio *bio)
>>> +{
>>> +       struct bio_vec *bv;
>>> +       struct page *page;
>>> +       int i;
>>> +
>>> +       bio_for_each_segment(bv, bio, i) {
>>> +               page = bv->bv_page;
>>> +               /* Non-zero page count for non-head members of
>>> +                * compound pages is no longer allowed by the kernel,
>>> +                * but this has never been seen here.
>>> +                */
>>> +               if (unlikely(PageCompound(page)))
>>> +                       if (compound_trans_head(page) != page) {
>>> +                               pr_crit("page tail used for block I/O\n");
>>> +                               BUG();
>>> +                       }
>>> 
>>> But get_page/put_page against a tail page of a compound page should
>>> Just Work.  The core MM will hunt down the head page and manipulate its
>>> refcount.  
>>> 
>>> Perhaps the problem here is that AOE is diving under the covers and is
>>> using low-level page refcount alterations:
>>> 
>>> +               atomic_inc(&page->_count);
>>> 
>>> Why does AOE do this?  It would be better if it were to use the
>>> official published MM interfaces.  If those interfaces need
>>> alteration/augmentation then we can do that.
>> 
>> The get_page cannot be used when the _count is 0 (which is exactly when we need to increment it), because it will VM_BUG_ON.
>> 
>> 	/*
>> 	 * Getting a normal page or the head of a compound page
>> 	 * requires to already have an elevated page->_count.
>> 	 */
>> 	VM_BUG_ON(atomic_read(&page->_count) <= 0);
>> 
> 
> But we shouldn't get that far:
> 
> static inline void get_page(struct page *page)
> {
> 	if (unlikely(PageTail(page)))
> 		if (likely(__get_page_tail(page)))
> 			return;
> 	/*
> 	 * Getting a normal page or the head of a compound page
> 	 * requires to already have an elevated page->_count.
> 	 */
> 	VM_BUG_ON(atomic_read(&page->_count) <= 0);
> 	atomic_inc(&page->_count);
> }
> 
> This is a tail page, so we should be using __get_page_tail().


When the workaround was created, it was with the assumption that the zero-count pages are not always tail pages, and that seemed to be the case in 2007, but as I said, I don't have a mechanism for detecting that now, so I cannot say whether it really happens with today's kernel.

If it is never correct for normal pages or compound page heads to have a zero count while they are associated with a bio, then yes, I think get_page is a great solution.  The VM_BUG_ON in get_page would identify any parts of the kernel that are supplying bios that have pages without references.

Just a note in response to "we shouldn't get that far":  I believe the VM_BUG_ON line in get_page does get executed for tail pages when the __get_page_tail returns false because the compound page head has a zero count:

  get_page -> __get_page_tail -> get_page_unless_zero returns false, so
    __get_page_tail returns "got", which is still false, so
      get_page executes the VM_BUG_ON, where the _count will be zero for the tail page.

-- 
  Ed Cashin
  ecashin@coraid.com


