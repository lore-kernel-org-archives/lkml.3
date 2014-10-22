Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaJVUNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:13:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaJVUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:13:08 -0400
Date: Wed, 22 Oct 2014 13:13:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, n-horiguchi@ah.jp.nec.com,
        aarcange@redhat.com, mgorman@suse.de, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm, hugetlb: correct bit shift in hstate_sizelog
Message-Id: <20141022131308.361a72ba7c6fbf1bd778445a@linux-foundation.org>
In-Reply-To: <5447FC6E.2000207@oracle.com>
References: <1413915307-20536-1-git-send-email-sasha.levin@oracle.com>
	<544743D6.6040103@samsung.com>
	<20141022114437.72eb61ce3e2348c52ab3d1db@linux-foundation.org>
	<5447FC6E.2000207@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 14:50:22 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> On 10/22/2014 02:44 PM, Andrew Morton wrote:
> > On Wed, 22 Oct 2014 09:42:46 +0400 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> > 
> >> > On 10/21/2014 10:15 PM, Sasha Levin wrote:
> >>> > > hstate_sizelog() would shift left an int rather than long, triggering
> >>> > > undefined behaviour and passing an incorrect value when the requested
> >>> > > page size was more than 4GB, thus breaking >4GB pages.
> >> > 
> >>> > > 
> >>> > > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >>> > > ---
> >>> > >  include/linux/hugetlb.h |    3 ++-
> >>> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> >>> > > 
> >>> > > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> >>> > > index 65e12a2..57e0dfd 100644
> >>> > > --- a/include/linux/hugetlb.h
> >>> > > +++ b/include/linux/hugetlb.h
> >>> > > @@ -312,7 +312,8 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
> >>> > >  {
> >>> > >  	if (!page_size_log)
> >>> > >  		return &default_hstate;
> >>> > > -	return size_to_hstate(1 << page_size_log);
> >>> > > +
> >>> > > +	return size_to_hstate(1UL << page_size_log);
> >> > 
> >> > That still could be undefined on 32-bits. Either use 1ULL or reduce SHM_HUGE_MASK on 32bits.
> >> > 
> > But
> > 
> > struct hstate *size_to_hstate(unsigned long size)
> 
> True, but "(1 << page_size_log)" produces an integer rather than long because "1"
> is an int and not long.

My point is that there's no point in using 1ULL because
size_to_hstate() will truncate it anyway.

