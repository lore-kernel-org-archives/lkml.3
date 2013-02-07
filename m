Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303Ab3BGVfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:35:22 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60590 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab3BGVfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:35:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130206171047.d27b5772.akpm@linux-foundation.org>
References: <1359591980-29542-1-git-send-email-walken@google.com>
	<1359591980-29542-2-git-send-email-walken@google.com>
	<5112F7AF.6010307@oracle.com>
	<20130206171047.d27b5772.akpm@linux-foundation.org>
Date: Thu, 7 Feb 2013 13:35:20 -0800
Message-ID: <CANN689FV+0Z_TuqWKdsmUHk7HMFDuk31uQO=eH79+249nfOQrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: use long type for page counts in mm_populate()
 and get_user_pages()
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 5:10 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 06 Feb 2013 19:39:11 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> We're now hitting the VM_BUG_ON() which was added in the last hunk of the
>> patch:
>
> hm, why was that added.
>
> Michel, I seem to have confused myself over this series.  I saw a
> report this morning which led me to drop
> mm-accelerate-munlock-treatment-of-thp-pages.patch but now I can't find
> that report and I'm wondering if I should have dropped
> mm-accelerate-mm_populate-treatment-of-thp-pages.patch instead.
>
> Given that and Sasha's new report I think I'll drop
>
> mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
> mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch
> mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix-fix.patch
> mm-accelerate-mm_populate-treatment-of-thp-pages.patch
> mm-accelerate-munlock-treatment-of-thp-pages.patch
>
> and let's start again?

All right. My bad, there were issues in the patch series. I think
there were two:

- The VM_BUG_ON(!reg) in "mm: use long type for page counts in
mm_populate() and get_user_pages()". The intention there was to test
for what happened in the original overflow case, which is that gup
would return 0 as the passed nr_pages argument (when passed as an int)
would be <= 0. As it turns out, this didn't account for the other case
where gup returns 0, which is when the first page is file-backed, not
found in page cache, and the mmap_sem gets dropped due to a non-NULL
"nonblocking" argument (as is the case with mm_populate())

- The issue in munlock, where the page mask wasn't correctly computed
due to an off by 1 issue.

I agree a clean resend seems the most appropriate course of action at
this point. Sorry for the trouble :/

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
