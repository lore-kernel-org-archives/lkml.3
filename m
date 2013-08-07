Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3HGXyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:54:50 -0400
Received: from server506k.appriver.com ([50.56.144.157]:52060 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933256Ab3HGXyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:54:49 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 6:54:48 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-58/SG:2 8/7/2013 6:53:57 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.980404 Source White
X-Signature-Violations: 0-0-0-7272-c
X-Note-419: 15.6011 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 6:54:46 PM
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
In-Reply-To: <20130807163507.954590c479a07886a8ae6cb1@linux-foundation.org>
Date: Wed, 7 Aug 2013 19:54:45 -0400
CC: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <FA421A63-C90D-42A2-B5A3-0B55AB22673F@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org> <EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com> <20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org> <782613DB-4C38-450C-BBC2-E14FA64D44AC@coraid.com> <20130807163507.954590c479a07886a8ae6cb1@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 7, 2013, at 7:35 PM, Andrew Morton wrote:

> On Wed, 7 Aug 2013 19:27:40 -0400 Ed Cashin <ecashin@coraid.com> wrote:
> 
>> On Aug 7, 2013, at 5:26 PM, Andrew Morton wrote:
>> 
>>> On Wed, 7 Aug 2013 17:21:32 -0400 Ed Cashin <ecashin@coraid.com> wrote:
>> ...
>>>> Sorry.  I tried to cover that but maybe should have separated it more clearly from the running text.
>>>> 
>>>> The patch changes the current behavior encountered with direct I/O and aoe:
>>>> 
>>>> aoe can BUG when direct I/O used
>>>> 
>>>> ... to a new behavior:
>>>> 
>>>> aoe does not BUG when direct I/O is used
>>>> 
>>>> And the user will never know that instead aoe is manipulating the _count of the head page, even though that's what's happening with this patch applied.
>>>> 
>>>> (The user-visible effects that motivated the older patch that added the BUG to aoe when page tails are used for block I/O was a VM_BUG_ON that occurred when the aoe driver manipulated the _count of a compound page tail.)
>>> 
>>> OK, I added "Fix a BUG which can trigger when direct-IO is used with
>>> AOE".  Which kernel versions are affected?
>> 
>> 
>> That BUG was added to the aoe driver in a commit that first appears in v3.7.  It persists until this patch adds the code that handles the situation that the BUG was intended to detect.
>> 
>> [ecashin@marino linux]$ git describe --contains --match 'v*' 69cf2d85de773d998798e47e3335b85e5645d157
>> v3.7-rc1~110^2~22
>> [ecashin@marino linux]$ 
>> 
> 
> ah, is it this?
> 
> +bio_pageinc(struct bio *bio)
> +{
> +       struct bio_vec *bv;
> +       struct page *page;
> +       int i;
> +
> +       bio_for_each_segment(bv, bio, i) {
> +               page = bv->bv_page;
> +               /* Non-zero page count for non-head members of
> +                * compound pages is no longer allowed by the kernel,
> +                * but this has never been seen here.
> +                */
> +               if (unlikely(PageCompound(page)))
> +                       if (compound_trans_head(page) != page) {
> +                               pr_crit("page tail used for block I/O\n");
> +                               BUG();
> +                       }
> 
> But get_page/put_page against a tail page of a compound page should
> Just Work.  The core MM will hunt down the head page and manipulate its
> refcount.  
> 
> Perhaps the problem here is that AOE is diving under the covers and is
> using low-level page refcount alterations:
> 
> +               atomic_inc(&page->_count);
> 
> Why does AOE do this?  It would be better if it were to use the
> official published MM interfaces.  If those interfaces need
> alteration/augmentation then we can do that.

The get_page cannot be used when the _count is 0 (which is exactly when we need to increment it), because it will VM_BUG_ON.

	/*
	 * Getting a normal page or the head of a compound page
	 * requires to already have an elevated page->_count.
	 */
	VM_BUG_ON(atomic_read(&page->_count) <= 0);

(And seeing the code reminds me that I forgot to include atomic_read in my last email's proposal.  LKML + dinner isn't a good mix. ;)

-- 
  Ed Cashin
  ecashin@coraid.com


