Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3GWCBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:01:21 -0400
Received: from nm12-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.140]:45227 "EHLO
	nm12-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab3GWCBU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:01:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 151799.55452.bm@omp1003.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LpaAKZFQ+132YbFnBSjUz96O7z+g5O7A+Chy7QitunjxTXTS4bU31DFZK5E7CuB1HZ+pID6frmdSqN51KYfGhYkatKuY5POjUGY+dAmDGin6dW9i6+sC8sH/AYLRGZYCq4porD66f0/ryhzm0jLPywQyYCvpr8ieveZJ3TRKPT4=;
X-YMail-OSG: BaGpeRIVM1m4xgVNv4oMjnDdEuwQdklDn2m685TuGV6c2qk
 m0mafdfSE2vREbPHaaxB0
X-Rocket-MIMEInfo: 002.001,CgpIaSBKb2hhbm5lcywKClRoYW5rIHlvdSBmb3IgeW91ciByZXBseS4gCgoKVGhpcyBpcyBteSBmaXJzdCBrZXJuZWwgcGF0Y2gsIHNvcnJ5IGZvciB0aGUgc21hbGwgbWlzdGFrZXMuClBsZWFzZSBmaW5kIG15IGNvbW1lbnRzIGlubGluZS4KCj5fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo.IEZyb206IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPgo.VG86IFBpbnR1IEt1bWFyIDxwaW50dS5rQHNhbXN1bmcuY29tPiAKPkNjOiBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOyABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.150.561
References: <1374492762-17735-1-git-send-email-pintu.k@samsung.com> <20130722163836.GD715@cmpxchg.org>
Message-ID: <1374544878.92541.YahooMailNeo@web160102.mail.bf1.yahoo.com>
Date: Mon, 22 Jul 2013 19:01:18 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [PATCH 2/2] mm: page_alloc: avoid slowpath for more than MAX_ORDER allocation.
To: Johannes Weiner <hannes@cmpxchg.org>, Pintu Kumar <pintu.k@samsung.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "cody@linux.vnet.ibm.com" <cody@linux.vnet.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpgs@samsung.com" <cpgs@samsung.com>
In-Reply-To: <20130722163836.GD715@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Johannes,

Thank you for your reply. 


This is my first kernel patch, sorry for the small mistakes.
Please find my comments inline.

>________________________________
> From: Johannes Weiner <hannes@cmpxchg.org>
>To: Pintu Kumar <pintu.k@samsung.com> 
>Cc: akpm@linux-foundation.org; mgorman@suse.de; jiang.liu@huawei.com; minchan@kernel.org; cody@linux.vnet.ibm.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; cpgs@samsung.com; pintu_agarwal@yahoo.com 
>Sent: Monday, 22 July 2013 10:08 PM
>Subject: Re: [PATCH 2/2] mm: page_alloc: avoid slowpath for more than MAX_ORDER allocation.
> 
>
>Hi Pintu,
>
>On Mon, Jul 22, 2013 at 05:02:42PM +0530, Pintu Kumar wrote:
>> It was observed that if order is passed as more than MAX_ORDER
>> allocation in __alloc_pages_nodemask, it will unnecessarily go to
>> slowpath and then return failure.
>> Since we know that more than MAX_ORDER will anyways fail, we can
>> avoid slowpath by returning failure in nodemask itself.
>> 
>> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
>> ---
>>  mm/page_alloc.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 202ab58..6d38e75 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1564,6 +1564,10 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
>>  
>>  static bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
>>  {
>> +    if (order >= MAX_ORDER) {
>> +        WARN_ON(!(gfp_mask & __GFP_NOWARN));
>> +        return false;
>> +    }
>
>I don't see how this solves what you describe (should return true?)
>

Ok, sorry, I will correct this.


>It would also not be a good place to put performance optimization,
>because this function is only called as part of a debugging mechanism
>that is usually disabled.
>

Ok, so you mean, we should add this check directly at the top of __alloc_pages_nodemask() ??



>Lastly, order >= MAX_ORDER is not supported by the page allocator, and
>we do not want to punish 99.999% of all legitimate page allocations in
>the fast path in order to catch an unlikely situation like this.

So, is it fine if we add an unlikely condition like below:
if (unlikely(order >= MAX_ORDER))

>Having the check only in the slowpath is a good thing.
>
Sorry, I could not understand, why adding this check in slowpath is only good.
We could have returned failure much before that.
Without this check, we are actually allowing failure of "first allocation attempt" and then returning the cause of failure in slowpath.
I thought it will be better to track the unlikely failure in the system as early as possible, at least from the embedded system prospective.
Let me know your opinion.


>--
>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>the body to majordomo@kvack.org.  For more info on Linux MM,
>see: http://www.linux-mm.org/ .
>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>
>
