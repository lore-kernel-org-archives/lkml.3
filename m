Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaBOXub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:50:31 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:59637 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBOXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140214002427.GN13997@dastard>
References: <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard>
	<20140214002427.GN13997@dastard>
Date: Sat, 15 Feb 2014 15:50:29 -0800
X-Google-Sender-Auth: UkAlvS42Pt2YRlkKFqgQdi5_sso
Message-ID: <CA+55aFx=i6dbzCUZ6TwCMqniyS4C=tJx9+72p=EA+dU8Vn=2jQ@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added linux-mm to the participants list ]

On Thu, Feb 13, 2014 at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Dave, the patch below should chop off the stack usage from
> xfs_log_force_lsn() issuing IO by deferring it to the CIL workqueue.
> Can you given this a run?

Ok, so DaveJ confirmed that DaveC's patch fixes his issue (damn,
people, your parents were some seriously boring people, were they not?
We've got too many Dave's around), but DaveC earlier pointed out that
pretty much any memory allocation path can end up using 3kB of stack
even without XFS being involved.

Which does bring up the question whether we should look (once more) at
the VM direct-reclaim path, and try to avoid GFP_FS/IO direct
reclaim..

Direct reclaim historically used to be an important throttling
mechanism, and I used to not be a fan of trying to avoid direct
reclaim. But the stack depth issue really looks to be pretty bad, and
I think we've gotten better at throttling explicitly, so..

I *think* we already limit filesystem writeback to just kswapd (in
shrink_page_list()), but DaveC posted a backtrace that goes through
do_try_to_free_pages() to shrink_slab(), and through there to the
filesystem and then IO. That looked like a disaster.

And that's because (if I read things right) shrink_page_list() limits
filesystem page writeback to kswapd, but not swap pages. Which I think
probably made more sense back in the days than it does now (I
certainly *hope* that swapping is less important today than it was,
say, ten years ago)

So I'm wondering whether we should remove that page_is_file_cache()
check from shrink_page_list()?

And then there is that whole shrink_slab() case...

               Linus
