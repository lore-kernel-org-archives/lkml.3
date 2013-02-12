Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3BLRK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:10:58 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49909 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3BLRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:10:55 -0500
Date: Tue, 12 Feb 2013 09:10:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] idr: fix top layer handling
Message-ID: <20130212171049.GA7348@htj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130211153955.0b6e1f1e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211153955.0b6e1f1e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Andrew.

On Mon, Feb 11, 2013 at 03:39:55PM -0800, Andrew Morton wrote:
> This doesn't apply happily to 3.7, so Greg will be needing a redone
> version when the time arrives.
> 
> But does it really need backporting?  Is anyone likely to hit this in
> practice?

For most cases, probably not.  IDR_BITS being 5 and 6 on 32 and 64bit
respectively, the only misbehaving bit is bit 30, so unless ID goes
over 1G, which should be close to non-existent if the IDs are being
allocated from zero, it shouldn't be a problem; however, we do have
users where IDR is used to allocate cyclic IDs.  They maintain and
progress the last allocated ID so that IDs don't get recycled without
wrapping around.  I have no idea whether any of them would be
allocating IDs fast enough to go over 1G limit in any reasonable
amount of time or whether there are such ID allocations which can be
exploited from userland without root priviliedges, in which case it
would probably directly lead to oops.

So, to sum up, at least I can't rule out the issue happening or being
exploited in the wild with older kernels.  It isn't too likely to
happen naturally but if there's a userland exploitable cyclic
alloction, going over 1G wouldn't be too difficult.

> Also, I assume you have some sort of IDR test harness over there.  Is
> it something we can get into the tree in some fashion to help with
> ongoing maintenance?

Right now, it's just a messy test module with ad-hoc loops and manual
alloc/frees with a lot of printks sprinkled everywhere, so I'm afraid
it wouldn't be suitable for any form of automated test.  It sure would
be great to have a testing harness for this tho.

Thanks.

-- 
tejun
