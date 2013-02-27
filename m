Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3B0Pel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:34:41 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50263 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3B0Pej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:34:39 -0500
Date: Wed, 27 Feb 2013 10:34:35 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 updates for 3.9
Message-ID: <20130227153435.GB5609@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
 <20130227124727.GA225@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227124727.GA225@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 01:47:27PM +0100, Markus Trippelsdorf wrote:
> Just booted todays Linux tree and got the following errors:
> 
> ...
> Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
> ...
> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2569822761, rec_len=3837, name_len=1
> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70911401: block 15213579: comm pdnsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2000846358, rec_len=36782, name_len=120

Is this reproducible?  This looks like the in-memory copy of the
directory got corrupted.  This could be caused by a hardware error, or
a wild pointer, or a bug in the buffer cache code, etc.  Since there
are so many different possible causes of this kind of complaint, we
really need some kind of reproducible test case to do anything with this.

I did do a test compile of the ext4 tree with the latest linus.git
tree merged in, and ran a full set of repgression tests before I sent
my pull request.  Now, the regression tests take over 14 hours to run,
and there is a delay between when a maintainer sends the pull request
to when Linus acts on it --- so Linus almost certainly pulled in some
other trees betewen when I did my final regression testing and when I
sent the pull request and he pulled it into my tree.

I'll see if I can reproduce this on my end, on Linus's tree after the
ext4 tree was merged in, but at least in the past, this is the sort of
thing that is almost certainly caused by a hardware failure or bug
somewhere in the device driver, mm, or buffer cache, given that the
directory looks completely insane and a subsequent e2fsck -f didn't
discover any problem.

Is there anything special about your system?  How much memory do you
have?  What kind of device is /dev/sda?  What sort of workload did you
have running on your system before the failure?

Also, can you send us the output of "debugfs -R "stat <70647809>"
/dev/sda" so I can confirm that block 14164000 really is assigned to
inode 70647809?  The one potential cause of this error I can think of
that might be related to recent changes in ext4 is if the extent
status tree had the wrong logical-to-physical mapping cached for the
directory inode.

Regards,

						- Ted
