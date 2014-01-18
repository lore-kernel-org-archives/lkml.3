Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaARXuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 18:50:39 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:42390 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaARXug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 18:50:36 -0500
Date: Sun, 19 Jan 2014 01:49:57 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCHv2 2/2] Change khugepaged to respect MMF_THP_DISABLE
 flag
Message-ID: <20140118234957.GB10970@node.dhcp.inet.fi>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 03:01:44PM -0600, Alex Thorlton wrote:
> This just adds a simple check to get khugepaged to behave
> appropriately when MMF_THP_DISABLE is set.
> 
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> 
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c0b172..3cfe6b4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2049,7 +2049,8 @@ static void insert_to_mm_slots_hash(struct mm_struct *mm,
>  
>  static inline int khugepaged_test_exit(struct mm_struct *mm)
>  {
> -	return atomic_read(&mm->mm_users) == 0;
> +	return atomic_read(&mm->mm_users) == 0 ||
> +	       (mm->flags & MMF_THP_DISABLE_MASK);

__khugepaged_enter() has VM_BUG_ON(khugepaged_test_exit(mm)).
Do we really want to crash there if MMF_THP_DISABLE is set?

-- 
 Kirill A. Shutemov
