Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaATCi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:38:57 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51970 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATCi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:38:56 -0500
MIME-Version: 1.0
In-Reply-To: <1390126616-29560-2-git-send-email-nab@linux-iscsi.org>
References: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
	<1390126616-29560-2-git-send-email-nab@linux-iscsi.org>
Date: Sun, 19 Jan 2014 18:38:55 -0800
X-Google-Sender-Auth: UyiLZ33KpRGqCy6jrOePt8TWSpg
Message-ID: <CA+55aFxLD4dPnQjb85LkB5eW24XsoUQD8n9XP9i-Oy2xM0iQKA@mail.gmail.com>
Subject: Re: [PATCH 1/5] percpu_ida: Make percpu_ida_alloc accept task state bitmask
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 2:16 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> This patch changes percpu_ida_alloc() to accept task state bitmask
> for prepare_to_wait() to support interruptible sleep for callers
> that require it.

This patch-series is not bisectable. Afaik, the first patch will break
the build (or at least cause the end result to not actually work).

This kind of "split up one large patch into many small patches THAT
DON'T ACTUALLY WORK INDIVIDUALLY" model is pure and utter garbage.

So a big NAK on this series as being completely broken.

To fix it, I would suggest:

 - make the first patch change all *existing* users (that only have
the atomic vs uninterruptible semantics) pass in either
TASK_UNINTERRUPTIBLE or TASK_RUNNING depending on whether they had
__GFP_WAIT or not.

   So the first patch would not change *any* semantics or behavior, it
would only change the calling convention.

 - do the cleanup patches to block/blk-mq-tag.c to not have those
"gfp" calling convention, and instead passing in the state natively

 - add the TASK_INTERRUPTIBLE case last (which includes the new
"signal_pending_state()" logic in percpu_ida_alloc())

that way, all patches compile cleanly and should each work
individually, and they all do clearly just one thing. And the biggest
patch in the series (the first one) doesn't actually make any semantic
changes.

                Linus
