Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab3HGVVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:21:50 -0400
Received: from server506a.appriver.com ([50.56.144.13]:64072 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3HGVVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:21:46 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 4:21:46 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-86/SG:2 8/7/2013 4:21:31 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.97858 Source White
X-Signature-Violations: 0-0-0-5373-c
X-Note-419: 0 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 4:21:29 PM
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
In-Reply-To: <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org>
Date: Wed, 7 Aug 2013 17:21:32 -0400
CC: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 7, 2013, at 5:00 PM, Andrew Morton wrote:

> On Thu, 1 Aug 2013 21:29:59 -0400 Ed Cashin <ecashin@coraid.com> wrote:
> 
>> As discussed previously, the fact that some users of the block
>> layer provide bios that point to pages with a zero _count means
>> that it is not OK for the network layer to do a put_page on the
>> skb frags during an skb_linearize, so the aoe driver gets a
>> reference to pages in bios and puts the reference before ending
>> the bio.  And because it cannot use get_page on a page with a
>> zero _count, it manipulates the value directly.
>> 
>> It is not OK to increment the _count of a compound page tail,
>> though, since the VM layer will VM_BUG_ON a non-zero _count.
>> Block users that do direct I/O can result in the aoe driver
>> seeing compound page tails in bios.  In that case, the same logic
>> works as long as the head of the compound page is used instead of
>> the tails.  This patch handles compound pages and does not BUG.
>> 
>> It relies on the block layer user leaving the relationship
>> between the page tail and its head alone for the duration between
>> the submission of the bio and its completion, whether successful
>> or not.
> 
> What are the end-user-visible effects of the problem which is being
> fixed?  Please always include this info when fixing bugs so that others
> can work out what kernel version(s) need the patch.


Sorry.  I tried to cover that but maybe should have separated it more clearly from the running text.

The patch changes the current behavior encountered with direct I/O and aoe:

  aoe can BUG when direct I/O used

... to a new behavior:

  aoe does not BUG when direct I/O is used

And the user will never know that instead aoe is manipulating the _count of the head page, even though that's what's happening with this patch applied.

(The user-visible effects that motivated the older patch that added the BUG to aoe when page tails are used for block I/O was a VM_BUG_ON that occurred when the aoe driver manipulated the _count of a compound page tail.)

-- 
  Ed Cashin
  ecashin@coraid.com


