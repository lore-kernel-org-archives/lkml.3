Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaFKLfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:35:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:31363 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKLfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:35:52 -0400
X-Nat-Received: from [202.181.97.72]:20945 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1402486544.28741
To: paulmck@linux.vnet.ibm.com, viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [pre 3.16-rc1] Oops at spin_trylock(&inode->i_lock)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201406102104.FAG04640.MVJFSQOHtOFOFL@I-love.SAKURA.ne.jp>
	<20140610143425.GL4581@linux.vnet.ibm.com>
In-Reply-To: <20140610143425.GL4581@linux.vnet.ibm.com>
Message-Id: <201406112035.ADB51545.QFVMLJOtFOHSOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 11 Jun 2014 20:35:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11062014 #8203652, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Jun 10, 2014 at 09:04:51PM +0900, Tetsuo Handa wrote:
> > Hello.
> > 
> > I noticed that commit 59a3d4c363 "Merge branch 'core-rcu-for-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next" causes
> > an oops when rebooting a system. Do you have any clue?
> 
> Can't say that I do.  However, the commits that might have made some
> difference in how RCU operates are the following.  I have my doubts
> (listed below) about their being the cause, but if the oops is reproducible,
> why not try reverting each and see what happens?  Or just bisect within
> the core-rcu-for-linus branches?

Thank you. This oops seems to be 100% reproducible. I tried

for i in 365187fbc04f 48a7639ce80c 595f3900f6b4 495aa969dbae a381d757d93f 5057f55e543b becb41bfe054 fa07a58f71ee a5d6d3a1b00a
do
  git reset --hard $i; yes | make -sj4; make -s modules_install install
  git reset --hard $i~1; yes | make -sj4; make -s modules_install install
done

on tip/tip.git but none of them built the oops kernel.

I also confirmed that the command line which triggers this oops is

  mount -n -o ro,remount sysfs /sys

in /etc/init.d/halt script in CentOS 6.5.
Manually executing the command line from login shell triggers this oops.

I don't know why but commit 59a3d4c363 revealed a refcount bug
in sysfs (or maybe in vfs)?

---------- quote from /etc/init.d/halt start ----------
# Remount read only anything that's left mounted.
# echo $"Remounting remaining filesystems readonly"
mount | awk '{ print $1,$3 }' | while read dev dir; do
    fstab-decode mount -n -o ro,remount $dev $dir
done
---------- quote from /etc/init.d/halt end ----------
