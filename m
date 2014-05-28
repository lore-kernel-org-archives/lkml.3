Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaE1QHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:07:08 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53069 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaE1QHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:07:03 -0400
Date: Wed, 28 May 2014 18:06:53 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/13] overlay filesystem v22
Message-ID: <20140528160653.GL17233@tucsk.piliscsaba.szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
 <25513.1401069402@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25513.1401069402@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:56:42AM +0900, J. R. Okajima wrote:

> 
> Here are some comments.

Thanks for the review.

> 
> - I have no objection about the 0:0 char-dev whiteout, but you don't
>   have to have the inode for each whiteout. The hardlink is better.
>   In this version, you have <workdir> now. How about creating a "base"
>   whiteout under workdir at the mount-time? Maybe it is possible by
>   user-space "mount.overlayfs" or kernel-space. When the whiteout meets
>   EMLINK, create a non-hardlink for that target synchronously and
>   re-create the "base" asynchronously.

The reason I don't do this is complexity.  If ever this becomes a problem, then
we could add hardlinked whiteouts in the future.

> 
> - Is <workdir>/work always visible to users? If a user accidentally
>   removes it or its children, then some operations will fail. And he
>   cannot recover it anymore. I know it cannot easily happen since its
>   mode is 0. But I am afraid it will be a source of troubles. For
>   example, find(1) or "ls -R /overlayfs" will almost always fail.

Perfect solution would be an invisible temp directory.  This needs filesystem
support, but perhaps not so difficult.  Again could be done later without
backward compatibility issues.

> 
> - If I remember correctly, the length of the dir mutex is held time has
>   been pointed out. This version has still a long mutex held time, a whole
>   copy-up operation includeing lookup, create, copy filedata, copy
>   xattr/attr, and then rename. How about unlock the dir before copying
>   filedata and re-lock and confirm after copying attr?

Possibly doable, but again this would add complexity and I'd rather leave it
until somebody complains.

> 
> - When two processes copy-up a similar dir hierarcy, for example
>   /dirA/dirB/fileC and /dirA/dirB/dirC/fileD, may a race condition
>   happen? Two processes begin copying-up dirA, first processA succeeds
>   it and second processB fails and returns EIO?

No, we check the state with the parent lock held and skip the copy up if sombody
else won the race.

> 
> - All copy-up operations will be serialized due to <workdir> lock.

Yes.  Trivially fixable by creating a separate dir for each temp file.

> 
> - In fstat(2) for a dir, is nlink set to 1 even it is removed?

Probably.  I think right fix is to check if dentry is hashed and set nlink to
zero otherwise.  Will look into it.

> 
> - In readdir, it lookup or getattr to determine whether the found char
>   dev entry is a whiteout or not. I know a char dev is not so many, so
>   this overhead won't be large. But if its name represented "I am a
>   whiteout", then the extra lookup or getattr would be unnecessary.

At the cost of namespace issues.  I wouldn't consider that a good trade.


Thanks,
Miklos
