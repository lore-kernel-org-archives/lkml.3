Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3LEUFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:05:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab3LEUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:05:12 -0500
Message-ID: <52A0DC7F.7050403@redhat.com>
Date: Thu, 05 Dec 2013 15:05:19 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, hhuang@redhat.com
Subject: Re: [PATCH 14/15] mm: numa: Flush TLB if NUMA hinting faults race
 with PTE scan update
References: <1386060721-3794-1-git-send-email-mgorman@suse.de> <1386060721-3794-15-git-send-email-mgorman@suse.de> <529E641A.7040804@redhat.com> <20131203234637.GS11295@suse.de> <529F3D51.1090203@redhat.com> <20131204160741.GC11295@suse.de> <20131205104015.716ed0fe@annuminas.surriel.com> <20131205195446.GI11295@suse.de>
In-Reply-To: <20131205195446.GI11295@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 02:54 PM, Mel Gorman wrote:

> I think that's a better fit and a neater fix. Thanks! I think it barriers
> more than it needs to (definite cost vs maybe cost), the flush can be
> deferred until we are definitely trying to migrate and the pte case is
> not guaranteed to be flushed before migration due to pte_mknonnuma causing
> a flush in ptep_clear_flush to be avoided later. Mashing the two patches
> together yields this.

I think this would fix the numa migrate case.

However, I believe the same issue is also present in
mprotect(..., PROT_NONE) vs. compaction, for programs
that trap SIGSEGV for garbage collection purposes.

They could lose modifications done in-between when
the pte was set to PROT_NONE, and the actual TLB
flush, if compaction moves the page around in-between
those two events.

I don't know if this is a case we need to worry about
at all, but I think the same fix would apply to that
code path, so I guess we might as well make it...
