Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3BZUBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:01:25 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:39678 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622Ab3BZUBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:01:23 -0500
MIME-Version: 1.0
In-Reply-To: <CABvG-CW+ykoZMz49UNS11=rLViNQ3uyo-sHeJqOdp06Vwd628g@mail.gmail.com>
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
 <CAB=NE6WAKjktv8G1eikkfkbB7KAa_XefJj-udfH8b_vvgLbznQ@mail.gmail.com> <CABvG-CW+ykoZMz49UNS11=rLViNQ3uyo-sHeJqOdp06Vwd628g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 26 Feb 2013 12:01:00 -0800
X-Google-Sender-Auth: moXLA900KyyYB0PjCnBtpnA9sVs
Message-ID: <CAB=NE6VkOHe17=uRJ537r7nF_0aQQNCeto8CnMON6EpqP0qbbA@mail.gmail.com>
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
To: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Cc: David Quan <dquan@qca.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:28 AM, Michał Kazior <kazikcz@gmail.com> wrote:
> On 26 February 2013 19:29, Luis R. Rodriguez <mcgrof@qca.qualcomm.com> wrote:
>> NACK. This comes up every now and then and this is not a valid device
>> ID, this is an issue with the card, so what you can do is adjust the
>> device ID post bootup. Not sure if distros have an easy way to set
>> this up, if not perhaps this should be considered as this has come up
>> twice before.
>
> The erroneous 0xFFFF value comes from using one of eeprom_ops
> implementations.

Apologies I quickly read this as an issue with 0xFFFF device ID and
not a regulatory domain ID being set to 0xFFFF. Just to clarify for
the reader / record then given I may have mislead folks with my
comments -- the issue you are reporting is regarding an 0xFFFF
regulatory domain, not the PCI device ID being set to 0xFFFF (which
was also reported at times).

Given I NACK'd assuming this was a PCI device ID issue let me
elaborate on that possible issue for future's and record's sake and
also on your issue.

The eeprom_ops are a set of ops for different set of family of cards
we support. The correct eeprom_ops family of functions your card would
end up using will vary depending not only the PCI device ID to load
the driver but more importantly on the family ID on the EEPROM, see
ath9k_hw_eeprom_init() and ath9k_hw_read_revisions(), essentially
obtained through PCI iomem reads. If the EEPROM is messed up then the
wrong family of device would be set and there no point to support
these type of devices in kernel code, the way to work around these
issues would be at post load using sysfs, and that is why I jumped the
gun and NACKed thinking it was this type of issue.

In your case though you claim that only the EEPROM regulatory domain
is not being recognized as valid by the ath regd code, granted that
the driver does an EEPROM checksum check so if indeed that was the
intended EEPROM regd value programmed then the regd value was intended
to be that. Now, 0xFFFF is simply not a known regulatory domain that
we support and why it would be programmed as such is beyond me. It is
not something we support! Given that your card exists and likely
perhaps others (whoever programmed that card, not sure)... we can
indeed add support as you suggest by using the most restrictive world
regulatory domain as you have amended.

Apologies again and then (unless I hear otherwise from David Quan):

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

But please re-post and amend the commit log entry with information
that explain that given that your EEPROM must have been intentionally
programmed to 0xFFFF given that the EEPROM checksum is valid, but that
QCA does not support 0xFFFF as a valid regulatory domain value you are
adding support by using the 0x64 regulatory domain, the most
restrictive custom world regulatory domain by the ath module.

  Luis
