Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaCCX7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:59:13 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52705 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaCCX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140303154330.238a20bc@nehalam.linuxnetplumber.net>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
 <1393886825-24323-5-git-send-email-mcgrof@do-not-panic.com> <20140303154330.238a20bc@nehalam.linuxnetplumber.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 3 Mar 2014 15:58:50 -0800
X-Google-Sender-Auth: f4wq7xf3SI3qLOhV4IODSRK3RVM
Message-ID: <CAB=NE6VpjebGrqFe7Q4L-uM0rrKitY3fB2kq5qGko+C1Fivm0w@mail.gmail.com>
Subject: Re: [RFC v3 4/6] bridge: enable root block during device registration
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 3:43 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> Doing this in priv flags bloats what is a limited resource (# of bits).

Agreed. I tried to avoid it but saw no other option for addressing
this during initialization properly without requirng a userspace
upgrade.

> Plus there are issues (what if this is changed after adding to bridge)?

Its only considered when the net_device gets added to the bridge. If
you add it and then toggle root_block off that will be respected. If
you remove the net_device from the bridge and then add it back on the
priv flag will be respected but if desirable we could toggle it off if
userspace was used to disable root_block once on.

> Maybe better to enhance existing netlink infrastructure to allow passing
> flags on adding port to bridge.

Agreed, I looked into this and the limitation of using the existing
slave add request is that ndo_add_slave() only passes the net_device,
we'd have to either extend that (with collateral study on other slaves
as noted on my cover letter) or we'd have to make this a UAPI netlink
feature for the net_device. Some old userspace  may not use netlink
too, and they may be stuck with brctl, I tried to create a compromise
only to not affect old userspace if that kernel gets upgraded.

> Also, unless device is up, nothing will happen right away when added to bridge.

I get different results, the bridge immediately does compute whether
or not to nominate a device for the bridge interface and root port.
The commands provided as an example on 3/6 can be used to replicate
this.

> Root port status can be changed since device is disabled.

Agreed however the reason for the flag is to address removing high MAC
address hack-preference set on drivers that were merged prior to the
root_block feature. Without a proper way to address this upon
initialization we're stuck with requiring userspace upgrade if these
driver's hack is removed.

  Luis
