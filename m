Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3KNH6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 02:58:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3KNH6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 02:58:31 -0500
Date: Thu, 14 Nov 2013 08:58:27 +0100
From: Jan Kara <jack@suse.cz>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Clements <Paul.Clements@steeleye.com>,
        nbd-general@lists.sourceforge.net
Subject: Re: 3.12 BUG() on ext4, kernel crash on nbd-client when nbd server
 rebooting
Message-ID: <20131114075827.GA13554@quack.suse.cz>
References: <8bf7c5db475eefcf17976a36f892200d@visp.net.lb>
 <20131112214632.GB31763@quack.suse.cz>
 <7c1b2ca40c3abfe805e9e944f21c7016@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1b2ca40c3abfe805e9e944f21c7016@visp.net.lb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-11-13 05:59:11, Denys Fedoryshchenko wrote:
> Hi
> 
> On 2013-11-12 23:46, Jan Kara wrote:
> >Hello,
> >
> >On Tue 12-11-13 16:34:07, Denys Fedoryshchenko wrote:
> >>I just did some fault testing for test nbd setup, and found that if
> >>i reboot nbd server i will get immediately BUG() message on nbd
> >>client and filesystem that i cannot unmount, and any operations on
> >>it will freeze and lock processes trying to access it.
> >  So how exactly did you do the fault testing? Because it seems
> >something
> >has discarded the block device under filesystem's toes and the
> >superblock
> >buffer_head got unmapped. Didn't something call NBD_CLEAR_SOCK ioctl?
> >Because that calls kill_bdev() which would do exactly that...
> 
> Client side:
> modprobe nbd
> nbd-client 2.2.2.29 /dev/nbd0 -name export1
> nbd-client 2.2.2.29 /dev/nbd1 -name export2
> nbd-client 2.2.2.29 /dev/nbd2 -name export3
> mount /dev/nbd0 /mnt/disk1
> mount /dev/nbd1 /mnt/disk2
> mount /dev/nbd2 /mnt/disk3
> 
> On server i have config:
> [generic]
> [export1]
>         exportname = /dev/sda1
> [export2]
>         exportname = /dev/sdb1
> [export3]
>         exportname = /dev/sdc1
> 
> Steps to reproduce:
> 1)Start some large file copy on client side to /mnt/disk1/
> 2)Reboot server. It reboots quite fast, just few seconds, server
> system will get ip before nbd-server process started listening, so
> probably nbd-client will see connection refused.
> 3)seems when client gets connection refused - it is going mad
> 
> I can try to capture traffic dump, or do any other debug operation,
> please let me know, what i should run :)
> P.S. I noticed maybe i should run persist mode, but anyway it should
> not crash like this i think.
  OK, no need for further debugging. I see what's going on. In NBD_DO_IT
ioctl() nbd calls kill_bdev() after the kthread returned - and that happens
in your case as we can see from "queue cleared" messages.

Now there is a question how to fix this. Filesystems don't really expect
device buffers to disappear under us as they do when nbd calls kill_bdev().
Also that never happens with normal block devices - if a similar situation
happens to SCSI / SATA disk, corresponding block devices hang around
refusing any IO until the filesystem is unmounted and at that point they
disappear (device's refcount - bd_openers - reaches zero). It would be good
if NBD behaved the same way - maybe we should return from NBD_DO_IT ioctl
only after bd_openers drops to 1 (not zero because the nbd client has the
device open as well for the ioctl if I'm right)?

								Honza
---
Jan Kara <jack@suse.cz>
SUSE Labs, CR
