Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaJGPvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:51:13 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58205 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaJGPvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:51:11 -0400
Date: Tue, 7 Oct 2014 08:51:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/44] kernel: Add support for poweroff handler call chain
Message-ID: <20141007155012.GA28835@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-2-git-send-email-linux@roeck-us.net>
 <20141007113903.0c3e29e4@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007113903.0c3e29e4@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:39:03AM +0100, One Thousand Gnomes wrote:
> On Mon,  6 Oct 2014 22:28:03 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Various drivers implement architecture and/or device specific means to
> > remove power from the system.  For the most part, those drivers set the
> > global variable pm_power_off to point to a function within the driver.
> > 
> > This mechanism has a number of drawbacks.  Typically only one scheme
> > to remove power is supported (at least if pm_power_off is used).
> > At least in theory there can be multiple means remove power, some of
> > which may be less desirable. For example, some mechanisms may only
> > power off the CPU or the CPU card, while another may power off the
> > entire system.  Others may really just execute a restart sequence
> > or drop into the ROM monitor. Using pm_power_off can also be racy
> > if the function pointer is set from a driver built as module, as the
> > driver may be in the process of being unloaded when pm_power_off is
> > called. If there are multiple poweroff handlers in the system, removing
> > a module with such a handler may inadvertently reset the pointer to
> > pm_power_off to NULL, leaving the system with no means to remove power.
> > 
> > Introduce a system poweroff handler call chain to solve the described
> > problems.  This call chain is expected to be executed from the
> > architecture specific machine_power_off() function.  Drivers providing
> > system poweroff functionality are expected to register with this call chain.
> > By using the priority field in the notifier block, callers can control
> > poweroff handler execution sequence and thus ensure that the poweroff
> > handler with the optimal capabilities to remove power for a given system
> > is called first.
> 
> Nice...
> 
> register_poweroff_handler_simple isn't threadsafe. I'm not sure it
> matters as we should only have one attempt per platform to use it anyway.
> 
Yes, I know. Agreed, it should not matter, but maybe it can be solved by
using raw notifiers and spinlocks for protection.

> have_kernel_poweroff() has a similar problem - the answer isn't always
> valid by the time the call returns.
> 
This is an interesting one. Logically the answer can not be guaranteed to be
correct by the time it is evaluated in the calling code, no matter how much
protection I add around it. Not sure if there is anything I can or should do
about that.

> The actual poweroff logic is more of a problem - several of the Intel
> PMICs are on i2c bus, so are not going to be happy in an atomic context
> so I wonder if that is storing up problems for the future ?
> 
Yes, Philippe brought that up as well. I think I may have to use raw
notifiers, and use spinlocks for protection. Would this work ?

Thanks,
Guenter
