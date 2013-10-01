Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3JADgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:36:14 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:64271 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3JADgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:36:13 -0400
Message-ID: <1380598571.19002.6.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: spinlock contention of files->file_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 30 Sep 2013 20:36:11 -0700
In-Reply-To: <20131001032715.GW13318@ZenIV.linux.org.uk>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131001015344.GV13318@ZenIV.linux.org.uk>
	 <CA+55aFz3gJE_DpZufTDNoRZ=vgJS3OwMspR7ZSqzGY_rWMq4gQ@mail.gmail.com>
	 <20131001032715.GW13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 04:27 +0100, Al Viro wrote:
> On Mon, Sep 30, 2013 at 07:02:23PM -0700, Linus Torvalds wrote:
> 
> > Shouldn't a cmpxchg() in just the dup2 code solve that?
> > 
> > If the old value was NULL, you'd have to repeat and go back and see if
> > the open_fds[] bit had been cleared in the meantime (ie it's NULL not
> > because somebody else is busy installing it, but because somebody just
> > uninstalled it).
> 
> Yechh...  Under ->file_lock (in do_dup2()), hopefully?  Or you'll get
> all kinds of fun with close() thrown into the game, as well...
> 
> > But yeah, I do agree that that sounds nasty and a complication I
> > hadn't even thought about. dup2() does violate our normal "let's
> > pre-allocate the fd slot" rule. Ugh.
> 
> Hell knows...  Descriptor handling *is* pretty well isolated these
> days, so it just might be doable without disrupting the living hell
> out of anything else.  fs/file.c is pretty much it - everything else
> goes through it.

I have a patch mostly working here, and pretty short.

I'll do proper tests before posting it tomorrow.

 fs/fcntl.c              |    7 ++-----
 fs/file.c               |   17 +++++++++++++----
 fs/open.c               |   21 +++++++++++++++++----
 include/linux/fdtable.h |    1 +
 4 files changed, 33 insertions(+), 13 deletions(-)

Thanks !


