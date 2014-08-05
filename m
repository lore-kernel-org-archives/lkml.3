Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaHEEHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:07:34 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:56425 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHEEHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:07:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140805131758.3afa6b0b@notabene.brown>
References: <20140805131758.3afa6b0b@notabene.brown>
Date: Mon, 4 Aug 2014 21:07:32 -0700
X-Google-Sender-Auth: eH0aBeuQz2l5F7Wu1q_Q8Ho0A68
Message-ID: <CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
Subject: Re: Is lockref_get_not_zero() really correct in dget_parent()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 8:17 PM, NeilBrown <neilb@suse.de> wrote:
>
>  I've been looking at last year's change to dentry refcounting which sets the
>  refcount to -128 (mark_dead()) when the dentry is gone.
>
>  As this is an "unsigned long" and there are several places where
>  d_lockref.count is compared e.g. "> 1", I start feeling uncomfortable, as
>  "-128" is greater than "1".

Anybody who checks the lockref count without holding the lock is
pretty much buggy by definition. And if you hold the lock, you had
better not ever see a negative (== large positive) number, because
that would be all kinds of buggy too.

So I don't *think* that people who compare with "> 1" kind of things
should be problematic. I wouldn't necessarily disagree with the notion
of making a lockref be a signed entity, though. It started out
unsigned, but it started out without that dead state too, so that
unsigned thing can be considered a historical artifact rather than any
real design decision.

Anyway, I think my argument is that anybody who actually looks at
d_count() and might see that magic dead value is so fundamentally
broken in other ways that I wouldn't worry too much about *that* part.

But your "lockref_get_not_zero()" thing is a different thing:

>  That brings me to dget_parent().  It only has rcu_read_lock() protection, and
>  yet uses lockref_get_not_zero().  This doesn't seem safe.

Yes, agreed, it's ugly and wrong, and smells bad.

But I think it happens to be safe (because the re-checking of d_parent
will fail if a rename and dput could have triggered it, and even the
extraneous "dput()" is actually safe, because it won't cause the value
to become zero, so nothing bad happens. But it *is* kind of subtle,
and I do agree that it's *needlessly* so.

So it might be a good idea to get rid of the "not zero" version
entirely, and make the check be about being *active* (ie not zero, and
not dead).

The only user of lockref_get_not_zero() is that dget_parent() thing,
so that should be easy.

So renaming it to "lockref_get_active()", and changing the "not zero"
test to check for "positive" and change the rtype of "count" to be
signed, all sound like good things to me.

But I don't actually think it's an active bug, it's just an "active
horribly ugly and subtly working code". I guess in theory if you can
get lots of CPU's triggering the race at the same time, the magic
negative number could become zero and positive, but at that point I
don't think we're really talking reality any more.

Can somebody pick holes in that? Does somebody want to send in the
cleanup patch?

          Linus
