Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaJVSul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:50:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51827 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaJVSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:50:39 -0400
Message-ID: <5447FC6E.2000207@oracle.com>
Date: Wed, 22 Oct 2014 14:50:22 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
CC: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm, hugetlb: correct bit shift in hstate_sizelog
References: <1413915307-20536-1-git-send-email-sasha.levin@oracle.com>	<544743D6.6040103@samsung.com> <20141022114437.72eb61ce3e2348c52ab3d1db@linux-foundation.org>
In-Reply-To: <20141022114437.72eb61ce3e2348c52ab3d1db@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 02:44 PM, Andrew Morton wrote:
> On Wed, 22 Oct 2014 09:42:46 +0400 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> 
>> > On 10/21/2014 10:15 PM, Sasha Levin wrote:
>>> > > hstate_sizelog() would shift left an int rather than long, triggering
>>> > > undefined behaviour and passing an incorrect value when the requested
>>> > > page size was more than 4GB, thus breaking >4GB pages.
>> > 
>>> > > 
>>> > > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>> > > ---
>>> > >  include/linux/hugetlb.h |    3 ++-
>>> > >  1 file changed, 2 insertions(+), 1 deletion(-)
>>> > > 
>>> > > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> > > index 65e12a2..57e0dfd 100644
>>> > > --- a/include/linux/hugetlb.h
>>> > > +++ b/include/linux/hugetlb.h
>>> > > @@ -312,7 +312,8 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
>>> > >  {
>>> > >  	if (!page_size_log)
>>> > >  		return &default_hstate;
>>> > > -	return size_to_hstate(1 << page_size_log);
>>> > > +
>>> > > +	return size_to_hstate(1UL << page_size_log);
>> > 
>> > That still could be undefined on 32-bits. Either use 1ULL or reduce SHM_HUGE_MASK on 32bits.
>> > 
> But
> 
> struct hstate *size_to_hstate(unsigned long size)

True, but "(1 << page_size_log)" produces an integer rather than long because "1"
is an int and not long.

	#include <stdio.h>

	int main(void)
	{
	        unsigned long a, b;

	        a = 1 << 32;
	        b = 1UL << 32;

	        printf("a: %lu b: %lu\n", a, b);
	}


	$ ./a.out
	a: 0 b: 4294967296


With the patch, size_to_hstate() gets the unsigned long it expects.


Thanks,
Sasha

