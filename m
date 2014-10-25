Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaJYTvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:51:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJYTvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:51:19 -0400
Date: Sat, 25 Oct 2014 18:06:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlay filesystem v25
Message-ID: <20141025170609.GK7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 11:53:52AM +0200, Miklos Szeredi wrote:

> Yes, but it's not about race with copy-up (which the ovl_path_upper()
> protects against), but race of two fsync calls with each other.  If
> there's no synchronization between them, then that od->upperfile does
> indeed count as lockless access, no matter that the assignment was
> done under lock.

	p = global;
	if (!p) {	// outside of lock
		p = alloc();
		grab lock
		if (!global) {
			global = p;
		} else {
			destroy(p);
			p = global;
		}
		drop lock
	}
is a very common pattern, especially if you look for cases when lock is
a spinlock and allocation is blocking (in those cases you'll often see
destroy() part done after dropping the lock; that's where what I fucked up in
what I'd originally pushed.  And it wasn't even needed - fput() under
->i_mutex is OK...)
