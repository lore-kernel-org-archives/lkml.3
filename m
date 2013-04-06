Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3DFHE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 03:04:56 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:65286 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab3DFHEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 03:04:55 -0400
Date: Sat, 6 Apr 2013 09:04:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] mbind: add hugepage migration code to mbind()
Message-ID: <20130406070450.GC4501@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-8-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130325134926.GZ2154@dhcp22.suse.cz>
 <515F4ECB.9050105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515F4ECB.9050105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-04-13 18:23:07, KOSAKI Motohiro wrote:
> >> -	if (!new_hpage)
> >> +	/*
> >> +	 * Getting a new hugepage with alloc_huge_page() (which can happen
> >> +	 * when migration is caused by mbind()) can return ERR_PTR value,
> >> +	 * so we need take care of the case here.
> >> +	 */
> >> +	if (!new_hpage || IS_ERR_VALUE(new_hpage))
> >>  		return -ENOMEM;
> > 
> > Please no. get_new_page returns NULL or a page. You are hooking a wrong
> > callback here. The error value doesn't make any sense here. IMO you
> > should just wrap alloc_huge_page by something that returns NULL or page.
> 
> I suggest just opposite way. new_vma_page() always return ENOMEM, ENOSPC etc instad 
> of NULL. and caller propegate it to userland.
> I guess userland want to distingush why mbind was failed.

Sure, and I wasn't suggesting to change alloc_huge_page. I was just
pointing out that new_page_t used to return page or NULL and hugetlb
unmap_and_move shouldn't be any different in that direction so using
alloc_huge_page is not a good fit here.

> Anyway, If new_vma_page() have a change to return both NULL and
> -ENOMEM. That's a bug.

-- 
Michal Hocko
SUSE Labs
