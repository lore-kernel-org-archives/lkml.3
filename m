Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3HWBHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:07:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36030 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3HWBHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:07:37 -0400
Date: Fri, 23 Aug 2013 02:07:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130823010726.GP27005@ZenIV.linux.org.uk>
References: <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
 <20130822185317.GI31117@1wt.eu>
 <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
 <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu>
 <CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
 <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
 <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
 <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 01:54:15PM -0700, Linus Torvalds wrote:
> On Thu, Aug 22, 2013 at 1:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Sure.  But aren't they always last?
> 
> What do you mean? I'd say that the /proc lookup is always *innermost*.
> Which means that it certainly cannot bail out, since there are many
> levels of nesting outside of it.
> 
> > With the current code structure, trying to enforce some kind of
> > security restriction in the middle of lookup seems really unpleasant.
> 
> If it's conditional (ie "linkat behaves differently from openat"), it
> certainly means that we'd have to pass in that info in annoying ways.

Nope.  All we need to pass is one more LOOKUP_...  Add
	if (unlikely(nd->last_type == LAST_BIND)) {
		if ((nd->flags & LOOKUP_BLAH) && !may_flink(...)) {
			terminate_walk(nd);
			return -EINVAL;
		}
	}
in the beginning of lookup_last() and pass LOOKUP_BLAH in flags when
linkat() calls user_path_at().  That will affect *only* the terminal
symlinks and cost nothing in all normal cases.  The same check can
bloody well go into path_init() - take
                if (*name) {
                        if (!can_lookup(dentry->d_inode)) {
                                fdput(f);
                                return -ENOTDIR;
                        }
                }
in there and slap
		else {
			if ((flags & LOOKUP_BLAH) && !may_flink(...)) {
                                fdput(f);
				return -EINVAL;
			}
		}
after it.
