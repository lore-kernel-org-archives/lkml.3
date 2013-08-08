Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966612Ab3HHVCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:02:33 -0400
Received: from server506d.appriver.com ([50.56.144.156]:63516 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966586Ab3HHVCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:02:31 -0400
X-Note-AR-ScanTimeLocal: 8/8/2013 4:02:30 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-200/SG:2 8/8/2013 4:01:59 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.964472 Source White
X-Signature-Violations: 0-0-0-4387-c
X-Note-419: 15.6011 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/8/2013 4:02:13 PM
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
In-Reply-To: <20130808125629.a5d6a55638743e2deee43065@linux-foundation.org>
Date: Thu, 8 Aug 2013 17:02:27 -0400
CC: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <2B226FB4-EC31-48EF-AD3E-2B25047A89E8@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org> <EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com> <20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org> <782613DB-4C38-450C-BBC2-E14FA64D44AC@coraid.com> <20130807163507.954590c479a07886a8ae6cb1@linux-foundation.org> <FA421A63-C90D-42A2-B5A3-0B55AB22673F@coraid.com> <20130807170548.b4bb3355d3aec8f280c7feff@linux-foundation.org> <6E6337F8-28E9-4361-A7E5-063C6AFFE5BD@coraid.com> <20130808125629.a5d6a55638743e2deee43065@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 8, 2013, at 3:56 PM, Andrew Morton wrote:

> On Wed, 7 Aug 2013 20:50:09 -0400 Ed Cashin <ecashin@coraid.com> wrote:
...
>> When the workaround was created, it was with the assumption that the zero-count pages are not always tail pages, and that seemed to be the case in 2007, but as I said, I don't have a mechanism for detecting that now, so I cannot say whether it really happens with today's kernel.
> 
> It sounds we should pull out all that code and retest.  It shouldn't be
> needed - if this results in some failure then I suspect core MM will
> need changes.

OK.  I'll look into that.  It sure would be nice to get rid of it.

> Why don't you have a "mechanism for detecting that"?  It's a matter of
> pointing AOE at some hugetlb pages?

No, I was testing with hugetlb pages already.  But there are many use case combinations, and I meant that aoe has no mechanism that has been in the aoe code all these years to catch specific (possibly rare) use cases that result in zero-count pages.  It would be something like this:

+static void
+check_page_counts(struct bio *bio)
+{
+       struct bio_vec *bv;
+       int n;
+       int i;
+
+       bio_for_each_segment(bv, bio, i) {
+               n = page_count(bv->bv_page);
+               WARN_ONCE(n <= 0,
+                       "aoe: page %d in bio has non-positive count %d\n",
+                       i, n);
+       }
+}

I'll add that when I try testing without the page count manipulation.

-- 
  Ed Cashin
  ecashin@coraid.com


