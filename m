Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3JGODB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab3JGOC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:02:57 -0400
Message-ID: <5252BEFF.7040202@redhat.com>
Date: Mon, 07 Oct 2013 10:02:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/63] mm: Close races between THP migration and PMD numa
 clearing
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-9-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-9-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> THP migration uses the page lock to guard against parallel allocations
> but there are cases like this still open
> 
> Task A						Task B
> do_huge_pmd_numa_page				do_huge_pmd_numa_page
> lock_page
> mpol_misplaced == -1
> unlock_page
> goto clear_pmdnuma
> 						lock_page
> 						mpol_misplaced == 2
> 						migrate_misplaced_transhuge
> pmd = pmd_mknonnuma
> set_pmd_at
> 
> During hours of testing, one crashed with weird errors and while I have
> no direct evidence, I suspect something like the race above happened.
> This patch extends the page lock to being held until the pmd_numa is
> cleared to prevent migration starting in parallel while the pmd_numa is
> being cleared. It also flushes the old pmd entry and orders pagetable
> insertion before rmap insertion.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
