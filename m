Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3BTVip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:38:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:43083 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3BTVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:38:44 -0500
Date: Wed, 20 Feb 2013 22:38:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
In-Reply-To: <20130220210116.GD3570@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1302202208470.22263@ionos>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Tejun Heo wrote:

> Recent idr updates make idr_find() trigger WARN_ON_ONCE() before
> returning NULL when a negative ID is specified.  Apparently,
> posix-timer::__lock_timer() was depending on idr_find() returning NULL
> on negative ID, thus triggering the new WARN_ON_ONCE().  Make
> __lock_timer() first check whether @timer_id is negative and return
> NULL without invoking idr_find() if so.

I can grumpily accept the patch below as a quick hack fix, which can
go to stable as well, but not with such a patently misleading
changelog.

The changelog wants to document, that this is not a proper fix at all
and just a quick hack which can be nonintrusively applied to stable.

> Note that the previous code was theoretically broken.  idr_find()
> masked off the sign bit before performing lookup and if the matching
> IDs were in use, it would have returned pointer for the incorrect
> entry.

Brilliant code that. What's the purpose of having the idr id as an
"int" and then masking off the sign bit instead of simply refusing
negative id values in the idr code itself or simply making the id
"unsigned int" ?

Just look at the various f*ckedup users of MAX_IDR_MASK. Example:

drivers/pps/pps.c:

        err = idr_get_new(&pps_idr, pps, &pps->id);
        mutex_unlock(&pps_idr_lock);

        if (err < 0)
                return err;

        pps->id &= MAX_IDR_MASK;

Why the heck is that necessary? Either we get an error code and we
don't care about pps->id or idr_get_new() sets pps->id to a valid idr
id. If the idr code really returns a _valid_ id with the sign bit set,
then the idr code is broken beyond repair and needs to be fixed
instead of propagating that insanity all over the users.

Thanks,

	tglx

