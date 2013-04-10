Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937125Ab3DJQcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:32:04 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45470 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936705Ab3DJQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <1365610669-16625-4-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1365610669-16625-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365610669-16625-4-git-send-email-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 10 Apr 2013 12:31:39 -0400
X-Google-Sender-Auth: hEtg0ZqrR0jJRWOavlOQroptQkU
Message-ID: <CAHGf_=o6+RxyutMxai-82eHQDrx5KfiJ0-MCjqAO-nkbp1eiCA@mail.gmail.com>
Subject: Re: [RESEND][PATCH v5 3/3] hugetlbfs: add swap entry check in follow_hugetlb_page()
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:17 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> # I suspended Reviewed and Acked given for the previous version, because
> # it has a non-minor change. If you want to restore it, please let me know.
> -----
> With applying the previous patch "hugetlbfs: stop setting VM_DONTDUMP in
> initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a memory
> error happens on a hugepage and the affected processes try to access
> the error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <= 0)
> in get_page().
>
> The reason for this bug is that coredump-related code doesn't recognise
> "hugepage hwpoison entry" with which a pmd entry is replaced when a memory
> error occurs on a hugepage.
> In other words, physical address information is stored in different bit layout
> between hugepage hwpoison entry and pmd entry, so follow_hugetlb_page()
> which is called in get_dump_page() returns a wrong page from a given address.
>
> The expected behavior is like this:
>
>   absent   is_swap_pte   FOLL_DUMP   Expected behavior
>   -------------------------------------------------------------------
>    true     false         false       hugetlb_fault
>    false    true          false       hugetlb_fault
>    false    false         false       return page
>    true     false         true        skip page (to avoid allocation)
>    false    true          true        hugetlb_fault
>    false    false         true        return page
>
> With this patch, we can call hugetlb_fault() and take proper actions
> (we wait for migration entries, fail with VM_FAULT_HWPOISON_LARGE for
> hwpoisoned entries,) and as the result we can dump all hugepages except
> for hwpoisoned ones.
>
> ChangeLog v5:
>  - improve comment and description.
>
> ChangeLog v4:
>  - move is_swap_page() to right place.
>
> ChangeLog v3:
>  - add comment about using is_swap_pte()
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
