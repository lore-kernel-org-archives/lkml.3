Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3FJUEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:04:16 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:61772 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3FJUEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1306102137560.3200@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1306102137560.3200@boston.corp.fedex.com>
Date: Mon, 10 Jun 2013 13:04:13 -0700
X-Google-Sender-Auth: YzlvMdM7Pz8MBEBuDIlFlmq4xLQ
Message-ID: <CA+55aFyC2CEqkprnXD-LFr-WL6i7FJUDO4CUpgNsCSrd=SFxgQ@mail.gmail.com>
Subject: Re: binfmt_misc broken
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 6:52 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> binfmt_misc is truncating e->size, so once ARM's magic is loaded, 32-bit x86
> can no longer run.

That patch is really ugly. And it doesn't make much sense. Where does
it now turn the hex into binary? And where does it check that the mask
is the same size as the data? You have changed the meaning of "esize"
to be the size of the original string, which is just wrong, and makes
no sense, since it has to be the same value for magic and for mask. So
the patch seems to make things just worse.

That said, there does seem to be *real* bugs, like "check_file()", that does

    if (p && !strcmp(e->magic, p + 1))

which seems wrong. I think it should use "memcmp( ..., e->size)" instead.

And from your /proc output, esize does get truncated. But where
exactly does that happen? Is string_unescape() just broken? The code
*shouldn't* look at zeroes in the magic/mask strings, because they
should all be treated as memory regions with size 'e->size'.

                Linus
