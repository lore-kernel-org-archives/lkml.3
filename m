Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267AbaGYUQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:16:43 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57749 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934542AbaGYUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:16:41 -0400
Date: Fri, 25 Jul 2014 13:16:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, jroedel@suse.de,
        Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] mmu_notifier: Add mmu_notifier_invalidate_range()
Message-ID: <20140725131639.698f18ff@jbarnes-desktop>
In-Reply-To: <1406212541-25975-2-git-send-email-joro@8bytes.org>
References: <1406212541-25975-1-git-send-email-joro@8bytes.org>
	<1406212541-25975-2-git-send-email-joro@8bytes.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 16:35:39 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> From: Joerg Roedel <jroedel@suse.de>
> 
> This notifier closes an important gap with the current
> invalidate_range_start()/end() notifiers. The _start() part
> is called when all pages are still mapped while the _end()
> notifier is called when all pages are potentially unmapped
> and already freed.
> 
> This does not allow to manage external (non-CPU) hardware
> TLBs with MMU-notifiers because there is no way to prevent
> that hardware will establish new TLB entries between the
> calls of these two functions. But this is a requirement to
> the subsytem that implements these existing notifiers.
> 
> To allow managing external TLBs the MMU-notifiers need to
> catch the moment when pages are unmapped but not yet freed.
> This new notifier catches that moment and notifies the
> interested subsytem when pages that were unmapped are about
> to be freed. The new notifier will only be called between
> invalidate_range_start()/end().

So if we were actually sharing page tables, we should be able to make
start/end no-ops and just use this new callback, assuming we didn't
need to do any other serialization or debug stuff, right?

Seems like a good addition, and saves us a bunch of trouble...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
