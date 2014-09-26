Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaIZUqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:46:18 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40103 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaIZUqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140914194738.GS7996@ZenIV.linux.org.uk>
References: <20140914194738.GS7996@ZenIV.linux.org.uk>
Date: Fri, 26 Sep 2014 22:46:14 +0200
Message-ID: <CAGhQ9Vx26RQWErODdJ_fV5UnAQ8wLre_x-4E6N_vuP0uExyKgw@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Joachim Eastwood <manabian@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2014 21:47, Al Viro <viro@zeniv.linux.org.uk> wrote:
> double iput() on failure exit in lustre, racy removal of spliced dentries
> from ->s_anon in __d_materialise_dentry() plus a bunch of assorted RCU pathwalk
> fixes.  Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>
> Shortlog:
> Al Viro (5):
>       [fix] lustre: d_make_root() does iput() on dentry allocation failure
>       move the call of __d_drop(anon) into __d_materialise_unique(dentry, anon)
>       fix bogus read_seqretry() checks introduced in b37199e
>       don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
>       be careful with nd->inode in path_init() and follow_dotdot_rcu()

Hi,

Commit 4023bfc9f351a7994 "be careful with nd->inode in path_init() and
follow_dotdot_rcu(), seem to hang my ARM no-MMU platform when mounting
the ramdisk.

3.17-rc4 - works
3.17-rc5 - works with 4023bfc9f351a7994 reverted.

Boot log with from rc5:
[ 5.810000] TCP: cubic registered
[ 5.820000] NET: Registered protocol family 17
[ 5.860000] lpc2k-rtc 40046000.rtc: hctosys: unable to read the hardware clock
[ 5.910000] mmc_host mmc0: Bus speed (slot 0) = 12000000Hz (slot req
25000000Hz, actual 12000000HZ div = 0)
[ 5.930000] mmc0: new SDHC card at address 0007
[ 5.950000] mmcblk0: mmc0:0007 SD08G 7.42 GiB
[ 6.150000] clk: Not disabling unused clocks
[ 81.240000] random: nonblocking pool is initialized

And there it just hangs it seems.


With patch reverted
[ 5.810000] TCP: cubic registered
[ 5.820000] NET: Registered protocol family 17
[ 5.850000] lpc2k-rtc 40046000.rtc: hctosys: unable to read the hardware clock
[ 6.100000] clk: Not disabling unused clocks
[ 6.110000] RAMDISK: gzip image found at block 0
[ 9.590000] VFS: Mounted root (ext2 filesystem) readonly on device 1:0.
[ 9.600000] devtmpfs: mounted
[ 9.610000] Freeing unused kernel memory: 68K (281e5000 - 281f6000)

And then user space starts.

This is an ARM Cortex-M4 no-MMU platform that is not yet upstream.

regards,
Joachim Eastwood
