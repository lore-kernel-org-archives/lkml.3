Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3IEV12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:27:28 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49327 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3IEV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130905204609.GV13318@ZenIV.linux.org.uk>
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
	<1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
	<5228E992.5050901@hp.com>
	<20130905204609.GV13318@ZenIV.linux.org.uk>
Date: Thu, 5 Sep 2013 14:27:26 -0700
X-Google-Sender-Auth: 0QjzMjVYh2W_fz8rAkHhWpMDgjA
Message-ID: <CA+55aFy-R97tgE7JYq5feOTs9-ZFfX9qHjp0=uNbu3DdiMFFWA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 1:46 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> static int prepend_name(char **buffer, int *buflen, struct qstr *name)
> {
>         const char *s = ACCESS_ONCE(name->name);
>         unsigned len = ACCESS_ONCE(name->len);
>         char *p;
>
>         *buflen -= len;
>         if (*buflen < 0)
>                 return -ENAMETOOLONG;
>         p = *buffer -= len;
>         while (len--) {
>                 c = *s++;
>                 if (!c)
>                         break;
>                 *p++ = c;
>         }
>         return 0;
> }

.. and appended is a *totally* untested "dentry_string_copy()" that
does things a word at a time (it doesn't have your "buffer/buflen -=
len" parts, this is purely the copying code).

Note that the return value is only optimistic - it may be copying NUL
bytes *without* returning an error. We don't care. We really only care
that it not access past the end of the string using the same rules as
the RCU lookup does: it *can* access aligned words. It's just meant as
a "hey, if we had to go to the bother of checking for a NUL byte and
we found it, we might as well let the user know so that he could
choose to stop the optimistic RCU thing early".

Also note that this thing depends on CONFIG_DCACHE_WORD_ACCESS (which
in turn depends on little-endian), _and_ only works if the
architecture supports fast unaligned stores (which is true on x86, but
may not be true on ARM). And it does require that it can overshoot the
destination string - it won't *change* the destination string past the
end, but it will do an unaligned store there needs padding. And that
might be the biggest problem with this routine and the thing that
scuttles it. We could do that final store as a series of byte writes
instead, I guess. So maybe it should do

   do {
      *(char *)ct++ = a;
      a >>= 8;
   } while (--tcount);

at the end instead of doing the final word store.

I haven't actually tested it, but it looks right (within the above
constraints), and it generates asm that looks good enough. It is not
entirely obvious that it's really worth it over the "stupid"
character-at-a-time model, though: the loop counts are likely not
really all that high, and the unaligned store together with loading
the big constants to do the "test word for zero" might just add enough
overhead that it's not a big win. But the word-at-a-time approach was
a noticeable win for the rcu dentry lookup, so it's possible that it's
noticeable here too.

                   Linus

----
/*
 * The source comes from a dentry, which means that it is guaranteed to
 * be aligned. However, the destination is not likely to be aligned.
 *
 * The only rule is: we must *not* overstep the source by more than that
 * aligned word access if it has a NUL character in it.
 *
 * NOTE NOTE NOTE! This also requires that we can overshoot the destination
 * string by up to one unaligned word access!
 */
int dentry_string_copy(const unsigned char *_cs, unsigned char *_ct,
unsigned tcount)
{
        const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
        const unsigned long *cs = (const void *)_cs;
        unsigned long *ct = (void *)_ct;
        unsigned long a,mask;

        for (;;) {
                unsigned long adata;
                a = *cs;
                if (tcount < sizeof(unsigned long))
                        break;
                *ct = a;
                if (unlikely(has_zero(a, &adata, &constants)))
                        return -EINVAL;
                cs++; ct++;
                tcount -= sizeof(unsigned long);
                if (!tcount)
                        return 0;
        }
        /* We don't care if there's a NUL in the last word */
        mask = ~(~0ul << tcount*8);
        *ct = (a & mask) | (~mask & *ct);
        return 0;
}
