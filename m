Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750777Ab3IFH76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 03:59:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53497 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3IFH75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:59:57 -0400
Date: Fri, 6 Sep 2013 08:59:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130906075937.GM6617@n2100.arm.linux.org.uk>
References: <87zjrt6tz4.fsf@rustcorp.com.au> <20130905041338.GA21090@redhat.com> <20130905045745.GA18876@kroah.com> <20130905051945.GB23209@redhat.com> <20130905173540.GK6617@n2100.arm.linux.org.uk> <20130905192917.GA9339@redhat.com> <20130905211113.GA22201@redhat.com> <20130905212606.GA22584@redhat.com> <20130905214434.GL6617@n2100.arm.linux.org.uk> <20130906011137.GA25277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906011137.GA25277@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:11:37PM -0400, Dave Jones wrote:
> As discussed on irc, with this updated patch it hangs *really* early in boot. 
> 
> With earlyprintk=vga I can see some of the trace..
> 
> kobject_init
> firmware_map_add_entry
> firmware_map_add_early
> e820_reserve_resources
> setup_arch
> start_kernel
> x86_64_start_reservations
> x86_64_start_kernel
> 
> <RIP> kmem_cache_alloc_trace

Argh, so kobject_init() gets used before the memory allocators are setup.
This is starting to look like we can't separate the delayed_work from
the kobject struct to provide a layer of isolation.  I'm running out of
ideas here.

Do we have a way to tell if the memory allocators have been initialised?
I can't see anything that would, with the exception that the scheduler
initialisation requires memory allocators are up and running, and it has
its own scheduler_running state, but that's buried in the scheduler.

system_state is useless for this because it gets set to the running state
after device initialisation, and just before we drop into userspace.

We could go back to doing the allocation at kobject_add() time, that seemed
to be marginally successful for you - but I'm fairly certain it won't get
all kobjects that are later released (because its possible to init a
kobject and then put it once to discard it.)
