Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaB0VWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:22:14 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40241 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaB0VWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:22:13 -0500
Date: Thu, 27 Feb 2014 13:22:08 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Leon Pollak <leonp@plris.com>
Cc: Richard Weinberger <richard@nod.at>,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>,
        linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: What is wrong?
Message-ID: <20140227212208.GG13420@norris-Latitude-E6410>
References: <4315632.KkRm7kzq26@leonp.plris.com>
 <20140227011148.GI4194@ld-irv-0074>
 <1553411.O1igofskp7@leonp.plris.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553411.O1igofskp7@leonp.plris.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ others

Hi Leon,

Can you please keep the CC list intact? And please try to reply below
the quotes and trim context, rather than top-posting. Thanks!

On Thu, Feb 27, 2014 at 02:00:25PM +0200, Leon Pollak wrote:
> I am VERY(!) thankful to you for the answer.
> First, I am calm now that there is no any error on my side and the 
> system remains clean despite these messages.
> Second, yes, the workaround worked.

That's nice to hear, but that is (as you note) a workaround. You should
not need an extra sync after remounting read-only. Do you think you can
try the linked patch?

commit 807612db2f9940b9fa6deaef054eb16d51bd3e00
Author: Andrew Ruder <andrew.ruder@elecsyscorp.com>
Date:   Thu Jan 30 09:26:54 2014 -0600

    fs/super.c: sync ro remount after blocking writers

Perhaps Richard or Andrew can comment on whether this patch should help
you. But I think JFFS2 on NAND uses write-buffered support which can be
affected by this bug.

> May thanks to you for your help!!!

You're welcome.

I have a few other questions: are you using NOR or NAND (it looks like
maybe NAND)?

Leaving most context intact for others, below.

> On Wednesday 26 February 2014 17:11:48 you wrote:
> > On Wed, Feb 26, 2014 at 04:07:21PM +0200, Leon Pollak wrote:
> > > The NAND is write protected by HW and the partition is mounted as
> > > RO.
> > > At some moment I need to update a small file.
> > > So I do:
> > > - HW write protect off,
> > > - remount RW,
> > > - update file,
> > > - sync,
> > > - remount RO,
> > > - write protect on.
> > > 
> > > Looking at linux console I see a lot of messages like:
> > > Erase at 0x00400000 failed immediately: errno -5
> > > Erase at 0x003e0000 failed immediately: errno -5
> > > ......
> > > Erase at 0x00340000 failed immediately: errno -5
> > > jffs2_flush_wbuf(): Write failed with -5
> > > Write of 2016 bytes at 0x002578a0 failed. returned -5, retlen 0
> > > Not marking the space at 0x002578a0 as dirty because the flash
> > > driver
> > > returned retlen zero.
> > > 
> > > 
> > > This is repeated for a long time, but everything seems work OK.
> > > The sequential starts and even file updates are also OK, without
> > > error messages.
> > > 
> > > What do I do wrong? Thanks a lot.
> > 
> > It's possible you're seeing symptoms of this:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit
> > /?id=807612db2f9940b9fa6deaef054eb16d51bd3e00
> > 
> > It seems like maybe JFFS2 is still doing some GC and/or write flushing
> > after the remount.
> > 
> > Could try this?
> > 
> >  - HW write protect off,
> >  - remount RW,
> >  - update file,
> >  - sync,
> >  - remount RO,
> >  - sync, <---------- add this, to see if you're experiencing any
> >                      writeback after remount
> >  - write protect on.

Regards,
Brian
