Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaAWQoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaAWQoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:44:13 -0500
Date: Thu, 23 Jan 2014 17:43:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] mm: thp: kill the bogus ->def_flags check in
	hugepage_madvise()
Message-ID: <20140123164334.GA7097@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com> <20140118234957.GB10970@node.dhcp.inet.fi> <20140120195812.GD18196@sgi.com> <20140120201525.GA31416@redhat.com> <20140120204108.GE18196@sgi.com> <20140122174553.GA29710@redhat.com> <20140122174646.GC29710@redhat.com> <alpine.LSU.2.11.1401221209520.1541@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401221209520.1541@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Hugh Dickins wrote:
>
> On Wed, 22 Jan 2014, Oleg Nesterov wrote:
>
> > hugepage_madvise() checks "mm->def_flags & VM_NOHUGEPAGE" but
> > this can be never true, currently mm->def_flags can only have
> > VM_LOCKED.
>
> But line 1087 of arch/s390/mm/pgtable.c says
> 	mm->def_flags |= VM_NOHUGEPAGE;
> from 3eabaee998c787e7e1565574821652548f7fc003
> "KVM: s390: allow sie enablement for multi-threaded programs".

Argh. Thanks Hugh!

Another case when I forgot about /bin/grep. So the patch is wrong,
at least the changelog is certainly is. I am stupid.

But, perhaps, this all still can work? Looks like, s390 already
implements PR_SET_THP_DISABLE using the same idea, it would be
nice to avoid another hack.

Gerald, any chance we can revert 8e72033f2a489 "thp: make MADV_HUGEPAGE
check for mm->def_flags" ? The changelog says "In order to also prevent
MADV_HUGEPAGE on such an mm", is it really important? I mean, if the
application calls madvise(MADV_HUGEPAGE) it should probably know what
it does and, this can be useful after if PR_SET_THP_DISABLE or
KVM_S390_ENABLE_SIE. Of course I do not understand this code, perhaps
MADV_HUGEPAGE is simply impossible.

Another question, can't fork/exec preserve VM_NOHUGEPAGE in ->def_flags?
This is what PR_SET_THP_DISABLE wants.

I'll send you mbox with the previous discussion privately.

Thanks,

Oleg.

