Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaECX53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 19:57:29 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:58260 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaECX52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 19:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <1399160247-32093-1-git-send-email-richard@nod.at>
References: <alpine.LSU.2.11.1404161239320.6778@eggly.anvils>
	<1399160247-32093-1-git-send-email-richard@nod.at>
Date: Sat, 3 May 2014 16:57:27 -0700
X-Google-Sender-Auth: dYpGgPUovJYlhyrupczg4uf3WUQ
Message-ID: <CA+55aFzbSUPGWyO42KM7geAy8WrP8e=q+KoqdOBY68zay0jrZA@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix force_flush behavior in zap_pte_range()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2014 at 4:37 PM, Richard Weinberger <richard@nod.at> wrote:
> Commit 1cf35d47 (mm: split 'tlb_flush_mmu()' into tlb flushing and memory freeing parts)
> accidently changed the behavior of the force_flush variable.

No it didn't. There was nothing accidental about it, and it doesn't
even change it the way you claim.

> Before the patch it was set by __tlb_remove_page(). Now it is only set to 1
> if __tlb_remove_page() returns false but never set back to 0 if __tlb_remove_page()
> returns true.

It starts out as zero. If __tlb_remove_page() returns true, it never
gets set to anything *but* zero, except by the dirty shared mapping
case that *needs* to set it to non-zero, exactly because it *needs* to
flush the TLB before releasing the pte lock.

Which was the whole point of the patch.

Your explanation makes no sense for _another_ reason: even with your
patch, it never gets set back to zero, since if it gets set to one you
have that "break" in there. So the whole "gets set back to zero" is
simply not relevant or true, with or with the patch.

The only place it actually gets zeroed (apart from initialization) is
for the "goto again" case, which does it (and always did it)

> Fixes BUG: Bad rss-counter state ...
> and
> kernel BUG at mm/filemap.c:202!

So tell us more about those actual problems, because your patch and
explanation is clearly wrong.

What hardware, what load, what "kernel BUG at filemap.c:202"?

The shared dirty fix may certainly be exposing some other issue, but
the only report I have seen about filemap.c:202 was reported by Dave
Jones ten *days* before the commit you talk about was even done.

So this whole thing makes no sense what-so-ever.

              Linus
