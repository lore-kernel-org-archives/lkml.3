Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3JHOZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:25:46 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55490 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3JHOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <1381198450-2202-1-git-send-email-phillip@squashfs.org.uk>
References: <1381198450-2202-1-git-send-email-phillip@squashfs.org.uk>
Date: Tue, 8 Oct 2013 23:25:42 +0900
X-Google-Sender-Auth: cuYADk0goMk8Qa7ipZrnPI9pfUY
Message-ID: <CAEwNFnAx5YVkTFgKu++Q1u5CXJ5-Pr6ti1x5JOjqan9WwnkJ3g@mail.gmail.com>
Subject: Re: [PATCH] Squashfs: Refactor decompressor interface and code
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 11:14 AM, Phillip Lougher
<phillip@squashfs.org.uk> wrote:
> The decompressor interface and code was written from
> the point of view of single-threaded operation.  In doing
> so it mixed a lot of single-threaded implementation specific
> aspects into the decompressor code and elsewhere which makes it
> difficult to seamlessly support multiple different decompressor
> implementations.
>
> This patch does the following:
>
> 1.  It removes compressor_options parsing from the decompressor
>     init() function.  This allows the decompressor init() function
>     to be dynamically called to instantiate multiple decompressors,
>     without the compressor options needing to be read and parsed each
>     time.
>
> 2.  It moves threading and all sleeping operations out of the
>     decompressors.  In doing so, it makes the decompressors
>     non-blocking wrappers which only deal with interfacing with
>     the decompressor implementation.
>
> 3. It splits decompressor.[ch] into decompressor generic functions
>    in decompressor.[ch], and moves the single threaded
>    decompressor implementation into decompressor_single.c.
>
> The result of this patch is Squashfs should now be able to
> support multiple decompressors by adding new decompressor_xxx.c
> files with specialised implementations of the functions in
> decompressor_single.c
>
> This has the following functions
>
> decompressor_create()
>   - Called at mount time to initialise internal decompressor state.
>   - An opaque pointer to the decompressor private state is returned (or error).
>   - The function is called with a pointer to the parsed and swapped comp_opts
>     structure returned by the new decompressor comp_opts() call.
>
> decompressor_destroy()
>   - Destroy all decompressor private state
>   - kfree the comp_opts buffer
>
> decompress()
>   - Select a decompressor or create a new decompressor
>   - Call using whatever locking scheme is necessary
>
> All decompressor implementation specific private state has been moved from the
> squashfs_sb_info structure into the opaque private state returned by
> decompressor_create().   This is deliberate, now all implementation specific
> code has been moved to decompressor_xxx.c, no other code needs to/or should need
> to access anything within it.
>
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>

Reviewed-by: Minchan Kim <minchan@kernel.org>

It's a really fantastic clean up. I will implement
decompressor_multi.c after holiday.
Thanks for your help!

-- 
Kind regards,
Minchan Kim
