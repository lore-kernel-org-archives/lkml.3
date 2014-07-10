Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaGJLaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:30:03 -0400
Received: from canardo.mork.no ([148.122.252.1]:57174 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaGJLaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:30:00 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v7 03/33] net: set name_assign_type in alloc_netdev()
Organization: m
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	<1404980258-30853-4-git-send-email-teg@jklm.no>
	<87tx6ph8u5.fsf@nemi.mork.no>
	<CAG-2HqVvW2dh5y8xn9v-B29ohFTcPGgY3NY-P5y_xZu0SGgG3g@mail.gmail.com>
Date: Thu, 10 Jul 2014 13:29:35 +0200
In-Reply-To: <CAG-2HqVvW2dh5y8xn9v-B29ohFTcPGgY3NY-P5y_xZu0SGgG3g@mail.gmail.com>
	(Tom Gundersen's message of "Thu, 10 Jul 2014 12:21:44 +0200")
Message-ID: <87ha2ph2ow.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:
> On Thu, Jul 10, 2014 at 11:16 AM, Bjørn Mork <bjorn@mork.no> wrote:
>> Tom Gundersen <teg@jklm.no> writes:
>>
>>> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
>>> index 5dc638c..f405e05 100644
>>> --- a/net/ethernet/eth.c
>>> +++ b/net/ethernet/eth.c
>>> @@ -390,7 +390,8 @@ EXPORT_SYMBOL(ether_setup);
>>>  struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
>>>                                     unsigned int rxqs)
>>>  {
>>> -     return alloc_netdev_mqs(sizeof_priv, "eth%d", ether_setup, txqs, rxqs);
>>> +     return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
>>> +                             ether_setup, txqs, rxqs);
>>>  }
>>>  EXPORT_SYMBOL(alloc_etherdev_mqs);
>>
>> I believe this chunk makes the rest of this exercise pretty pointless.
>>
>> bjorn@nemi:/usr/local/src/git/linux$ git grep alloc_etherdev drivers/net/|wc -l
>> 283
>>
>> I don't care enough to go look, but I'd be surprised if none of those
>> drivers rename the device before registering it.
>
> I did look for that, and I only found devices being renamed to the
> same name assign type as eth%d (wlan%d, etc).

You explain the vlan patch as follows:

 "When deriving the name from the real device, inherit the assign type, otherwise
  set PREDICTABLE as the name will be uniquely determined by the VLANID."


How come the same doesn't apply here?:

struct net_device * hostap_add_interface(struct local_info *local,
                                         int type, int rtnl_locked,
                                         const char *prefix,
                                         const char *name)
{
        struct net_device *dev, *mdev;
        struct hostap_interface *iface;
        int ret;

        dev = alloc_etherdev(sizeof(struct hostap_interface));
        if (dev == NULL)
                return NULL;

        iface = netdev_priv(dev);
        iface->dev = dev;
        iface->local = local;
        iface->type = type;
        list_add(&iface->list, &local->hostap_interfaces);

        mdev = local->dev;
        eth_hw_addr_inherit(dev, mdev);
        dev->base_addr = mdev->base_addr;
        dev->irq = mdev->irq;
        dev->mem_start = mdev->mem_start;
        dev->mem_end = mdev->mem_end;

        hostap_setup_dev(dev, local, type);
        dev->destructor = free_netdev;

        sprintf(dev->name, "%s%s", prefix, name);
..

when this is called as

        dev = hostap_add_interface(local, HOSTAP_INTERFACE_WDS, rtnl_locked,
                                   local->ddev->name, "wds%d");

..
        local->apdev = hostap_add_interface(local, HOSTAP_INTERFACE_AP,
                                            rtnl_locked, local->ddev->name,
                                            "ap");
..
        local->stadev = hostap_add_interface(local, HOSTAP_INTERFACE_STA,
                                             rtnl_locked, local->ddev->name,
                                             "sta");


?

Yes, this is an exception.  But so are every instance of alloc_netdev
ending up with something different from NET_NAME_ENUM...

How much would this patchset reduce to if you just set
dev->name_assign_type = NET_NAME_UNKNOWN in alloc_netdev() and changed
it only in the few places where you actually *know* the name_assign_type?

My fear wrt this pathset is that the 'name_assign_type' will end up as
yet another useless field like 'addr_assign_type' and 'type'. There is
no way the kernel will be able to set these with 100% confidence, and
the value is therefore next to nothing.  If userspace is stupid enough
to trust them, then you end up with extremely hard to fix errors in the
cases where the driver/kernel guesswork is wrong.

Just one example of this, affecting the 'type': Huawei happens to use
the same device IDs for modems requiring userspace management (should
have a wwan_type) and modems with built-in management (should have a
default type).  So which 'type' should we choose for this device?
userspace can figure out by careful probing, but if it trusts the 'type'
set by the driver then it will get it wrong. The field provides no value
at all.

But if you limit the scope of the 'name_assign_type' patches to only
those cases where you actually have some information, then I guess it
might provide some value for userspace.


Bjørn
