Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbbA0BfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:35:06 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:42365 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbbA0BfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:35:04 -0500
Date: Tue, 27 Jan 2015 03:34:41 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>,
        Stable <stable@vger.kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH] proc/pagemap: walk page tables under pte lock
Message-ID: <20150127013441.GB3007@node.dhcp.inet.fi>
References: <20150126145214.11053.5670.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126145214.11053.5670.stgit@buzz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
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

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
