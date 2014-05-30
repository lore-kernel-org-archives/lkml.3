Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaE3PV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:21:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34193 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaE3PV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:21:56 -0400
Date: Fri, 30 May 2014 16:21:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140530152151.GR18016@ZenIV.linux.org.uk>
References: <20140529105107.GB1938@lahna.fi.intel.com>
 <20140529110439.GA2006@lahna.fi.intel.com>
 <20140529133036.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
 <20140529162307.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
 <20140529165351.GM18016@ZenIV.linux.org.uk>
 <20140529185201.GN18016@ZenIV.linux.org.uk>
 <20140530081238.GA1957@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530081238.GA1957@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:12:38AM +0300, Mika Westerberg wrote:

> Tested your latest #for-linus from here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-linus
> 
> and the livelock is gone,
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Thanks again!

OK...  I've just pushed another branch (#for-linus-2) with lock_parent()
change folded into the commit that used to introduce rename_lock-based
variant.  Heads of the branches are byte-for-byte identical:

al@duke:~/linux/trees/vfs$ git log vfs/for-linus|head -1
commit ebc6cb92bfeddf25462842f64604bc9fd2aab5b0
al@duke:~/linux/trees/vfs$ git log vfs/for-linus-2|head -1
commit 8cbf74da435d1bd13dbb790f94c7ff67b2fb6af4
al@duke:~/linux/trees/vfs$ git diff ebc6cb92bfeddf25462842f64604bc9fd2aab5b0 8cbf74da435d1bd13dbb790f94c7ff67b2fb6af4
al@duke:~/linux/trees/vfs$

so testing done on one of them obviously applies to another.  FWIW, on
#for-linus-2 we have
Shortlog:
Al Viro (6):
      lift the "already marked killed" case into shrink_dentry_list()
      split dentry_kill()
      expand dentry_kill(dentry, 0) in shrink_dentry_list()
      shrink_dentry_list(): take parent's ->d_lock earlier
      dealing with the rest of shrink_dentry_list() livelock
      dentry_kill() doesn't need the second argument now

Diffstat:
 fs/dcache.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 107 insertions(+), 46 deletions(-)

Linus, how would you prefer it to be handled?
