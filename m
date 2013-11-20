Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3KTVuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:50:35 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36624 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KTVuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:50:32 -0500
Date: Wed, 20 Nov 2013 13:50:26 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
Message-ID: <20131120215026.GA21515@kmo>
References: <528A648F.1030007@oracle.com>
 <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
 <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 01:38:19PM -0800, Linus Torvalds wrote:
> On Wed, Nov 20, 2013 at 1:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > At that point, I just couldn't take it any more.
> 
> Just to clarify, I think it might be fixable. But it does need fixing,
> because I really feel dirty from reading it. And I may not care all
> that deeply about what random drivers or low-level filesystems do, but
> I *do* care about generic code in mm/ and fs/, so making those iovec
> functions uglier makes me go all "Hulk angry! Hulk smash" on the code.
> 
> The whole "separate out checking from user copy" needs to go away.
> There's no excuse for it.
> 
> The whole "if (atomic) do_atomic_ops() else do_regular_ops()" crap
> needs to go away. You can do it either by just duplicating the
> function, or by having it use a indirect function for the copy (and
> that indirect function acts like copy_from/to_user() and checks the
> address range - and you can obviously then also have it be a "copy
> from kernel" thing too if you want/need it). And no, you don't then
> make it do *both* the conditional *and* the function pointer like you
> did in that discusting commit that mixes the two with the struct
> iov_iter_ops).
> 
> The "__" versions that don't check the user address range needs to die entirely.
> 
> The whole crazy "ii_iov_xyz" naming needs to go away. It doesn't even
> make sense (one of the "i"s is for "iov".
> 
> That "unsigned long data" that contains an iovec *? WTF? How did that
> ever start making sense?
> 
> IOW, there are many many details that just make me absolutely detest
> this series. Enough that there's no way in hell I feel comfortable
> pulling it. But they are likely fixable.

To be honest, I'm skeptical that this approach (adding methods and a bunch of
complexity to iov_iter for backing them with biovecs) is necessary for fixing
the loop driver. 

I've been working on an alternate approach that in the process cleans a bunch of
stuff up - the idea is basically, 1) refactor and massage a bunch of stuff in
the block layer so bios can be created and submitting without caring about the
constraints of the underlying device, and then 2) rewrite the dio code to start
out by pinning pages directly into bios, then query the filesystem to map those
bios wherever - splitting as needed.

What this gets us is a nice clean split where (with some more handwaving; Zach
had some ideas about how to handle some annoying details) we can just submit
bios to some sort of new DIO method - and then the loop driver could just use
that directly.

IMO this would be vastly cleaner; we'd have one data structure - the iov_iter -
for memory that isn't pinned, and another data structure - struct bio - for
iterating over pinned pages. Most of the aforementioned block layer massaging
I've been doing was creating a real iterator for bios (that doesn't modify the
biovecs).

I've also done the DIO rewrite - awhile ago - and it's definitely not ready to
go upstream (various prereqs still aren't in), but it at least shows that the
approach is viable and my rewrite cuts fs/direct-io.c in _half_ while
significantly improving performance:

http://evilpiepirate.org/git/linux-bcache.git/commit/?h=block_stuff&id=caf18e8ec531daea29f61c9aa486443026a343c7
