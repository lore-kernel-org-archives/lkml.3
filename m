Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaHaTYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:24:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:36743 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaHaTYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:24:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379501015"
Message-ID: <5403767E.1020107@linux.intel.com>
Date: Sun, 31 Aug 2014 12:24:46 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        falcon@meizu.com, tiwai@suse.de, tj@kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com> <540334B2.7000009@linux.intel.com> <20140831175040.GA17827@core.coreip.homeip.net>
In-Reply-To: <20140831175040.GA17827@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> before we added the current async approach the approach of async init calls was tried
>> At the time, Linus hated it and he was right, it was not the right thing.
>>
>> What is different this time to make this the right thing to do ?
>
> Because otherwise drivers still have to do this, but open code it. Let's say I
> have a long operations (i.e. for some touchpads it takes about 2 secs to reset
> and configure it). I can offload that part into async_schedule() so it does not
> stop initialization of the rest of the system (why would I want to delay
> initializing of USB or storage system until touchpad is ready?) but if that
> initialization fails we end up with partially bound driver and device that is
> not really operable. I would very much prefer async and sync cases be the same
> - if probe() fails the driver is not bound to the device.
>
> I think it is wrong to make async probing system-wide, but driver opt-in shoudl
> be fine and right thing to do.
>

I am completely fine if we make basically an async wrapper for
pci_register_driver() and friends.. that would be convenient I suppose.

(but then again, in reality very few drivers take real time to init... most already
do the heavy work in open(). Not all can, sure, but if you look at a bootgraph.pl
graph of a typical boot it's only a few that matter).
And many drivers need to register with a subsystem, and there's some ordering around that,
and that's why we ended up with the async cookie stuff, so that you can do the
heavy work in parallel, but order near the end at registeration-with-the-subsystem time.

But doing this on an initcall level was wrong back then, and I have yet to hear
a reason why it would be right this time.



