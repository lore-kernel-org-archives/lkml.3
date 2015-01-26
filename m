Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbbAZPOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:14:35 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46303 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbbAZPOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:14:30 -0500
Date: Mon, 26 Jan 2015 18:14:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>,
        Stable <stable@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH] proc/pagemap: walk page tables under pte lock
Message-ID: <20150126151426.GU7377@moon>
References: <20150126145214.11053.5670.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126145214.11053.5670.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 05:52:14PM +0300, Konstantin Khlebnikov wrote:
> Lockless access to pte in pagemap_pte_range() might race with page migration
> and trigger BUG_ON(!PageLocked()) in migration_entry_to_page():
> 
> CPU A (pagemap)                           CPU B (migration)
>                                           lock_page()
>                                           try_to_unmap(page, TTU_MIGRATION...)
>                                                make_migration_entry()
>                                                set_pte_at()
> <read *pte>
> pte_to_pagemap_entry()
>                                           remove_migration_ptes()
>                                           unlock_page()
>     if(is_migration_entry())
>         migration_entry_to_page()
>             BUG_ON(!PageLocked(page))
> 
> Also lockless read might be non-atomic if pte is larger than wordsize.
> Other pte walkers (smaps, numa_maps, clear_refs) already lock ptes.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Reported-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> Fixes: 052fb0d635df ("proc: report file/anon bit in /proc/pid/pagemap")
> Cc: Stable <stable@vger.kernel.org> (v3.5+)
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thank you!
