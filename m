Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaAVSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:40:22 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40379 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751788AbaAVSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:40:21 -0500
Date: Wed, 22 Jan 2014 12:40:42 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/2] mm->def_flags cleanups (Was: Change khugepaged to
 respect MMF_THP_DISABLE flag)
Message-ID: <20140122184042.GQ18196@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
 <20140118234957.GB10970@node.dhcp.inet.fi>
 <20140120195812.GD18196@sgi.com>
 <20140120201525.GA31416@redhat.com>
 <20140120204108.GE18196@sgi.com>
 <20140122174553.GA29710@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122174553.GA29710@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 06:45:53PM +0100, Oleg Nesterov wrote:
> Alex, Andrew, I think this simple series makes sense in any case,
> but _perhaps_ it can also help THP_DISABLE.
> 
> On 01/20, Alex Thorlton wrote:
> >
> > On Mon, Jan 20, 2014 at 09:15:25PM +0100, Oleg Nesterov wrote:
> > >
> > > Although I got lost a bit, and probably misunderstood... but it
> > > seems to me that whatever you do this patch should not touch
> > > khugepaged_scan_mm_slot.
> >
> > Maybe I've gotten myself confused as well :)  After looking through the
> > code some more, my understanding is that khugepaged_test_exit is used to
> > make sure that __khugepaged_exit isn't running from underneath at certain
> > times, so to have khugepaged_test_exit return true when __khugepaged_exit
> > is not necessarily running, seems incorrect to me.
> 
> Still can't understand... probably I need to see v3.

I think the appropriate place to check this is actually in
hugepage_vma_check, so you're correct that we don't need to directly
touch khugepaged_scan_mm_slot, we just need to change a different
function underneath it.

We'll table that for now, though.  I'll put out a v3 later today, so you
can see what I'm talking about, but I think your idea looks like it will
be better in the end.

> But you know, I have another idea. Not sure you will like it, and probably
> I missed something.
> 
> Can't we simply add VM_NOHUGEPAGE into ->def_flags? See the (untested)
> patch below, on top of this series.
> 
> What do you think?

At a glance, without testing, it looks like a good idea to me.  By
using def_flags, we leverage functionality that's already in place to
achieve the same result.  We don't need to add any new checks into the
fault path or into khugepaged, since we're just leveraging the
VM_HUGEPAGE/NOHUGEPAGE flag, which we already check for.  We also get
the behavior that you suggested (madvise is still respected, even with
the new THP disable prctl set), for free with this method.

I like the idea, but I think that it should probably be a separate
change from the other few cleanups that you proposed along with it, since
they're somewhat unrelated to this particular issue.  Do you agree?

Also, one small note on the code:

> diff --git a/kernel/sys.c b/kernel/sys.c
> index ac1842e..eb8b0fc 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2029,6 +2029,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  		return current->no_new_privs ? 1 : 0;
> +	case PR_SET_THP_DISABLE:
> +	case PR_GET_THP_DISABLE:
> +		down_write(&me->mm->mmap_sem);
> +		if (option == PR_SET_THP_DISABLE) {
> +			if (arg2)
> +				me->mm->def_flags |= VM_NOHUGEPAGE;
> +			else
> +				me->mm->def_flags &= ~VM_NOHUGEPAGE;
> +		} else {
> +			error = !!(me->mm->flags && VM_NOHUGEPAGE);

Should be:

error = !!(me->mm->def_flags && VM_NOHUGEPAGE);

Correct?

- Alex
