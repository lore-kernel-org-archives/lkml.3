Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3HZJNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:13:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50455 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3HZJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:13:39 -0400
Date: Mon, 26 Aug 2013 10:13:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [accent_init] BUG: unable to handle kernel NULL pointer
	dereference at 00000078
Message-ID: <20130826091319.GZ6617@n2100.arm.linux.org.uk>
References: <20130826005809.GA8764@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826005809.GA8764@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 08:58:09AM +0800, Fengguang Wu wrote:
> Hi Russell King,
> 
> Here is another bug that's triggered by

Not much idea about this one, I don't understand what debugobjects.c is
indicating.

What I think it may be indicating is that the timer list inside the
delayed workqueue is being initialized when it is already active, but
if that is the case, it means that we're releasing the same kobject
multiple times - I believe that kref will complain if that were the
case, so I suspect that's not what's going on here.

Hmm.  My guess is that the cdev kobject is being correctly freed, but
nothing is notifying the debugobjects code that that has happened.
I don't see any kind of interface to destroy a delayed workqueue (or
any workqueue) which isn't on the stack - or even a timer for that
matter.

What this suggests is that allocating a structure containing a
struct timer_list, initialising that timer list, freeing the structure,
allocating it again (and getting the same address), initialising it
a second time will produce this warning.

So, it looks to me like the debugobjects stuff is... buggy.
