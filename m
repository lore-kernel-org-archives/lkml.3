Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHaS27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:28:59 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58286 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHaS2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:28:55 -0400
Date: Sun, 31 Aug 2014 11:28:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        falcon@meizu.com, tiwai@suse.de, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831182851.GC17827@core.coreip.homeip.net>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831101358.GB19853@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Tejun,

On Sun, Aug 31, 2014 at 06:13:58AM -0400, Tejun Heo wrote:
> Hello, Luis.
> 
> I haven't followed the previous discussions so please let me know if
> this has been discussed before.  It looks like you're trying to extend
> the async mechanism and applying them to init functions themselves.
> That sounds kinda weird to me.  Isn't the root cause of the problem
> doing device probings along with driver initilaization on module load?

For my use case it is driver initialization itself (because most of the
relevant drivers is compiled in). Although, come to think, if we could do
something about resume that would be nice too: then I'd be able to drop all
stuff in serio that lies about device state and marks it as resumed even though
mouse/touchpad will be actually reset and operable much later.

> 
> Wouldn't it be more logical to simply make bus_add_driver() ->
> driver_attach() invocation asynchronous?  There's no reason to make
> them parallel either.  We can use an ordered queue for it so that we
> don't lose the probing order we used to have.

Sometimes losing probing order is the desired outcome though. Like with my
beloved touchpad :)

> Making things go
> parallel is the responsibility of each probing function after all and
> there isn't much to gain by making attach calls go parallel.

If we make probe function schedule stuff asynchronously, then, in case of
failures, we'll end up with half-bound driver. Also drivers would have to have
additional code on removal to make sure probe full done before removing. PM
methods need to be ready to be called on half-initialized device. It is a mess.

Thanks.

-- 
Dmitry
