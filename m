Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3H0As4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 20:48:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47252 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3H0Asz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 20:48:55 -0400
Date: Tue, 27 Aug 2013 01:48:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the race between the fget() and close()
Message-ID: <20130827004852.GH27005@ZenIV.linux.org.uk>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827004247.GG27005@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 01:42:47AM +0100, Al Viro wrote:
> Might be buggered refcounting on struct file somewhere (i.e. extra fput() done,
> getting the file freed *before* close(), leaving a dangling pointer in
> descriptor table).  Might be memory corruption of some kind, slapping junk
> pointer into descriptor table.  Might be buggered refcounting on struct
> dentry - if extra dput() is done somewhere, dentry might get freed under
> us or become negative.
> 
> Hell, might be buggered refcounting on descriptor table - binder is playing
> interesting games there.  Try to reproduce that with CONFIG_DEBUG_KMEMLEAK
> and slab debugging turned on, see if you hit anything from those; if it's
> more or less readily reproducible, I would start with that - too many
> scenarios involve broken refcounting of one sort or another.

Nevermind dentry refcounting - you get NULL dentry, not NULL inode.
Other scenarios still remain, so I'd really recommend slab/kmemleak
debugging turned on.
