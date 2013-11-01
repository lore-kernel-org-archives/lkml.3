Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3KARrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:47:36 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:55809 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3KARrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <20131101140917.GF30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
	<20131101084329.GB19466@laptop.lan>
	<20131101093844.GA30123@yliu-dev.sh.intel.com>
	<20131101102224.GE19466@laptop.lan>
	<20131101140917.GF30123@yliu-dev.sh.intel.com>
Date: Fri, 1 Nov 2013 10:47:34 -0700
X-Google-Sender-Auth: _SZYj16farK7N9P66MWHfPt0O9Q
Message-ID: <CA+55aFxeNisBgvE9EePR9OGm_BkO7RvxbqCws04v7QTJ=bGMnw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 7:09 AM, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>
> Sorry, I may be wrong again this time. But, isn't vma->anon_vma_chain
> list being protect by mmap_sem & page_table_lock?

No.

The mmap_sem (and the page_table_lock) only protects a single VM instance.

The anon_vma chains, in contrast, can span multiple VM instances,
since it grows over fork().

Now, you're right that we used to not always lock the root every time,
but the code has changed since. We used to lock each anon_vma as we
copied them, now we lock the root only once (see anon_vma_clone()).
And that works exactly because they all share the same root anon_vma
on the chain. You can't change that to just randomly lock one non-root
vma.

So I'll add my voice to the chorus that says "that's wrong", when you
changed "anon_vma->root->lock" to "anon_vma->lock".

We *may* be able to do finer-grained anon_vma locking again, but it's
definitely not some mindless "let's just change it back" thing. It
needs real code changes (and I bet it's not just anon_vma_clone()),
and it needs a lot of care.

               Linus
