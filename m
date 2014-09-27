Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaI0Tta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:49:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaI0Tt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:49:28 -0400
Date: Sat, 27 Sep 2014 20:49:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140927194925.GW7996@ZenIV.linux.org.uk>
References: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <CA+55aFyBUKXE87Vou13ni2+=Mbb1Y1n55DXp9gs_0r3e7uLtbQ@mail.gmail.com>
 <CA+55aFwGo8c6iHmb20CfkpBq12Gm+VKBpbZrd=NbSx5R4Cf3fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwGo8c6iHmb20CfkpBq12Gm+VKBpbZrd=NbSx5R4Cf3fQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 12:39:02PM -0700, Linus Torvalds wrote:
> On Sat, Sep 27, 2014 at 12:37 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But yeah, I guess we can/should do the trivial ugly thing for 3.17.
> > Send me a proper pull-request,
> 
> .. and if it can happen before tomorrow, that would be good. I had to
> give up on my wish to release 3.17 tomorrow due to the current size of
> changes anyway, so there will be a rc7 (and my travel inconveniences
> be damned), but I'd like this to be in that rc7. Works for you?

Fine by me.  How about that s-o-b?  Right now it's

commit 4f78a56cd96a3d421852b5a03e10355b0cbe764b
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Sep 24 12:27:39 2014 -0700

    fold swapping ->d_name.hash into switch_names()
    
    and do it along with ->d_name.len there
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/dcache.c b/fs/dcache.c
index 92f7d76..7599d35 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2412,7 +2412,7 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
                        }
                }
        }
-       swap(dentry->d_name.len, target->d_name.len);
+       swap(dentry->d_name.hash_len, target->d_name.hash_len);
 }
 
 static void dentry_lock_for_move(struct dentry *dentry, struct dentry *target)
@@ -2510,7 +2510,6 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 
        /* Switch the names.. */
        switch_names(dentry, target);
-       swap(dentry->d_name.hash, target->d_name.hash);
 
        /* ... and switch them in the tree */
        if (IS_ROOT(dentry)) {


