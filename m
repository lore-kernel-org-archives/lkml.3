Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3I2GGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:06:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3I2GGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:06:03 -0400
Date: Sun, 29 Sep 2013 07:06:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130929060601.GL13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 01:43:49PM -0700, Linus Torvalds wrote:

> Sounds reasonable to to me.

Sigh...  Looks like there's a lot of fun in shrink_dcache_for_umount() -
at the very least, it needs to bump ->d_seq on everything, because with
that change we *can* walk into a filesystem in the middle of that.
We obviously don't want to slap rcu_barrier() into the final mntput() -
it's far too costly; even one in deactivate_locked_super() (in the
wrong place and gone since a while back) had been causing problems.

Moreover, any filesystem that has e.g. ->d_hash() use an object hanging
off private data of superblock and freed by its ->kill_sb() before
generic_shutdown_super() will have an additional set of PITA; there
shouldn't be many of those, though.

Oh, well - this is going to be a fun series, by the look of it...
