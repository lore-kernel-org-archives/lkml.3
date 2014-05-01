Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaEAAS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:18:27 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:58595 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaEAASY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140430234341.GX18016@ZenIV.linux.org.uk>
References: <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
	<20140430190227.GR18016@ZenIV.linux.org.uk>
	<20140430195918.GS18016@ZenIV.linux.org.uk>
	<CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
	<20140430203823.GT18016@ZenIV.linux.org.uk>
	<CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
	<20140430211206.GU18016@ZenIV.linux.org.uk>
	<20140430221238.GV18016@ZenIV.linux.org.uk>
	<CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
	<CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
	<20140430234341.GX18016@ZenIV.linux.org.uk>
Date: Wed, 30 Apr 2014 17:18:23 -0700
X-Google-Sender-Auth: Nj-3NtPO6LCp0yAKRqDe7v-wpz0
Message-ID: <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 4:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, done and force-pushed.  Should propagate in a few...

That made it more obvious how the DCACHE_MAY_FREE case ends up
working. And in particular, mind rewriting this:

    if (dentry->d_flags & DCACHE_MAY_FREE) {
        spin_unlock(&dentry->d_lock);
        dentry_free(dentry);
    } else {
        spin_unlock(&dentry->d_lock);
    }
    return parent;

as just

    bool free = dentry->d_flags & DCACHE_MAY_FREE;
    spin_unlock(&dentry->d_lock);
    if (free)
        dentry_free(dentry);
    return parent;

instead? In fact, I get the feeling that the other case later on
really fits the same model:

    spin_lock(&dentry->d_lock);
    if (dentry->d_flags & DCACHE_SHRINK_LIST) {
        dentry->d_flags |= DCACHE_MAY_FREE;
        spin_unlock(&dentry->d_lock);
    } else {
        spin_unlock(&dentry->d_lock);
        dentry_free(dentry);
  }

ends up really being better as

    spin_lock(&dentry->d_lock);
    free = 1;
    if (dentry->d_flags & DCACHE_SHRINK_LIST) {
        dentry->d_flags |= DCACHE_MAY_FREE;
        free = 0;
    }
    spin_unlock(&dentry->d_lock);
    if (free)
        dentry_free(dentry);
    return parent;

and then suddenly it looks like we have a common exit sequence from
that dentry_kill() function, no?

(The earlier "unlock_on_failure" exit case is altogether a different case).

I dunno. Maybe not a big deal, but one reason I prefer doing that
"free" flag is because I really tend to prefer the simple case of
lock-unlock pairing cleanly at the same level. NOT the pattern where
you have one lock at one indentation level, paired with multiple
unlocks for all the different cases.

                  Linus
