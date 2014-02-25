Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaBYI4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:56:18 -0500
Received: from canardo.mork.no ([148.122.252.1]:35478 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaBYI4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:56:17 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH] net/usb: Add Lenovo ThinkPad OneLink GigaLAN USB ID to ax88179 driver
Organization: m
References: <20140224234247.GB14970@merlin.infradead.org>
	<1393286176-32076-1-git-send-email-keithp@keithp.com>
Date: Tue, 25 Feb 2014 09:55:28 +0100
In-Reply-To: <1393286176-32076-1-git-send-email-keithp@keithp.com> (Keith
	Packard's message of "Mon, 24 Feb 2014 15:56:16 -0800")
Message-ID: <87txbnbmgv.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard <keithp@keithp.com> writes:

> Kyle McMartin says:
>
>>  &lenovo_info, surely.
>
> Yeah, Daniel Stone caught the same bug. Not a big deal; the only
> difference between any of these elements is the string produced by the
> kernel.

Yes, and that mess should really be cleaned up in this driver (and
probably others).

The .description field describes the *driver*, not the device.  The
device is described by the manufacturer, using the iManufacturer,
iProduct and iSerialstring descriptors, which the USB core takes care of
logging and storing.  There is absolutely no reason to add additional,
possibly conflicting, product descriptions in these drivers.

Some additional static data does of course not matter much, but the
additional code is really an unnecessary source of subtle bugs.  I'm
pretty sure the entry you copied has bugs in the .flags field
(ax88179_rx_fixup clones the skb and returns 1, which means that
FLAG_MULTI_PACKET should be set).  Keeping numerous copies of the exact
same driver definition is just waiting for someone to forget
syncronizing any fixups for such bugs.

I propose replacing samsung_info, lenovo_info and the other entries
differing only by description with a generic driver entry, and trust the
vendors to add the appropriate string descriptors to their devices.

The separate generic entries for USB2 and USB3 versions of the chip is
also more confusing than helpful IMHO, given that the driver really is
identical. I don't think it helps anyone to see "USB 3.0 Gigabit
Ethernet" reported if the adapter is connected to a USB 2.0 host and
vice versa.  Something lik "ASIX AX88179/178A" would do just fine as
description regardless of device ID.


Bjørn
