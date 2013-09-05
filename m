Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3IEUmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:42:17 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48347 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3IEUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <5228E992.5050901@hp.com>
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
	<1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
	<5228E992.5050901@hp.com>
Date: Thu, 5 Sep 2013 13:42:12 -0700
X-Google-Sender-Auth: 6QA7_vSs3LLBDkJda0Pwrme0Oko
Message-ID: <CA+55aFzx4YHY3e5AH0U5AkAQSc8pZyC35jBP4t2jpbi8NHM18g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
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

On Thu, Sep 5, 2013 at 1:29 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> It is not as simple as doing a strncpy().

Yes it damn well is.

Stop the f*cking stupid arguments, and instead listen to what I say.

Here. Let me bold-face the most important part for you, so that you
don't miss it in all the other crap:

   MAKE prepend() JUST USE "strncpy()" INSTEAD OF "memcpy()".

Nothing else. Seriously. Your "you can't do it because we copy
backwards" arguments are pure and utter garbage, exactly BECAUSE YOU
DON'T CHANGE ANY OF THAT. You can actually use the unreliable length
variable BUT YOU MUST STILL STOP AT A ZERO.

Get it?

You're complicating the whole thing for no good reason. I'm telling
you (and HAVE BEEN telling you multiple times) that you cannot use
"memcpy()" because the length may not be reliable, so you need to
check for zero in the middle and stop early. All your arguments have
been totally pointless, because you don't seem to see that simple and
fundamental issue. You don't change ANYTHING else. But you damn well
not do a "memcpy", you do something that stops when it hits a NUL
character.

We call that function "strncpy()". I'd actually prefer to write it out
by hand (because somebody could implement "strncpy()" as a
questionable function that accesses past the NUL as long as it's
within the 'n'), and because I think we might want to do that
word-at-a-time version of it, but for a first approximation, just do
that one-liner version.

Don't do anything else. Don't do locking. Don't do memchr. Just make
sure that you stop at a NUL character, and don't trust the length,
because the length may not match the pointer. That's was always ALL
you needed to do.

              Linus
