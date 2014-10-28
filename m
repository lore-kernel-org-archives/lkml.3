Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaJ1LpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:45:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33024 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbaJ1LpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:45:08 -0400
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 0/2] Fix a couple of issues with zap_pte_range and MMU gather
Date: Tue, 28 Oct 2014 11:44:20 +0000
Message-Id: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch series attempts to fix a couple of issues I've noticed with
zap_pte_range and the MMU gather code on arm64.

Ths first fix resolves a TLB range truncation, which I found by code
inspection (this is on the batch failure path, which doesn't appear to
be regularly exercised on my system).

For the second fix, I'd really appreciate some comments. The problem is
that the architecture TLB batching implementation may update the start
and end fields of the gather structure, so that they actually cover only
a subset of the initial range set up by tlb_gather_mmu (based on calls
to tlb_remove_tlb_entry). In the force_flush case, zap_pte_range sets
these fields directly, which can result in a negative range if the
architecture has also updated the end address. The patch here uses
min(end, addr) as the end of the first range, which creates a second
range from that address to the end of the region. This results in a
potential over-invalidation on arm64, but I can't think of anything
better without updating (at least) the x86 tlb.h implementation.

Ideally, we'd let the architecture set start/end during the call to
tlb_flush_mmu_tlbonly (arm64 does this already in tlb_flush).

Thoughts?

Will


Will Deacon (2):
  zap_pte_range: update addr when forcing flush after TLB batching
    faiure
  zap_pte_range: fix partial TLB flushing in response to a dirty pte

 mm/memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.1.1

