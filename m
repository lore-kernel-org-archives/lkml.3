Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbaDIRxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:53:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58007 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaDIRxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:53:30 -0400
Date: Wed, 9 Apr 2014 18:53:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15-rc1
Message-ID: <20140409175322.GZ18016@ZenIV.linux.org.uk>
References: <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <874n3n7czm.fsf_-_@xmission.com>
 <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
 <20140409023027.GX18016@ZenIV.linux.org.uk>
 <20140409023947.GY18016@ZenIV.linux.org.uk>
 <87sipmbe8x.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sipmbe8x.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:32:14AM -0700, Eric W. Biederman wrote:

> For resolving a deeply nested symlink that hits the limit of 8 nested
> symlinks, I find 4688 bytes left on the stack.  Which means we use
> roughly 3504 bytes of stack when stating a deeply nested symlink.
> 
> For umount I had a little trouble measuring as typically the work done
> by umount was not the largest stack consumer, but I found for a small
> ext4 filesystem after the umount operation was complete there were
> 5152 bytes left on the stack, or umount used roughly 3040 bytes.

A bit less - we have a non-empty stack footprint from sys_umount() itself.

> 3504 + 3040 = 6544 bytes of stack used or 1684 bytes of stack left
> unused.  Which certainly isn't a lot of margin but it is not overflowing
> the kernel stack either. 
> 
> Is there a case that see where umount uses a lot more kernel stack?  Is
> your concern an architecture other than x86_64 with different
> limitations?

For starters, put that ext4 on top of dm-raid or dm-multipath.  That alone
will very likely push you over the top.

Keep in mind, BTW, that you do not have full 8K to play with - there's
struct thread_info that should not be stepped upon.  Not particulary large
(IIRC, restart_block is the largest piece in amd64 one), but it eats about
100 bytes.

I'd probably use renameat(2) in testing - i.e. trigger the shite when
resolving a deeply nested symlink in renameat() arguments.  That brings
extra struct nameidata into the game, i.e. extra 152 bytes chewed off the
stack.
