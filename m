Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaI0R5C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 13:57:02 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:60545 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaI0R47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 13:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140927044555.GS7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
	<20140924185521.GC7996@ZenIV.linux.org.uk>
	<CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
	<20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
Date: Sat, 27 Sep 2014 10:56:57 -0700
X-Google-Sender-Auth: pdE-ZI5qic1WLRZlzMe6BZEZ8R0
Message-ID: <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
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

On Fri, Sep 26, 2014 at 9:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Linus, it's a real userland regression.

That's not the part I'm arguing against. I think the patch itself was
too ugly to live.

Yes, we had that hack before, but we didn't make it conditional. It
historically was more of a "it's easier to just memcpy the name" than
switch things around. Then that became accidental semantics, and
that's all normal. But then when we make this explicit and
intentional, I really think we should do it *right*, and either
switch() the names around or just copy it.

Having a "switch_names()" function that *neither* switches *nor*
copies, and giving it an argument to decide which, but not even do it
*right*? That's just too f*cking disgusting for words.

So seriously, I think we should:

 - keep the "switch_names()" as is, since it actually does what the
name says it does, and some callers want to statically do exactly
that.

 - make a new "move_name(src,dst)" that explicitly moves names, and
explicitly knows that the source needs to be kept alive (although it
*could* also look at the source dentry refcount to decide whether it
needs to be careful or not). And do it right for the long names too,
not just the inline case.

 - make that __d_move() caller just pick one or the other explicitly.

See what my complaint is? Not this half-assery that used to be a small
random detail, and that the patch makes into an institutionalized and
explicit half-assery.

(And Mikhail - I'm not ragging on you, even if I'm ragging on the
patch. I understand why you did it the way you did, and it makes sense
exactly in the "let's reinstate old hackery" model. I just think we
can and should do better than that, now that the "exchange" vs "move
over" semantics are so explicit).

Al (or Mikhail) - willing to do that extra cleanup? Please?

              Linus
