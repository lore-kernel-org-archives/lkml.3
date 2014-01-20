Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaATUkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 15:40:53 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34317 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758AbaATUku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 15:40:50 -0500
Date: Mon, 20 Jan 2014 14:41:08 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCHv2 2/2] Change khugepaged to respect MMF_THP_DISABLE
 flag
Message-ID: <20140120204108.GE18196@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
 <20140118234957.GB10970@node.dhcp.inet.fi>
 <20140120195812.GD18196@sgi.com>
 <20140120201525.GA31416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120201525.GA31416@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:15:25PM +0100, Oleg Nesterov wrote:
> On 01/20, Alex Thorlton wrote:
> >
> > No, definitely not.  Upon review, khugepaged_test_exit is the wrong
> > place to do this check.  I think I need to move it up to
> > khugepaged_scan_mm_slot for this to work correctly.
> 
> Why? unless a MMF_THP_DISABLE task does madvise(MADV_HUGEPAGE)
> khugepaged_scan_mm_slot() should never see its ->mm ?
> 
> Although I got lost a bit, and probably misunderstood... but it
> seems to me that whatever you do this patch should not touch
> khugepaged_scan_mm_slot.

Maybe I've gotten myself confused as well :)  After looking through the
code some more, my understanding is that khugepaged_test_exit is used to
make sure that __khugepaged_exit isn't running from underneath at certain
times, so to have khugepaged_test_exit return true when __khugepaged_exit
is not necessarily running, seems incorrect to me.

I think the check for MMF_THP_DISABLE should occur at the same time as
we check khugepaged_test_exit, but should occur separately, since I
don't really believe the two checks are related.  Something like this in
khugepaged_scan_mm_slot:

        mm = mm_slot->mm;
        down_read(&mm->mmap_sem);
-       if (unlikely(khugepaged_test_exit(mm)))
+       if (unlikely(khugepaged_test_exit(mm) || check_mmf_thp_disable(mm)))
                vma = NULL;
        else
                vma = find_vma(mm, khugepaged_scan.address);

        progress++;

I think this makes more sense, but I may not be looking at this
correctly.  Thoughts?

- Alex
