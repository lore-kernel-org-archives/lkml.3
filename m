Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3KSV2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:28:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17134 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3KSV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:27:59 -0500
Message-ID: <528BD7BC.4010205@oracle.com>
Date: Tue, 19 Nov 2013 14:27:24 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm: tail page refcounting optimization for slab and
 hugetlbfs
References: <1384537668-10283-1-git-send-email-aarcange@redhat.com> <1384537668-10283-4-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384537668-10283-4-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 10:47 AM, Andrea Arcangeli wrote:
> This skips the _mapcount mangling for slab and hugetlbfs pages.
>
> The main trouble in doing this is to guarantee that PageSlab and
> PageHeadHuge remains constant for all get_page/put_page run on the
> tail of slab or hugetlbfs compound pages. Otherwise if they're set
> during get_page but not set during put_page, the _mapcount of the tail
> page would underflow.
>
> PageHeadHuge will remain true until the compound page is released and
> enters the buddy allocator so it won't risk to change even if the tail
> page is the last reference left on the page.
>
> PG_slab instead is cleared before the slab frees the head page with
> put_page, so if the tail pin is released after the slab freed the
> page, we would have a problem. But in the slab case the tail pin
> cannot be the last reference left on the page. This is because the
> slab code is free to reuse the compound page after a
> kfree/kmem_cache_free without having to check if there's any tail pin
> left. In turn all tail pins must be always released while the head is
> still pinned by the slab code and so we know PG_slab will be still set
> too.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>

--
Khalid
