Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaIXT1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:27:44 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:63564 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaIXT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:27:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
	<20140924185521.GC7996@ZenIV.linux.org.uk>
	<CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
Date: Wed, 24 Sep 2014 12:27:39 -0700
X-Google-Sender-Auth: 078BetA2Zv75YeX2cFzcKdAEnqg
Message-ID: <CA+55aFxhTu=PacQi4fB3qLBc29VXM7fAVS32+7K4M_CQsAzHTA@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There's no way that patch is correct.

Something like the appended might be a good idea regardless. And might
have made people notice that the len and the hash go together with the
name.

             Linus

----

    diff --git a/fs/dcache.c b/fs/dcache.c
    index 7a5b51440afa..aa1b045b997c 100644
    --- a/fs/dcache.c
    +++ b/fs/dcache.c
    @@ -2412,7 +2412,7 @@ static void switch_names(struct dentry
*dentry, struct dentry *target)
                            }
                    }
            }
    -       swap(dentry->d_name.len, target->d_name.len);
    +       swap(dentry->d_name.hash_len, target->d_name.hash_len);
     }

     static void dentry_lock_for_move(struct dentry *dentry, struct
dentry *target)
    @@ -2511,7 +2511,6 @@ static void __d_move(struct dentry *dentry,
struct dentry *target,

            /* Switch the names.. */
            switch_names(dentry, target);
    -       swap(dentry->d_name.hash, target->d_name.hash);

            /* ... and switch the parents */
            if (IS_ROOT(dentry)) {
    @@ -2650,7 +2649,6 @@ static void __d_materialise_dentry(struct
dentry *dentry, struct dentry *anon)
            dparent = dentry->d_parent;

            switch_names(dentry, anon);
    -       swap(dentry->d_name.hash, anon->d_name.hash);

            dentry->d_parent = dentry;
            list_del_init(&dentry->d_u.d_child);
