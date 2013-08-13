Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3HMRJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:09:37 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36643 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3HMRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <1376344480-156708-1-git-send-email-nzimmer@sgi.com>
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com>
	<1376344480-156708-1-git-send-email-nzimmer@sgi.com>
Date: Tue, 13 Aug 2013 10:09:34 -0700
X-Google-Sender-Auth: GZpiZWhT03QfUxDb8Ym3NBhLilU
Message-ID: <CA+55aFwTQLexJkf67P0b7Z7cw8fePjdDSdA4SOkM+Jf+kBPYEA@mail.gmail.com>
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
 embedded in the buddy allocator
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 2:54 PM, Nathan Zimmer <nzimmer@sgi.com> wrote:
>
> As far as extra overhead. We incur an extra function call to
> ensure_page_is_initialized but that is only really expensive when we find
> uninitialized pages, otherwise it is a flag check once every PTRS_PER_PMD.
> To get a better feel for this we ran two quick tests.

Sorry for coming into this late and for this last version of the
patch, but I have to say that I'd *much* rather see this delayed
initialization using another data structure than hooking into the
basic page allocation ones..

I understand that you want to do delayed initialization on some TB+
memory machines, but what I don't understand is why it has to be done
when the pages have already been added to the memory management free
list.

Could we not do this much simpler: make the early boot insert the
first few gigs of memory (initialized) synchronously into the free
lists, and then have a background thread that goes through the rest?

That way the MM layer would never see the uninitialized pages.

And I bet that *nobody* cares if you "only" have a few gigs of ram
during the first few minutes of boot, and you mysteriously end up
getting more and more memory for a while until all the RAM has been
initialized.

IOW, just don't call __free_pages_bootmem() on all the pages al at
once. If we have to remove a few __init markers to be able to do some
of it later, does anybody really care?

I really really dislike this "let's check if memory is initialized at
runtime" approach.

           Linus
