Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaBEOuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:50:21 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47009 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBEOuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:50:19 -0500
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140205123446.GI26722@mwanda>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
 <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de>
 <52EFCC66.9020304@lwfinger.net> <20140203201228.GE26722@mwanda>
 <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com>
 <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com>
 <20140204092836.GG26776@mwanda> <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
 <20140205123446.GI26722@mwanda>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Wed, 5 Feb 2014 15:49:58 +0100
Message-ID: <CAN8YU5NuFZfK4gGAsx34ZruBVx6U_cMGSogiTdWWv8LfpsFb=w@mail.gmail.com>
Subject: Re: rtl8821ae.
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks good.  It would be best to submit the bugfixes first like where
> you add error checking for pci_map_single().

Yes, this is exactly what I started to do this morning :)
I'm preparing a patchseries where I extracting fixes or improvements
unrelated to rtl8187se, including pci_map_single fixes

> You add too many blank lines btw, you should never have two
> consecutive blank lines.  Don't add a blank line in the middle of the
> declaration block or before a close curly brace '}' line.

OK

> After that
> maybe the patch to change "if (priv->r8185)" to
> "if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)". Then the patch
> to add rtl8225se support.

Yes, this is also my plan :)

> Some minor things below.

Ok, I have reviewed all your advices.
I agree with them.
I also commended the ones where you asked something about.

> regards,
> dan carpenter

Thank you a lot for your review!

Andrea

>> +#include "rtl8225se.h"
>> +
>
> Don't include this twice.  Only put one blank line, not two consecutive
> blank lines.

OK

> This comment is out of date.  RTL8180_NR_TX_QUEUES is 2.  I haven't
> really understood the changes to rtl8180_queues_map[].  It used to have
> 4 elements and now it only has 2.  Is this change needed to support
> rtl8225se or is it a separate bugfix which should go in a separate
> patch?

It's for rtl8187se.
That card uses more queues to enable WMM

> Also this change which I have pulled out of context:
>
> +     if (ring->entries - skb_queue_len(&ring->queue) < 2) {
> +             if (prio != dev->queues)
> +                     ieee80211_stop_queue(dev, prio);
> +             else
> +                     priv->beacon_queue_stop = 1;
> +     }
>
> This is a separate bugfix?

Yes, the old driver uses ieee80211_stop_queue and ieee80211_wake_queue
on the beacon queue, that is indeed handled in the driver and not by
ieee80211
This one of the things that I will include in patches for
rtl8180/rtl8185 fixes before merging real rtl8187se code

>> +static void rtl8180_write_phy_(struct ieee80211_hw *dev, u8 addr, u32 data)
>
> This is a temporary name to not conflight with rtl8180_write_phy()?

No, this is the aux function that does the real work, but should not
be called directly in the driver code, as rtl8180_write_phy() should
be called.
Maybe I have to move the underscore at the beginning of the name.

>
> These don't go over the 80 character limit so we don't need the line
> breaks.  The casts are not needed either.

OK

>> +     if ((addr == 0xa) && (
>> +                 priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185))
>> +             rb_mask = 0x7f;
>
> Write it like this:
>
>         if (addr == 0xa && priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
>                 rb_mask = 0x7f;
>
> If you really want to add parenthesis then do this:
>
>         if ((addr == 0xa) &&
>             (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185))
>                 rb_mask = 0x7f;

OK

>> -     buf = (data << 8) | addr;
>> +     if (tmp & 0x80)
>> +             printk(KERN_WARNING
>> +                    "rtl818x failed to write BB (busy) adr:%x data:%x\n",
>> +                    addr, data);
>
> Checkpatch.pl will complain that you should use netdev_warn() or
> something.

OK


>
> Don't put a blank line here in the middle of the declaration block.
>

OK


>> +             frame_duration =  priv->ack_time + le16_to_cpu(
>> +                     ieee80211_generic_frame_duration(dev, priv->vif,
>> +                                     IEEE80211_BAND_2GHZ, skb->len,
>> +                                     ieee80211_get_tx_rate(dev, info)));
>
> Use a temporary variable:
>
>                 __le16 duration;

I agree. Will do.

>> +     /* must be written last */
>>       entry->flags = cpu_to_le32(tx_flags);
>
> Why must this be written last?  The CPU can re-order it anyway unless
> there is some locking.

Because that marks the descriptor as good for the NIC to be processed.
I suppose a wmb() is needed before this line to ensure it is the last written
and another wmb() is needed to ensure that the descriptor is fully
written before polling the NIC for performing DMA (I think that,
depending by the situation, the HW may wait for this register write on
not).


>> +     /* Enable DA10 TX power saving */
>> +     rtl818x_iowrite8(priv, &priv->map->PHY_PR,
>> +                      rtl818x_ioread8(priv, &priv->map->PHY_PR) | 0x04);
>
> Use a temporary variable:
>
>         reg = rtl818x_ioread8(priv, &priv->map->PHY_PR);
>         rtl818x_iowrite8(priv, &priv->map->PHY_PR, reg | 0x40);
>

OK

>> +static void rtl8187se_set_antenna_config(struct ieee80211_hw *dev, u8 def_ant,
>> +                                      bool use_diver)
>
> Could you rename "use_diver" to "diversity"?  I misread it every time.

It makes sense.


>> +#if 0
>> +static void rtl8187se_power_tracking(struct ieee80211_hw *dev)
>> +{
>> +     struct rtl8180_priv *priv = dev->priv;
>> +     u8 tmp = rtl818x_ioread8(priv, REG_ADDR1(0x238));
>> +     u8 current_temp;
>> +     int i;
>> +     char cck_idx, ofdm_idx;
>> +
>> +     current_temp = (tmp & 0xF0) >> 4;
>> +     current_temp = (current_temp > 0x0C) ? current_temp : 0x0C;
>
>         curent_temp = max_t(u8, current_temp, 0x0C);
>
> I prefer max_t because it looks more deliberate and people won't think
> you intended to use the minimum value.

This function is switched off by a #if 0
It will be not included yet, and I have to review it, so it might change.
BTW I will certainly consider your advices

>> +     int chan =
>> +             ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
>> +
>
> You could avoid the split line by doing this:
>
>         struct ieee80211_conf *conf = &dev->conf;
>         int chan;
>
>         chan = ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
>

OK
