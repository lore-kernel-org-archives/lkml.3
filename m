Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894Ab3GWWnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:43:46 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49124 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934665Ab3GWWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307192315470.24914-100000@netrider.rowland.org>
References: <CAB=NE6WfbauZnzCT=jgfUtc2Roe7WfY=G7Z5OAobc9YLc0nCvw@mail.gmail.com>
 <Pine.LNX.4.44L0.1307192315470.24914-100000@netrider.rowland.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 23 Jul 2013 15:43:19 -0700
X-Google-Sender-Auth: hkv58_iugHgwOE9BZtxMKU4b6NQ
Message-ID: <CAB=NE6Vk8H2aegWMKLw_mrQynt1TH=pnrQhO08zTkBq6cHxStA@mail.gmail.com>
Subject: Re: [PATCH] backports: backport drvdata = NULL core driver fixes
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 8:36 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 19 Jul 2013, Luis R. Rodriguez wrote:
>
>> Thanks Julia. In that case I'm going to just leave this in place given
>> that if there's a bug upstream we'll get it fixed as soon as a
>> respective patch gets upstream as well. That is, we are not using old
>> drivers, we use the same upstream drivers so if a regression was found
>> in backports the fix must go upstream s well. This is one of the
>> benefits of backporting -- the range of users and testers increases
>> and we still benefit from the upstream bandwagon.
>
> I don't understand.  If you're not using old drivers, and you
> incorporate all the upstream patches, then what's the difference
> between a backport and the current kernel?

The difference is that in older kernels driver_probe_device() and
device_release_driver() wouldn't do the setting to NULL in case of
probe fail or release, that's what the patch does. Given that the new
drivers have the superfluous setting removed we'd need a way to get
older kernels to clear it as well and there were two ways to do it --
revert the changes for all drivers this was cleared from or hack up
the same callback used driver_probe_device() and
device_release_driver() to do the appropriate clearing prior to
calling the old kernel's routines.

> In fact, if you're
> incorporating all the upstream driver patches, then why haven't you
> already got the drvdata change?

Because older kernel's driver_probe_device() and
device_release_driver() would be used.

> As one example of the sort of subtle problem exposed by the drvdata
> change, take a look at commit b2ca69907657.

Understood.

> For more examples, see commits bf90ff5f3b8f, 638b9e15233c,
> 51ef847df746, 289b076f89c2, 53636555b919, 99a6f73c495c, 003615302a16,
> 94ab71ce2889, 3124d1d71d3d, c27f3efc5608, 95940a04bfe8, 5c1a0f418d8d,
> db5c8b524444, 8bf769eb5f6e, 4295fe7791a1, fa919751a2d2, a9556040119a,
> 7bdce71822f4, and a1028f0abfb3.  Admittedly, these are all related
> problems in a single subsystem, but it gives you a little idea of how
> far this goes.

Sure, I understand. By pushing the newer drivers as-is *and* by
providing the driver_probe_device() and device_release_driver()
respective changes for older kernels it should get us similar behavior
on older kernels. Mind you, there is a small race in the way I
implemented this on device_release_driver() but that seems like a
reasonable tradeoff against all other alternatives I could come up
with.

As it is now, unless my port is incorrect, the newer drivers used on
older systems should trigger a similar bug as if using the upstream
kernel with the same drivers.

  Luis
