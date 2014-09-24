Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaIXQpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:45:34 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46804 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <5422F0F4.6000709@6wind.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
	<5422F0F4.6000709@6wind.com>
Date: Wed, 24 Sep 2014 09:45:30 -0700
Message-ID: <CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
From: Cong Wang <cwang@twopensource.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:27 AM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Now informations got with 'ip link' are wrong and incomplete:
>   - the link dev is now tunl0 instead of eth0, because we only got an
> ifindex
>     from the kernel without any netns informations.

This is not new, macvlan has the same problem. This is why I said
it is mostly a display problem, maybe just mark the ifindex as -1 or
something when it is not in this netns. At least I don't expect the inner
netns know anything outside, and I don't think I am the only one using
netns in this way.

>   - the encapsulation addresses are not part of this netns but the user
> doesn't
>     known that (still because netns info is missing). These IPv4 addresses
> may
>     exist into this netns.

I don't remember your x-netns code, but we have two choices:

1) Lookup the route of the netns which it is in

If the address is not available in this netns, it will fail, this is expected
since tunnel device is not a pure L2 device. Or maybe just fail
early when we move it.

2) Lookup the route of the netns where it was created

Transparent for upper layer, but as you said, the outer address is not
available in this netns therefore hard to display. Just hiding this information
doesn't seem wrong to me.


>   - it's not possible to create the same netdevice with these infos.
>

This is expected, because after all you are already in a different netns.
