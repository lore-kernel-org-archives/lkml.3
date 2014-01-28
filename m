Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaA1GKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:10:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaA1GKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:10:54 -0500
Date: Tue, 28 Jan 2014 01:10:37 -0500
From: Dave Jones <davej@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140128061037.GA27636@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
	Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140122062730.GA25601@redhat.com>
 <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
 <20140122233622.GB27916@quack.suse.cz>
 <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz>
 <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz>
 <20140123235549.GA7363@quack.suse.cz>
 <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
 <20140127234017.GA7868@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127234017.GA7868@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:40:17AM +0100, Jan Kara wrote:
 > On Fri 24-01-14 08:26:45, Jiri Kosina wrote:
 > > On Fri, 24 Jan 2014, Jan Kara wrote:
 > > 
 > > >   Strange. I've installed systemd system (openSUSE 13.1) and it boots 
 > > > with the latest Linus' kernel just fine (and I have at least FANOTIFY 
 > > > and SLAB debugging set the same way as you). But it was only a KVM 
 > > > guest. I'll try tomorrow with a physical machine I guess.
 > > 
 > > FWIW the system I am reliably able to reproduce this on is opensuse 12.3 
 > > with this systemd version: 
 > > 
 > > Version     : 195
 > > Release     : 13.18.1
 >   Hum, still no luck with reproduction (either on physical machine or with
 > KVM). Anyway, I've looked at the code again and the previous patch had a
 > stupid bug (passing different pointer to fsnotify_destroy_event() than we
 > should have), plus also the merging function in fanotify was too
 > aggressive. Can you try the attached patch? It boots for me but that means
 > nothing since I cannot reproduce the issue... Thanks!

still not good I'm afraid. I still see corruption very early on in boot
and now it panics and locks up too.

Again, this happens so early that I can't grab it over usb-serial.
I stuck an mdelay(10000) in the slub corruption detector, and managed
to grab a photo of the first trace.

Trace:
? preempt_schedule
lock_acquire
? lockref_put_or_lock
_raw_spin_lock
? lockref_put_or_lock
dput
path_put
fanotify_free_event
fsnotify_destroy_event
fanotify_handle_event
? mntput
? path_openat
? handle_mm_fault
send_to_group
? fsnotify
fsnotify
do_sys_open
sys_open
RIP: lock_acquire

  2b:*	4d 8b 64 c6 08       	mov    0x8(%r14,%rax,8),%r12     <-- trapping instruction

R14 is 0x6b6b6b6b6b6b6c03, which looks like a use-after-free.

I also notice you mention SLAB above, but I've been using SLUB. I don't
know if the choice of allocator makes a difference in reproducability.

It's also worth noting that I have lockdep enabled, which may be perturbing things
to some degree.

	Dave

