Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaFKLYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:24:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaFKLYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:24:47 -0400
Message-ID: <53983C7B.8040705@suse.cz>
Date: Wed, 11 Jun 2014 13:24:43 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 03/10] mm, compaction: periodically drop lock and restore
 IRQs in scanners
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-3-git-send-email-vbabka@suse.cz> <20140611013218.GD15630@bbox>
In-Reply-To: <20140611013218.GD15630@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 03:32 AM, Minchan Kim wrote:
>> >+	if (cc->mode == MIGRATE_ASYNC) {
>> >+		if (need_resched()) {
>> >+			cc->contended = COMPACT_CONTENDED_SCHED;
>> >+			return true;
>> >  		}
>> >-
>> >+		if (spin_is_locked(lock)) {
> Why do you use spin_is_locked instead of spin_is_contended?

Because I know I have dropped the lock. AFAIK spin_is_locked() means 
somebody else is holding it, which would be a contention for me if I 
would want to take it back. spin_is_contended() means that somebody else 
#1 is holding it AND somebody else #2 is already waiting for it.

Previously in should_release_lock() the code assumed that it was me who 
holds the lock, so I check if somebody else is waiting for it, hence 
spin_is_contended().

But note that the assumption was not always true when 
should_release_lock() was called from compact_checklock_irqsave(). So it 
was another subtle suboptimality. In async compaction when I don't have 
the lock, I should be deciding if I take it based on if somebody else is 
holding it. Instead it was deciding based on if somebody else #1 is 
holding it and somebody else #2 is waiting.
Then there's still a chance of race between this check and call to 
spin_lock_irqsave, so I could spin on the lock even if I don't want to. 
Using spin_trylock_irqsave() instead is like checking spin_is_locked() 
and locking, without this race.

So even though I will probably remove the spin_is_locked() check per 
David's objection, the trylock will still nicely prevent waiting on the 
lock in async compaction.
