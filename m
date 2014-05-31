Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbaEaOsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:48:24 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38928 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaEaOsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:48:22 -0400
Date: Sat, 31 May 2014 07:48:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for
 22s! [systemd-udevd:1667]
In-Reply-To: <CA+5PVA5EmAkoZnWNUtXCPu5JZ=6Q4jFrjoqHZdtBVdbxwPe6Tw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405310745001.10717@i7.linux-foundation.org>
References: <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com> <20140529154454.GK18016@ZenIV.linux.org.uk> <20140529162307.GL18016@ZenIV.linux.org.uk> <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
 <20140529165351.GM18016@ZenIV.linux.org.uk> <20140529185201.GN18016@ZenIV.linux.org.uk> <20140530081238.GA1957@lahna.fi.intel.com> <20140530152151.GR18016@ZenIV.linux.org.uk> <CA+55aFxLNvBDYtiq92DvuVqUk7byWeYiL1svbNQdXg7MRtbBcQ@mail.gmail.com>
 <20140530164815.GS18016@ZenIV.linux.org.uk> <20140530171408.GT18016@ZenIV.linux.org.uk> <CA+5PVA5EmAkoZnWNUtXCPu5JZ=6Q4jFrjoqHZdtBVdbxwPe6Tw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 May 2014, Josh Boyer wrote:
> 
> One of my machines got the lockdep report below when booting a kernel
> that contained these patches. 

I think this is just a lacking annotation.

We do nest dentry d_lock locking, and in order to avoid ABBA deadlocks the 
rule is that we lock things in topological order (parent dentry first). 
lock_parent() is very careful about that, but doesn't actually tell 
lockdep about it.

This trivial oneliner should fix it.

			Linus

---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index bce851dc03ef..be2bea834bf4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -553,7 +553,7 @@ again:
 	}
 	rcu_read_unlock();
 	if (parent != dentry)
-		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	else
 		parent = NULL;
 	return parent;
