Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3KTViW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:38:22 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61256 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3KTViU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:38:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
References: <528A648F.1030007@oracle.com>
	<CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
Date: Wed, 20 Nov 2013 13:38:19 -0800
X-Google-Sender-Auth: gKtC4uiOsWOQQcSpyYTV96eHDWI
Message-ID: <CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
Subject: Re: [GIT PULL] direct IO support for loop driver
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 1:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> At that point, I just couldn't take it any more.

Just to clarify, I think it might be fixable. But it does need fixing,
because I really feel dirty from reading it. And I may not care all
that deeply about what random drivers or low-level filesystems do, but
I *do* care about generic code in mm/ and fs/, so making those iovec
functions uglier makes me go all "Hulk angry! Hulk smash" on the code.

The whole "separate out checking from user copy" needs to go away.
There's no excuse for it.

The whole "if (atomic) do_atomic_ops() else do_regular_ops()" crap
needs to go away. You can do it either by just duplicating the
function, or by having it use a indirect function for the copy (and
that indirect function acts like copy_from/to_user() and checks the
address range - and you can obviously then also have it be a "copy
from kernel" thing too if you want/need it). And no, you don't then
make it do *both* the conditional *and* the function pointer like you
did in that discusting commit that mixes the two with the struct
iov_iter_ops).

The "__" versions that don't check the user address range needs to die entirely.

The whole crazy "ii_iov_xyz" naming needs to go away. It doesn't even
make sense (one of the "i"s is for "iov".

That "unsigned long data" that contains an iovec *? WTF? How did that
ever start making sense?

IOW, there are many many details that just make me absolutely detest
this series. Enough that there's no way in hell I feel comfortable
pulling it. But they are likely fixable.

              Linus
