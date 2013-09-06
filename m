Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3IFBMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:12:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab3IFBMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:12:03 -0400
Date: Thu, 5 Sep 2013 21:11:37 -0400
From: Dave Jones <davej@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130906011137.GA25277@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Greg KH <gregkh@linuxfoundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130903205527.GA6358@kroah.com>
 <87zjrt6tz4.fsf@rustcorp.com.au>
 <20130905041338.GA21090@redhat.com>
 <20130905045745.GA18876@kroah.com>
 <20130905051945.GB23209@redhat.com>
 <20130905173540.GK6617@n2100.arm.linux.org.uk>
 <20130905192917.GA9339@redhat.com>
 <20130905211113.GA22201@redhat.com>
 <20130905212606.GA22584@redhat.com>
 <20130905214434.GL6617@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905214434.GL6617@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 10:44:34PM +0100, Russell King - ARM Linux wrote:
 > On Thu, Sep 05, 2013 at 05:26:06PM -0400, Dave Jones wrote:
 > > On Thu, Sep 05, 2013 at 05:11:13PM -0400, Dave Jones wrote:
 > >  >  > Trying without serial console next..
 > >  > 
 > >  > rebuilt with all serial turned off.
 > >  > 
 > >  > no luck, then it oopses somewhere else. I'm suspecting something isn't
 > >  > right with that debug patch, as the next trace is also in kobject_release
 > 
 > You're right about that - I had assumed that it was necessary for all
 > kobjects to be 'added' before they're released, but that is not so.
 > Mea culpa.  They just need to be initialised - the problem with putting
 > a kmalloc into kobject_init() is that if it fails, we have no way to
 > report that failure...
 > 
 > Updated patch attached... though it sounds like you got it working
 > anyway.
 > 
 > > I managed to get to userspace on one boot, and got this.
 > > 
 > > kobject ffff88023d93f518 has been corrupted (magic 0x6b6b6b6b).  Please
 > > enable kobject debugging for full debug.
 > 
 > Okay, so this is definitely a case that someone has kfree'd the kobject
 > without waiting for the ->release function to be called.
 > 
 > > That looks like SLAB_POISON. Incompatibility between the two options ?
 > > 
 > > For some reason, even though I have DEBUG_KOBJECT on, I didn't get
 > > extra messages output.
 > 
 > Hmm.
 > 
 > ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 > CFLAGS_kobject.o += -DDEBUG
 > CFLAGS_kobject_uevent.o += -DDEBUG
 > endif
 > 
 > should enable the pr_debug()'s in lib/kobject.c... which should at least
 > appear in the dmesg log.  Being debug level, of course, they won't appear
 > during normal kernel boot unless 'debug' is passed on the kernel command
 > line.
 > 
 > It seems to work for me - but... produces rather a lot of debug messages,
 > so you may also wish to ensure that you have LOG_BUF_SHIFT set to
 > something large.

As discussed on irc, with this updated patch it hangs *really* early in boot. 

With earlyprintk=vga I can see some of the trace..

kobject_init
firmware_map_add_entry
firmware_map_add_early
e820_reserve_resources
setup_arch
start_kernel
x86_64_start_reservations
x86_64_start_kernel

<RIP> kmem_cache_alloc_trace

	Dave

