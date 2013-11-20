Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3KTWrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:47:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23369 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KTWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:47:13 -0500
Message-ID: <528D3BCE.2060703@oracle.com>
Date: Wed, 20 Nov 2013 16:46:38 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
References: <528A648F.1030007@oracle.com>	<CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com> <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
In-Reply-To: <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 03:38 PM, Linus Torvalds wrote:
> On Wed, Nov 20, 2013 at 1:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> At that point, I just couldn't take it any more.
> 
> Just to clarify, I think it might be fixable. But it does need fixing,
> because I really feel dirty from reading it. And I may not care all
> that deeply about what random drivers or low-level filesystems do, but
> I *do* care about generic code in mm/ and fs/, so making those iovec
> functions uglier makes me go all "Hulk angry! Hulk smash" on the code.

Okay, fair enough. This patchset started out as a bit of a hack, but it
ended up working well and I had multiple other developers wanting the
function in mainline. I didn't get too much critical feedback, but I
should have been more critical myself.

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

I'll fix those.

> The "__" versions that don't check the user address range needs to die entirely.
> 
> The whole crazy "ii_iov_xyz" naming needs to go away. It doesn't even
> make sense (one of the "i"s is for "iov".

okay

> That "unsigned long data" that contains an iovec *? WTF? How did that
> ever start making sense?

In a later patch, it could also be a biovec. It'd probably be better to
make it a union at that point, or at least add a comment.

> IOW, there are many many details that just make me absolutely detest
> this series. Enough that there's no way in hell I feel comfortable
> pulling it. But they are likely fixable.

Yeah, I'll work on something cleaner. The vital piece is some container
that can either contain an iovec or or an array of kernel pages to be
passed to the filesystems. The iov_iter structure was a reasonable
choice, but the implementation is a bit sloppy. Kent wants to pass the
bio structure itself, while this patchset used the biovec array. As long
as I'm reworking the patchset, I'll see if I can accommodate his
requirements.

Thanks,
Dave
