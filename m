Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaA1PYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:24:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbaA1PYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:24:20 -0500
Date: Tue, 28 Jan 2014 10:24:08 -0500
From: Dave Jones <davej@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140128152408.GA16534@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
	Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz>
 <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
 <20140123235549.GA7363@quack.suse.cz>
 <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
 <20140127234017.GA7868@quack.suse.cz>
 <20140128061037.GA27636@redhat.com>
 <20140128080201.GA13676@quack.suse.cz>
 <alpine.LNX.2.00.1401281207140.3763@pobox.suse.cz>
 <20140128145327.GC13676@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128145327.GC13676@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 03:53:27PM +0100, Jan Kara wrote:
 > On Tue 28-01-14 12:07:51, Jiri Kosina wrote:
 > > On Tue, 28 Jan 2014, Jan Kara wrote:
 > > 
 > > > >   2b:*	4d 8b 64 c6 08       	mov    0x8(%r14,%rax,8),%r12     <-- trapping instruction
 > > > > 
 > > > > R14 is 0x6b6b6b6b6b6b6c03, which looks like a use-after-free.
 > > >   Yup. But I'm somewhat puzzled by the trace. We crash when calling
 > > > fsnotify_destroy_event() from fanotify_handle_event(). The fsnotify code
 > > > has been called from do_sys_open() so the event was a 'FS_OPEN' which fails
 > > > the fsn_event->mask & FAN_ALL_PERM_EVENTS test.
 > > > 
 > > > Slapping my forehead, that's a really stupid bug. The event
 > > > fsnotify_add_notify_event() returns may be freed by the time we return
 > > > because we already dropped the notification mutex. And then fsn_event->mask
 > > > & FAN_ALL_PERM_EVENTS test will pass because FAN_ALL_PERM_EVENTS matches
 > > > with the poison pattern 0x6b6b6b6b. So yet another hacked up version of
 > > > fanotify fix is attached. And I have to seriously think about use counts
 > > > for fanotify version of that struct.
 > > 
 > > With the fixed version of the patch, all the fanotify-related oopses are 
 > > gone on my system.
 >   Thanks for testing. So now I have to come up with something mergeable :)

Yep, looks good to me too.  Thanks.

	Dave
 
