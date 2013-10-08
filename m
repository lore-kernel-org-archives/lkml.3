Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3JHCUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3JHCUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:20:10 -0400
Date: Mon, 7 Oct 2013 19:13:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, Alex Dubov <oakad@yahoo.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH V2] memstick: Fix memory leak in memstick_check() error
 path
Message-ID: <20131008021304.GB32733@kroah.com>
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 10:21:51PM -0500, Larry Finger wrote:
> With kernel 3.12-rc3, kmemleak reports the following leak:
> 
> > unreferenced object 0xffff8800ae85c190 (size 16):
> >   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
> >   hex dump (first 16 bytes):
> >     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
> >   backtrace:
> >     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
> >     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
> >     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
> >     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
> >     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
> >     [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
> >     [<ffffffff81069862>] process_one_work+0x1d2/0x670
> >     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
> >     [<ffffffff81072ea6>] kthread+0xd6/0xe0
> >     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0
> 
> This problem was introduced by commit 0252c3b "memstick: struct device -
> replace bus_id with dev_name(), dev_set_name()" where the name is not freed
> in the error path. The name is also leaked in memstick_free_card(). 
> 
> Thanks to Catalin Marinas for suggesting the fix.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> V2 fixes the typos in the commit message, and frees the name in
> memstick_free_card() as well as the error path in memstick_check().

Looking back at this, to try to figure out why the kmemleak report shows
up, shows that this is a mess.  Why would we be erroring out _before_ we
try to register the struct device with the driver core, yet we had
already initialized the struct device structure?  Only set up the
structure right before sending it to driver core, don't delay in
allocation, only problems can happen (like here.)

To fix this up, will take some major work, which I can't do, sorry, but
this patch will not work either.

greg k-h
