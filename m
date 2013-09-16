Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3IPQHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:07:21 -0400
Received: from science.horizon.com ([71.41.210.146]:63493 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751524Ab3IPQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:07:19 -0400
Date: 16 Sep 2013 12:07:17 -0400
Message-ID: <20130916160717.1621.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        joe@perches.com, kosaki.motohiro@gmail.com, linux@horizon.com,
        penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk
In-Reply-To: <1379317437-28329-2-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All users of %n are calculating padding size when using seq_file, so
> instead use the new last_len member for discovering the length of the
> written strings.

Obviously, this comment needs to be updated, but once that is done,
Acked-by: George Spelvin <linux@horizon.com>.

I actually reviewed all the users and checked that things work
properly.  In the various VMA map and tcp state lists, the line
width (128 or the now-misnamed TMPSZ=150) is greatly in excess of
what's required, presumably to facilitate computing the iteration
index from the file position in pre-seqfile days.

If the line were to ever get longer than that, the semantics of
printf("%*s", -5, "") would give strange results, but that's
a pre-existing problem that is unlikely to occur, would probably
be harmless (as would deleting the trailing whitespace!), and
isn't made any worse by this.


HOWEVER, it gave me an idea.  We could put this padding logic straight
into vsprintf and clean up all the callers.

I'm currently thinking that a precision specifier in %c (%.*c) is
currently meaningless and ignored.  What if we usurped it and defined
it to mean "pad with this character until the total width so far this
rint reaches the specified precision"?

That would DTRT for all the callers.

Oh, bugger, gcc -Wformat warns about doing that.  And %#127c.  And
everything else I can think of.  The only way to sneak it past gcc
would be to usurp the rarely-used %-127c format.

Since the only pad character currently used is space, we could omit the
argument and use something like %127%, but gcc gets even more confused
by that.

The code is easy enough.  But any suggestions for ways to represent it
in the format string would be appreciated.
