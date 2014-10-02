Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaJBNUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:20:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47067 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJBNUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:20:39 -0400
Message-ID: <1412256036.20895.10.camel@lp-lvrv.comap.cz>
Subject: Re: [PATCH v2 2/2] mtd: nand: omap: Synchronize access to the ECC
 engine
From: Rostislav Lisovy <lisovy@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        sojkam1@fel.cvut.cz, Rostislav Lisovy <lisovy@merica.cz>
Date: Thu, 02 Oct 2014 15:20:36 +0200
In-Reply-To: <542D4A51.9060907@ti.com>
References: <1412252173-20454-1-git-send-email-lisovy@merica.cz>
	 <1412252173-20454-2-git-send-email-lisovy@merica.cz>
	 <542D4A51.9060907@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roger;
Thanks for the review.

On Čt, 2014-10-02 at 15:51 +0300, Roger Quadros wrote:
> Don't you think this approach is racy?
> 
> IMHO the lock must be held across the entire page operation

I still think it is done in this way.

> i.e.
> hold ecc lock
> ecc.hwctl
> chip->read/write_buf
> ecc.calculate
> ecc.correct
> release ecc lock

According to my understanding of the code 'ecc.correct' does not access
the ECC engine directly, it gets the '*read_ecc' and '*calc_ecc' from
the 'ecc.calculate'.

Once again the work flow you described + my locking approach:
* ecc.hwctl       <-- mutex_lock() just before accessing the ECC engine
* chip->read/write_buf
* ecc.calculate   <-- mutex_unlock() just after reading from ECC engine
* ecc.correct

> 
> else we risk simultaneous NAND operations on multiple chips
> stomping on each other in between the entire sequence.
> 
> Then on further investigation isn't nand_get_device() already doing
> the same
> thing as you are attempting here?
> 
> The chip->controller->lock is meant for serializing NAND controller
> access.
> 
> so instead of adding a new lock in the omap2 nand driver we need to
> ensure that
> we are maintaining the same nand_hw_control (controller) structure
> across multiple NAND chips.
> 
> Let's move this controller structure out of omap_nand_info and keep it
> global to the driver
> and make sure every NAND instance uses it.

Ok; I will take a look at it. It looks like the appropriate lock to use.
I am just a bit unsure if the 'spinlock' is the correct synchronization
primitive here.

Best regards;
Rostislav

