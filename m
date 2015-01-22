Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbbAVA6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:58:31 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39545 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbAVA6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:58:22 -0500
Date: Wed, 21 Jan 2015 16:58:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mgorman@suse.de, minchan@kernel.org, iamjoonsoo.kim@lge.com
Subject: Re: [PATCH] mm: compaction: fix the page state calculation in
 too_many_isolated
In-Reply-To: <54BF78E3.7030303@suse.cz>
Message-ID: <alpine.DEB.2.10.1501211656160.28120@chino.kir.corp.google.com>
References: <1421832864-30643-1-git-send-email-vinmenon@codeaurora.org> <54BF78E3.7030303@suse.cz>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Vlastimil Babka wrote:

> On 01/21/2015 10:34 AM, Vinayak Menon wrote:
> > Commit "3611badc1baa" (mm: vmscan: fix the page state calculation in
> 
> That appears to be a -next commit ID, which won't be the same in Linus' tree, so
> it shouldn't be in commit message, AFAIK.
> 
> > too_many_isolated) fixed an issue where a number of tasks were
> > blocked in reclaim path for seconds, because of vmstat_diff not being
> > synced in time. A similar problem can happen in isolate_migratepages_block,
> > similar calculation is performed. This patch fixes that.
> 
> I guess it's not possible to fix the stats instantly and once in the safe
> versions, so that future readings will be correct without safe, right?
> So until it gets fixed, each reading will have to be safe and thus expensive?
> 

Yeah, this patch will actually hurt performance for the migration scanner 
but not as much as stalling unnecessarily when the snapshot is the same.

> I think in case of async compaction, we could skip the safe stuff and just
> terminate it - it's already done when too_many_isolated returns true, and
> there's no congestion waiting in that case.
> 
> So you could extend the too_many_isolated() with "safe" parameter (as you did
> for vmscan) and pass it "cc->mode != MIGRATE_ASYNC" value from
> isolate_migrate_block().
> 

Or just pass it struct compact_control *cc and use both cc->zone and 
cc->mode inside this compaction-only function.
