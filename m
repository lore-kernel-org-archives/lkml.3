Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaACJ0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:26:15 -0500
Received: from canardo.mork.no ([148.122.252.1]:60598 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaACJ0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:26:11 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: hayeswang <hayeswang@realtek.com>
Cc: <oliver@neukum.org>, <netdev@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
Organization: m
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com>
	<1388633110-1435-1-git-send-email-hayeswang@realtek.com>
	<877gai8nqu.fsf@nemi.mork.no>
	<605671F106F540BA9665A195CACB78A0@realtek.com.tw>
Date: Fri, 03 Jan 2014 08:49:46 +0100
In-Reply-To: <605671F106F540BA9665A195CACB78A0@realtek.com.tw>
	(hayeswang@realtek.com's message of "Fri, 3 Jan 2014 10:56:02 +0800")
Message-ID: <8738l58pyd.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> writes:

>  Bjørn Mork [mailto:bjorn@mork.no] 
>> Sent: Thursday, January 02, 2014 10:25 PM
>> To: Hayeswang
>> Cc: oliver@neukum.org; netdev@vger.kernel.org; nic_swsd; 
>> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
>> Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
>> 
> [...]
>> > +#if defined(CONFIG_USB_RTL8152) || 
>> defined(CONFIG_USB_RTL8152_MODULE)
>> > +/* Samsung USB Ethernet Adapters */
>> > +{
>> > +	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 
>> 0xa101, USB_CLASS_COMM,
>> > +			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
>> > +	.driver_info = 0,
>> > +},
>> > +#endif
>> 
>> 
>> We don't play the if-other-driver-is-enabled for any other of the
>> blacklisted devices, including other devices supported by the RTL8152
>> driver.  Why do we need it here?
>
> The USB nic have two configurations. One is the config 2 which is the ECM
> mode and uses the driver of cdc_ether. The other is the config 1 which use
> the driver of r8152.

Sorry, but then this makes even less sense.  The active USB
configuration is user selectable and you should make any of them work if
possible.  Why can't the drivers figure out this at runtime?

> When the dangle is plugged, I find the configuration
> is 2 and the ECM driver would be loaded.

The USB core will normally select cfg #1, but prefers classful
configurations over vendor-specific ones.  It will loop through all
possible configurations looking at the first interface of each of them,
and then select the first one with a class different from 0xff.

So what you write above indicates that the first interface of cfg #1 is
vendor specific.  But this doesn't seem to match the r815x driver, so I
don't quite understand the layout here.

In any case, if your device provides two _different_ functions in
different configurations, but using the exact class, subclass and
protocol, then I'd call that device buggy.  If at least one of these are
different, then it shouldn't be a problem making the respective drivers
match these functions.

> By this way, you could select
> which mode you want to run. Some people would select ECM mode for
> performance, and the other would select r8152 for power saving.

Build time driver selection is useless. All distros will enable all
drivers. End users don't build kernels.  That ended sometime around the
release of Linux 2.2


Bjørn
