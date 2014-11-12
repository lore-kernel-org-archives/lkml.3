Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaKLCr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:47:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36653 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbaKLCrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:47:55 -0500
Date: Tue, 11 Nov 2014 21:47:52 -0500 (EST)
Message-Id: <20141111.214752.266800170368088905.davem@davemloft.net>
To: mkubecek@suse.cz
Cc: vfalico@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, andy@greyhouse.net, jiri@resnulli.us
Subject: Re: [PATCH net-next 0/3] dev_disable_lro() improvements for
 stacked devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141111093457.GA30178@unicorn.suse.cz>
References: <cover.1415692212.git.mkubecek@suse.cz>
	<20141111090522.GB20586@raspberrypi>
	<20141111093457.GA30178@unicorn.suse.cz>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 18:47:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Tue, 11 Nov 2014 10:34:57 +0100

> On Tue, Nov 11, 2014 at 10:05:22AM +0100, Veaceslav Falico wrote:
>> On Tue, Nov 11, 2014 at 09:21:30AM +0100, Michal Kubecek wrote:
>> >Large receive offloading is known to cause problems if received packets
>> >are passed to other host. Therefore the kernel disables it by calling
>> >dev_disable_lro() whenever a network device is enslaved in a bridge or
>> >forwarding is enabled for it (or globally). For virtual devices we need
>> >to disable LRO on the underlying physical device (which is actually
>> >receiving the packets).
>> >
>> >Current dev_disable_lro() code handles this propagation for a vlan
>> >(including 802.1ad nested vlan), macvlan or a vlan on top of a macvlan.
>> >This patch adds LRO disabling propagation for
>> >
>> > - macvlan on top of a vlan or any stacked combination of those
>> > - bonding
>> > - teaming
>> 
>> All of these drivers use the netdev_upper and friends, so why not make it
>> generic with netdev_for_each_all_lower() in dev_disable_lro()?
> 
> I wanted to preserve current approach where for vlan and macvlan, LRO is
> disabled on the real device instead of the original one (rather than in
> addition to it) as LRO is always disabled on them.
> 
> Handling all four uniformly would make the code nicer but would bring
> unnecessary overhead of traversing the list and dev_disable_lro()
> recursion. On the other hand, this operation is not time critical so it
> might be acceptable after all.

Please do it generically.

Having a special stanza for each layered device type in
dev_disable_lro() is beyond stupid.  Especially when it
can in fact be done cleanly.

THanks.
