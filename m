Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaHEMvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:51:19 -0400
Received: from imap.thunk.org ([74.207.234.97]:45198 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaHEMvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:51:18 -0400
Date: Tue, 5 Aug 2014 08:51:14 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: martin f krafft <madduck@madduck.net>
Subject: Re: EXT4-fs error, kernel BUG
Message-ID: <20140805125114.GG5263@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>,
	martin f krafft <madduck@madduck.net>
References: <20140805103436.GA7531@fishbowl.rw.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805103436.GA7531@fishbowl.rw.madduck.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 12:34:36PM +0200, martin f krafft wrote:
> Dear kernel people,
> 
> Yesterday, I encountered something weird on one of our NAS machines:
> 
>   Aug  4 20:09:40 julia kernel: [342873.007709] EXT4-fs error (device dm-6): ext4_ext_check_inode:481: inode #30414321: comm du: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 1, max 4(4), depth 0(0)
> 
> but a fsck -f of the filesystem revealed no problems.

One likely cause of this issue is that the hardware hiccuped on a
read, and returned garbage, which is what triggered the "EXT4-fs
error" message (which is really a report of a detect file system
inconsistency).  A common cause of this is the block address getting
corrupted, so that the hard drive read the correct data from the wrong
location.

The other likely cause is that you are using something like RAID1, and
the one of copies of the disk block really is corrupted, and the
kernel read the bad version of the block, but fsck managed to read the
good version of the block.

It's possible that this was caused by a memory corruption, but it
wouldn't have been high on my suspect list.  Still, if this is a new
machine, it might not be a bad idea to run memtest86+ for 24-48 hours.

> So I set up another filesystem and tried to copy over the data from
> /dev/dm-6, using tar.
> 
> Shortly afterwards, there a wall message like
> 
>   BUG: soft lockup - CPU#0 stuck for 23s! [kswapd0:28]

>From the stack traces, it looks like the system was thrashing trying
to free memory to make forward progess.  (i.e., due to high memory
pressure).  Exactly why this happened is not something I can determine
from the strack traces, sorry.  It could be that soft lockup happened,
you had more processes running, or that some of the processes (samba?
apache?) were using more memory, and this was a factor.  Why the OOM
killer didn't kill the processes I can't tell you.

> Is there anything in the following back traces that would help me
> identify the source of the problem with greater confidence?

Sorry, that's about how that can be divined from your kernel stack
traces.

It might be worth checking the system logs for any suspicious error
messages beyond just the EXT4-fs error message, but you may have done
that already.

Good luck,

						- Ted
