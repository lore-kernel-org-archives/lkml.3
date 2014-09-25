Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaIYVQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:16:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaIYVQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:16:53 -0400
Date: Thu, 25 Sep 2014 23:16:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v2] kvm: Faults which trigger IO release the mmap_sem
Message-ID: <20140925211604.GA4590@redhat.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
 <1410976308-7683-1-git-send-email-andreslc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410976308-7683-1-git-send-email-andreslc@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Wed, Sep 17, 2014 at 10:51:48AM -0700, Andres Lagar-Cavilla wrote:
> +	if (!locked) {
> +		VM_BUG_ON(npages != -EBUSY);
> +

Shouldn't this be VM_BUG_ON(npages)?

Alternatively we could patch gup to do:

			case -EHWPOISON:
+			case -EBUSY:
				return i ? i : ret;
-			case -EBUSY:
-				return i;

I need to fix gup_fast slow path to start with FAULT_FLAG_ALLOW_RETRY
similarly to what you did to the KVM slow path.

gup_fast is called without the mmap_sem (incidentally its whole point
is to only disable irqs and not take the locks) so the enabling of
FAULT_FLAG_ALLOW_RETRY initial pass inside gup_fast should be all self
contained. It shouldn't concern KVM which should be already fine with
your patch, but it will allow the userfaultfd to intercept all
O_DIRECT gup_fast in addition to KVM with your patch.

Eventually get_user_pages should be obsoleted in favor of
get_user_pages_locked (or whoever we decide to call it) so the
userfaultfd can intercept all kind of gups. gup_locked is same as gup
except for one more "locked" parameter at the end, I called the
parameter locked instead of nonblocking because it'd be more proper to
call "nonblocking" gup the FOLL_NOWAIT kind which is quite the
opposite (in fact as the mmap_sem cannot be dropped in the non
blocking version).

ptrace ironically is better off sticking with a NULL locked parameter
and to get a sigbus instead of risking hanging on the userfaultfd
(which would be safe as it can be killed, but it'd be annoying if
erroneously poking into a hole during a gdb session). It's still
possible to pass NULL as parameter to get_user_pages_locked to achieve
that. So the fact some callers won't block in handle_userfault because
FAULT_FLAG_ALLOW_RETRY is not set and the userfault cannot block, may
come handy.

What I'm trying to solve in this context is that the userfault cannot
safely block without FAULT_FLAG_ALLOW_RETRY because we can't allow
userland to take the mmap_sem for an unlimited amount of time without
requiring special privileges, so if handle_userfault wants to blocks
within a gup invocation, it must first release the mmap_sem hence
FAULT_FLAG_ALLOW_RETRY is always required at the first attempt for any
virtual address.

With regard to the last sentence, there's actually a race with
MADV_DONTNEED too, I'd need to change the code to always pass
FAULT_FLAG_ALLOW_RETRY (your code also would need to loop and
insisting with the __get_user_pages(locked) version to solve it). The
KVM ioctl worst case would get an -EFAULT if the race materializes for
example. It's non concerning though because that can be solved in
userland somehow by separating ballooning and live migration
activities.

Thanks,
Andrea
