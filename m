Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaA2HRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:17:42 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbaA2HRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:17:39 -0500
Message-ID: <52E8AB0F.2090905@nod.at>
Date: Wed, 29 Jan 2014 08:17:35 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] reproducable ubifs reboot assert and corruption
References: <20140122051510.GB17284@gmail.com> <CAFLxGvwmzftdQKSjjjwpFLS8g3EJqMrQ2gU2scBsh2MvG7Wyyw@mail.gmail.com> <20140127163939.GA27809@gmail.com> <20140129053238.GA6035@gmail.com>
In-Reply-To: <20140129053238.GA6035@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.01.2014 06:32, schrieb Andrew Ruder:
> Ok, I've got some more useful information.  I have been adding
> a multitude of WARN_ON's and prink's all over the remount code and have
> come up with the attached log.
> 
> A little bit of explanation:
> 
> Line 1: sync_filesystem (from do_remount_sb)
> Line 188: sync_filesystem ends
> Line 43, 64, 81, 98, 114, 135, 156, 173: write operations that occur
> during sync_filesystem.  Before each warning I print the inode pointer.
> Line 197: read-only remount has completely finished (this message is
> from userspace post remount)
> Line 199: a sync is called, there are apparently dirty inodes in our
> now-readonly ubifs filesystem
> Line 215: failed assert that occurs because the writeback triggers for
> inode 0xd75b9450 (see line 41, it got in with a sys_write while we were
> running our sync_filesystem in do_remount_sb)
> 
> Does this help?  It looks like there is a race condition between the
> writeback code and the remount read-only.  Nothing is done to lock out
> writes during the first half of the do_remount_sb and some stuff makes
> it into the writeback worker queue while we are busy syncing the
> filesystem only to trigger later when ubifs has decided it is
> read-only...

So you can trigger this by running fsstress on /mnt and then call
mount -o remount,ro /mnt?

Can you also trigger it on nandsim or mtdram?

I did a quick test on my testbed using mtdram and was unable to trigger it.
But I fear my box is too fast.

Thanks,
//richard
