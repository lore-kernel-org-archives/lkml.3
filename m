Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaJYTvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:51:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaJYTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:51:21 -0400
Date: Sat, 25 Oct 2014 09:18:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlay filesystem v25
Message-ID: <20141025081845.GJ7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:24:45AM +0200, Miklos Szeredi wrote:

> The reason I didn't do your "fix" is that it
> 
>  - adds more lines than it takes,
> 
>  - I wasn't sure at all if the lockless access is actually correct
> without the ACCESS_ONCE and all the memory barrier magic that might be
>  necessary on weird architectures.

_What_ lockless accesses?  There is an extremely embarrassing bug in that
commit, all right, but it has nothing to do with barriers...  All
barrier-related issues are taken care of by ovl_path_upper() (and without
that you'd have tons of worse problems).  Fetching ->upperfile outside of
->i_mutex is fine - in the worst case we'll fetch NULL, open the sucker
grab ->i_mutex and find out that it has already been taken care of.
In which case we fput() what we'd opened and move on (fput() under
->i_mutex is fine - it's going to be delayed until return from syscall
anyway).

There was a very dumb braino in there; fixed, force-pushed, passes unionmount
tests, no regressions on LTP syscall ones and xfstests.
