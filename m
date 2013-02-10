Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3BJLwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:52:21 -0500
Received: from sauhun.de ([89.238.76.85]:57194 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3BJLwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:52:19 -0500
Date: Sun, 10 Feb 2013 12:52:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, linux-rdma@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_*
 into idr.c
Message-ID: <20130210115214.GC5472@nekote.pengutronix.de>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130208210149.GB26660@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130208210149.GB26660@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 01:01:49PM -0800, Tejun Heo wrote:
> MAX_IDR_MASK is another weirdness in the idr interface.  As idr covers
> whole positive integer range, it's defined as 0x7fffffff or INT_MAX.
> 
> Its usage in idr_find(), idr_replace() and idr_remove() is bizarre.
> They basically mask off the sign bit and operate on the rest, so if
> the caller, by accident, passes in a negative number, the sign bit
> will be masked off and the remaining part will be used as if that was
> the input, which is worse than crashing.
> 
> The constant is visible in idr.h and there are several users in the
> kernel.
> 
> * drivers/i2c/i2c-core.c:i2c_add_numbered_adapter()
> 
>   Basically used to test if adap->nr is a negative number which isn't
>   -1 and returns -EINVAL if so.  idr_alloc() already has negative
>   @start checking (w/ WARN_ON_ONCE), so this can go away.
> 
> * drivers/infiniband/core/cm.c:cm_alloc_id()
>   drivers/infiniband/hw/mlx4/cm.c:id_map_alloc()
> 
>   Used to wrap cyclic @start.  Can be replaced with max(next, 0).
>   Note that this type of cyclic allocation using idr is buggy.  These
>   are prone to spurious -ENOSPC failure after the first wraparound.
> 
> * fs/super.c:get_anon_bdev()
> 
>   The ID allocated from ida is masked off before being tested whether
>   it's inside valid range.  ida allocated ID can never be a negative
>   number and the masking is unnecessary.
> 
> Update idr_*() functions to fail with -EINVAL when negative @id is
> specified and update other MAX_IDR_MASK users as described above.
> 
> This leaves MAX_IDR_MASK without any user, remove it and relocate
> other MAX_IDR_* constants to lib/idr.c.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For the i2c-part:

Acked-by: Wolfram Sang <wolfram@the-dreams.de>

