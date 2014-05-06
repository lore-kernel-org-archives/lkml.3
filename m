Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759AbaEFKRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 06:17:37 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:61711 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934609AbaEFKRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 06:17:34 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140504062915.GQ18016@ZenIV.linux.org.uk>
References: <20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
	<20140502055127.GH18016@ZenIV.linux.org.uk>
	<CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
	<20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
	<20140502224022.GJ18016@ZenIV.linux.org.uk>
	<20140503042604.GM18016@ZenIV.linux.org.uk>
	<20140503182110.GN18016@ZenIV.linux.org.uk>
	<20140504062915.GQ18016@ZenIV.linux.org.uk>
Date: Tue, 6 May 2014 12:17:32 +0200
Message-ID: <CAJfpegvWOzd01tW5nRfWKW7EoBgPD8rudODJJm5OqxPd5Pd7uA@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2014 at 8:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, May 03, 2014 at 07:21:11PM +0100, Al Viro wrote:
>> On Sat, May 03, 2014 at 05:26:04AM +0100, Al Viro wrote:
>>
>> > See vfs.git#dentry_kill-3; warning - this is completely untested and I would
>> > really like comments on spinning case there (i.e. the one where select_collect()
>> > finds some stuff already on some other shrink list and nothing with zero
>> > refcount that wouldn't be there).  In that case (and it's basically "somebody
>> > else is evicting stuff in our subtree and they'd already picked everything
>> > we want evicted") I just let the loop in check_submounts_and_drop() repeat
>> > (we do have cond_resched() there).  Any better suggestions would be welcome...
>>
>> Hmm...  As the matter of fact, the whole shrink_dcache_for_umount() could
>> be made a lot saner.  What we need is to reuse shrink_dcache_parent()
>> and follow it with d_walk() that would just go through whatever remains and
>> complain about the leaves of that.  For anon roots we'll obviously need to
>> wrap that into dget and d_drop/dput.
>>
>> I'm testing that right now; everything seems to be working so far and if
>> it survives, I'll push that sucker out.  Total since the beginning of
>> the whole series:
>>  fs/dcache.c            |  310 ++++++++++++++++++++++++++++++++---------------------------------------------------------
>>  include/linux/dcache.h |    2 +
>>  2 files changed, 112 insertions(+), 200 deletions(-)
>
> No regressions compared to mainline; force-pushed into vfs#dentry_kill-3.
> Review and testing would be very welcome...  Summary for that branch:
> (it's *not* a pull request yet; the thing really needs review)

Patches look okay to me.

Reviewed-by: Miklos Szeredi <mszeredi@suse.cz>

>       dentry_kill(): don't try to remove from shrink list

Backport of this to 3.12 was tested by IBM and apparently fixes the
issue for them (I didn't backport the cleanup patches only the actual
fix)

>       don't remove from shrink list in select_collect()

I've also asked them to test this, although I think this is even
harder to trigger.  But at least the non-racy codepaths need to be
tested.

Thanks,
Miklos
