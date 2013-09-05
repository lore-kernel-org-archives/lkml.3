Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3IETfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:35:09 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40295 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3IETfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
	<1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
Date: Thu, 5 Sep 2013 12:35:06 -0700
X-Google-Sender-Auth: xH5HtlnTAbadWhkWgADQQkBIftQ
Message-ID: <CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 11:55 AM, Waiman Long <Waiman.Long@hp.com> wrote:
> +static int prepend_name(char **buffer, int *buflen, struct dentry *dentry)
>  {
> -       return prepend(buffer, buflen, name->name, name->len);
> +       /*
> +        * With RCU path tracing, it may race with rename. Use
> +        * ACCESS_ONCE() to make sure that it is either the old or
> +        * the new name pointer. The length does not really matter as
> +        * the sequence number check will eventually catch any ongoing
> +        * rename operation.
> +        */
> +       const char *dname = ACCESS_ONCE(dentry->d_name.name);
> +       u32 dlen = dentry->d_name.len;
> +       int error;
> +
> +       if (likely(dname == (const char *)dentry->d_iname)) {
> +               /*
> +                * Internal dname, the string memory is valid as long
> +                * as its length is not over the limit.
> +                */
> +               if (unlikely(dlen > sizeof(dentry->d_iname)))
> +                       return -EINVAL;
> +       } else if (!dname)
> +               return -EINVAL;
> +       else {
> +               const char *ptr;
> +               u32 len;
> +
> +               /*
> +                * External dname, need to fetch name pointer and length
> +                * again under d_lock to get a consistent set and avoid
> +                * racing with d_move() which will take d_lock before
> +                * acting on the dentries.
> +                */
> +               spin_lock(&dentry->d_lock);
> +               dname = dentry->d_name.name;
> +               dlen  = dentry->d_name.len;
> +               spin_unlock(&dentry->d_lock);
> +
> +               if (unlikely(!dname || !dlen))
> +                       return -EINVAL;
> +               /*
> +                * As the length and the content of the string may not be
> +                * valid, need to scan the string and return EINVAL if there
> +                * is embedded null byte within the length of the string.
> +                */
> +               for (ptr = dname, len = dlen; len; len--, ptr++) {
> +                       if (*ptr == '\0')
> +                               return -EINVAL;
> +               }
> +       }
> +       error = prepend(buffer, buflen, dname, dlen);

No. Stop all these stupid games.

No d_lock, no trying to make d_name/d_len consistent.

No "compare d_name against d_iname".

No EINVAL.

No idiotic racy "let's fetch each byte one-by one and test them
against NUL", which is just racy and stupid.

Just do what I told you to do: *copy* the name one byte at a time, and
stop copying if you hit NUL. IOW, make prepend() just use "strncpy()"
instead of "memcpy()". You don't even need to check the end result -
if it's bogus, the sequence count will fix it.

No special cases. No games. No crap. Just make "prepend()" able to
handle the special case of "oops, the name length didn't match, but we
must not ever go past the end of the buffer".

We can optimize strncpy() to use word accesses if it ends up ever
being a performance issue. I suspect it never even shows up, but it's
not hard to do if if does.

            Linus
