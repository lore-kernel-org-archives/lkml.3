Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3JVVQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:16:06 -0400
Received: from peace.netnation.com ([204.174.223.2]:42355 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3JVVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:16:05 -0400
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2013 17:16:05 EDT
Date: Tue, 22 Oct 2013 13:56:08 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Vaughan Cao <vaughan.cao@oracle.com>
Subject: [3.12-rc] sg_open: leaving the kernel with locks still held!
Message-ID: <20131022205608.GA6616@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

While trying to figure out why the request queue to sda (ext4) was
clogging up on one of our btrfs backup boxes, I noticed a megarc process
in D state, so enabled locking debugging, and got this (on 3.12-rc6):

[  205.372823] ================================================
[  205.372901] [ BUG: lock held when returning to user space! ]
[  205.372979] 3.12.0-rc6-hw-debug-pagealloc+ #67 Not tainted
[  205.373055] ------------------------------------------------
[  205.373132] megarc.bin/5283 is leaving the kernel with locks still held!
[  205.373212] 1 lock held by megarc.bin/5283:
[  205.373285]  #0:  (&sdp->o_sem){.+.+..}, at: [<ffffffff8161e650>] sg_open+0x3a0/0x4d0

Vaughan, it seems you touched this area last in 15b06f9a02406e, and git
tag --contains says this went in for 3.12-rc. We didn't see this on 3.11,
though I haven't tried with lockdep.

This is caused by some of our internal RAID monitoring scripts that run
"megarc.bin -dispCfg -a0" (even though that controller isn't present on
this server -- a PowerEdge 2950 w/Perc 5).

strace output of the program execution that causes the above message is
here: http://0x.ca/sim/ref/3.12-rc6/megarc_strace.txt

Simon-
