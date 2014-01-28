Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaA1Oxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:53:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbaA1Ox3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:53:29 -0500
Date: Tue, 28 Jan 2014 15:53:27 +0100
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140128145327.GC13676@quack.suse.cz>
References: <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz>
 <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
 <20140123235549.GA7363@quack.suse.cz>
 <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
 <20140127234017.GA7868@quack.suse.cz>
 <20140128061037.GA27636@redhat.com>
 <20140128080201.GA13676@quack.suse.cz>
 <alpine.LNX.2.00.1401281207140.3763@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401281207140.3763@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-01-14 12:07:51, Jiri Kosina wrote:
> On Tue, 28 Jan 2014, Jan Kara wrote:
> 
> > >   2b:*	4d 8b 64 c6 08       	mov    0x8(%r14,%rax,8),%r12     <-- trapping instruction
> > > 
> > > R14 is 0x6b6b6b6b6b6b6c03, which looks like a use-after-free.
> >   Yup. But I'm somewhat puzzled by the trace. We crash when calling
> > fsnotify_destroy_event() from fanotify_handle_event(). The fsnotify code
> > has been called from do_sys_open() so the event was a 'FS_OPEN' which fails
> > the fsn_event->mask & FAN_ALL_PERM_EVENTS test.
> > 
> > Slapping my forehead, that's a really stupid bug. The event
> > fsnotify_add_notify_event() returns may be freed by the time we return
> > because we already dropped the notification mutex. And then fsn_event->mask
> > & FAN_ALL_PERM_EVENTS test will pass because FAN_ALL_PERM_EVENTS matches
> > with the poison pattern 0x6b6b6b6b. So yet another hacked up version of
> > fanotify fix is attached. And I have to seriously think about use counts
> > for fanotify version of that struct.
> 
> With the fixed version of the patch, all the fanotify-related oopses are 
> gone on my system.
  Thanks for testing. So now I have to come up with something mergeable :)

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
