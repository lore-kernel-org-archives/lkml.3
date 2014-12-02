Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaLBKBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:01:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62007 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLBKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:01:28 -0500
Date: Tue, 2 Dec 2014 11:01:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v17 1/7] mm: support madvise(MADV_FREE)
Message-ID: <20141202100125.GD27014@dhcp22.suse.cz>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-2-git-send-email-minchan@kernel.org>
 <20141127144725.GB19157@dhcp22.suse.cz>
 <20141130235652.GA10333@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141130235652.GA10333@bbox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-12-14 08:56:52, Minchan Kim wrote:
[...]
> From 2edd6890f92fa4943ce3c452194479458582d88c Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Mon, 1 Dec 2014 08:53:55 +0900
> Subject: [PATCH] madvise.2: Document MADV_FREE
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  man2/madvise.2 | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/man2/madvise.2 b/man2/madvise.2
> index 032ead7..33aa936 100644
> --- a/man2/madvise.2
> +++ b/man2/madvise.2
> @@ -265,6 +265,19 @@ file (see
>  .BR MADV_DODUMP " (since Linux 3.4)"
>  Undo the effect of an earlier
>  .BR MADV_DONTDUMP .
> +.TP
> +.BR MADV_FREE " (since Linux 3.19)"
> +Gives the VM system the freedom to free pages, and tells the system that
> +information in the specified page range is no longer important.
> +This is an efficient way of allowing
> +.BR malloc (3)

This might be rather misleading. Only some malloc implementations are
using this feature (jemalloc, right?). So either be specific about which
implementation or do not add it at all.

> +to free pages anywhere in the address space, while keeping the address space
> +valid. The next time that the page is referenced, the page might be demand
> +zeroed, or might contain the data that was there before the MADV_FREE call.
> +References made to that address space range will not make the VM system page the
> +information back in from backing store until the page is modified again.

I am not sure I understand the last sentence. So say I did MADV_FREE and
the reclaim has dropped that page. I know that the file backed mappings
are not supported yet but assume they were for a second... Now, I do
read from that location again what is the result?
If we consider anon mappings then the backing store is misleading as
well because memory was dropped and so always newly allocated.
I would rather drop the whole sentence and rather see an explanation
what is the difference between to MADV_DONT_NEED.
"
Unlike MADV_DONT_NEED the memory is freed lazily e.g. when the VM system
is under memory pressure.
"

> +It works only with private anonymous pages (see
> +.BR mmap (2)).
>  .SH RETURN VALUE
>  On success
>  .BR madvise ()
-- 
Michal Hocko
SUSE Labs
