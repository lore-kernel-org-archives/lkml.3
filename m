Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3KSAiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:38:07 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:36160 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KSAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:38:04 -0500
MIME-Version: 1.0
In-Reply-To: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
Date: Mon, 18 Nov 2013 16:38:03 -0800
X-Google-Sender-Auth: mqpWr4P2z2A5UwvfUAGU7EQ1-nI
Message-ID: <CA+55aFyE=EDqMt1E94FSOFNEVWMS+mNVsJZYwiRmWfyB5HkykA@mail.gmail.com>
Subject: Re: [PATCH] FS: Fixed buffer overflow issue in seq_read()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.. Al - this looks like a major oversight, but it also looks like
the wrong place to initialize count/from in, just because it doesn't
follow any sane patterns.

My gut feel is that this needs more cleanup and some sane helper
function that always initializes those fields when allocating a new
buffer. Rather than the "initialize in random places and then miss a
few".

Afaik, those fields currently get (re-)initialized when:

 - We do the memset() of the whole seq_file structure at seq_open() time.

 - at the top of traverse()

 - count (but not from) gets reinitialized when growing the buffer or
after traverse() fails in seq_read()

and it really doesn't give me that happy fuzzy feeling of "that all
makes sense". Charley's patch seems to fix a missing initialization,
but I'd *really* like to have it all make more sense, and feel that
we're not missing some *other* initialization.

Al?

                Linus

On Mon, Nov 18, 2013 at 4:18 PM, Charley (Hao Chuan) Chu
<charley.chu@broadcom.com> wrote:
> The buffer count is not initialized when a new buffer is allocated.
>
> It cause kernel crash with "Unable to handle kernel paging
> request..." error in __copy_to_user_std(). It happens when a
> memory allocation failure in the while(1)-loop, which left the
> buffer count (m->count) is larger than buffer size
> (m->size).
>
> This patch is currently against a linux 3.12 kernel
>
> Signed-off-by: Charley Chu charley.chu@broadcom.com
> ---
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 1cd2388..480a341 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -191,6 +191,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
>
>         /* grab buffer if we didn't have one */
>         if (!m->buf) {
> +               m->count = m->from = 0;
>                 m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
>                 if (!m->buf)
>                         goto Enomem;
>
>
>
