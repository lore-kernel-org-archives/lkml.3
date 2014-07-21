Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaGUDHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 23:07:21 -0400
Received: from plane.gmane.org ([80.91.229.3]:49148 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaGUDHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 23:07:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [GIT PULL] Btrfs
Date: Mon, 21 Jul 2014 03:07:06 +0000 (UTC)
Message-ID: <pan$d33a5$fc604a73$666289c2$1a5e803f@cox.net>
References: <53CBD334.7010408@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-231-22-224.ph.ph.cox.net
User-Agent: Pan/0.140 (Chocolate Salty Balls; GIT d447f7c
 /m/p/portage/src/egit-src/pan2)
Cc: linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason posted on Sun, 20 Jul 2014 10:33:24 -0400 as excerpted:

> I was hoping to also include a fix for a btrfs deadlock with compression
> enabled, but we're still nailing that one down.

FWIW, I might be (rarely but twice, now) hitting that one myself, 
compress=lzo, but /not/ with the rsync that has been your current primary 
trigger.

The last time I hit it, it was trying to start firefox shortly after a 
fresh boot.  Firefox didn't come up, and when I tried starting it again, 
I got the dialog saying it was already running, quit the running instance 
and try again, or reboot.

But the running firefox instance was stuck unkillable in D state, with a 
zombie child.  Three of my six cores were stuck in 100% IO-wait.

I finished what I was doing and shut down X, but of course the D-state 
and zombie firefox reparented to systemd.  The time before when that 
happened with firefox, I ended up losing several of the firefox state 
files and it forgot my extensions, which I had to restore from backup.  
So this time I mounted a reiserfs I use for other things and did a backup 
of the entire ~/.mozilla/ subdir before finishing the shutdown and 
reboot.  That backup went fine (surprised me, I thought it might hang 
too), and I umounted the reiserfs.  But when I went to finish the 
shutdown of course the affected btrfs wouldn't umount due to the stuck 
firefox.  So I did the magic-SRQ REISUB thing, and saw the emergency sync 
and the remount-read-only complete.

After that I force-rebooted.  Luckily, this time I didn't need that 
backup of the ~/.mozilla subfolder I had made -- firefox came up fine 
after the reboot.  But I did lose the read state on a few messages in my 
feed (rss/atom) and news (nntp) readers, so I think btrfs did lose the 
log from after the last root-tree commit point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

