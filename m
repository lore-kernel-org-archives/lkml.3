Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaHaRuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 13:50:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54446 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaHaRup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 13:50:45 -0400
Date: Sun, 31 Aug 2014 10:50:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        falcon@meizu.com, tiwai@suse.de, tj@kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831175040.GA17827@core.coreip.homeip.net>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <540334B2.7000009@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540334B2.7000009@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 07:44:02AM -0700, Arjan van de Ven wrote:
> On 8/31/2014 2:03 AM, Luis R. Rodriguez wrote:
> >From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> >While reviewing Wu Zhangjin's solution to async probe [0] and his
> >ideas on creating async groups I decided to try following the init
> >levels on the kernel to try to help with synchronization at least
> >on some level. This borrows ideas discussed with the kthread_create()
> >solution [1] and also simplifies the idea of how we should be grouping
> >async calls between drivers.
> >
> >A few things worth mentioning. I decided to go down a generic solution as
> >if we ever wanted to bring asynchrnonization behaviour below modules
> >this would allow folks to start testing this without much effort. It
> >allows asynchronous calls to upkeep the order already set in place
> >for built-in code. If one wanted to eventually venture down below
> >that path we'd need to add respective exit calls for each level, as
> >right now we just assume that every level should use module_exit().
> >SmPL grammer could be used to easily tidy this up, for example on
> >the subsys_init():
> 
> before we added the current async approach the approach of async init calls was tried
> At the time, Linus hated it and he was right, it was not the right thing.
> 
> What is different this time to make this the right thing to do ?

Because otherwise drivers still have to do this, but open code it. Let's say I
have a long operations (i.e. for some touchpads it takes about 2 secs to reset
and configure it). I can offload that part into async_schedule() so it does not
stop initialization of the rest of the system (why would I want to delay
initializing of USB or storage system until touchpad is ready?) but if that
initialization fails we end up with partially bound driver and device that is
not really operable. I would very much prefer async and sync cases be the same
- if probe() fails the driver is not bound to the device.

I think it is wrong to make async probing system-wide, but driver opt-in shoudl
be fine and right thing to do.

Thanks.

-- 
Dmitry
