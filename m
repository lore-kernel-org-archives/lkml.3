Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaB0WD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:03:26 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:56120 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751255AbaB0WDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:03:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140227213427.GG5375@saruman.home>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
	<1393524848-8207-2-git-send-email-lho@apm.com>
	<20140227190102.GB4862@saruman.home>
	<CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
	<20140227205039.GE5375@saruman.home>
	<CAPw-ZT=7cu1NoxrBL48RUJV04ofrnNkF=p=23VFfu8ZZWmkQWQ@mail.gmail.com>
	<20140227213427.GG5375@saruman.home>
Date: Thu, 27 Feb 2014 14:03:21 -0800
Message-ID: <CAPw-ZT=6cF77FjVZhXkR4thvkoxDH=aEikoDQjcpskMXE+F8OA@mail.gmail.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY framework
From: Loc Ho <lho@apm.com>
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>,
        "patches@apm.com" <patches@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

>> >> >> This patch adds function set_speed to the generic PHY framework operation
>> >> >> structure. This function can be called to instruct the PHY underlying layer
>> >> >> at specified lane to configure for specified speed in hertz.
>> >> >
>> >> > why ? looks like clk_set_rate() is your friend here. Can you be more
>> >> > descriptive of the use case ? When will this be used ?
>> >> >
>> >>
>> >> The phy_set_speed is used to configure the operation speed of the PHY
>> >> at run-time. The clock interface in general is used to configure the
>> >> clock input to the IP. I don't believe they are the same thing. Maybe
>> >> it will be clear in my response to your second email
>> >
>> > The problem with this is that you end up adding SATA-specific details to
>> > something which is supposed to be generic.
>>
>> Setting the operation speed is pretty generic from an interface point
>> of view. An generic multi-purpose PHY can support multiple speed. If
>
> no it's not. Specially when you consider that your "speed" argument can
> be just about anything and depending on the underlying bus, it *will* be
> treated differently. Note that e.g. in OMAP devices the exact *same* PHY
> IP is used for PCIe, SATA and USB... now, let's assume for the sake of
> argument that we were to implement ->set_speed() in that environment,
> how do you plan to do that ? a 6MHz arguments isn't valid from USB stand
> point and could mean different things in PCIe or SATA.
>

Correct me if I am wrong here. If the same PHY is used for PCIe, SATA,
and USB, would you not need to indicate what speed the PHY should be
operated at - unless the underlying IP magically negotiate and
configured automatically? If so, what about PHY isn't so intelligent?
How should you suggest that we handle these?

>> the upper layer wish to operate at an specified speed (say for testing
>> purpose and etc), it can be allowed.
>
> anything for testing purposes, should be limited to test scenarios.

Testing purpose is only one use case. Another use case is to limit the
speed so that I can confirm the driver actually works with various
speed of the device and handle correctly.

>
>> > After negoatiation, don't you
>> > get any interrupt from your PHY indicating that link speed negotiation
>> > is done ? Or is that IRQ only on AHCI IP ?
>>
>> There is NO interrupt from the PHY. The IRQ is assoicated with the
>> AHCI IP. With SATA host flow, it starts off with an COMRESET to start
>> the link negotiation. At that point, it will poll for completion.
>>
>> Any other concerns?
>
> hey, calm down... just trying to prevent us from applying something
> which isn't truly generic and I don't think "->set_speed" is generic
> enough. The semantics of the "speed" argument won't be valid for all use
> cases.
>
> I can already see people using that to pass
> USB_SPEED_{LOW,FULL,HIGH,SUPER}, instead of actual speed numbers. We wil
> end up with a mess to handle from a PHY driver, specially in cases such
> as OMAP where, as mentioned above, the same IP is used for SATA, PCIe
> and USB3.
>

This PHY isn't as "intelligent" as other PHY's. What would you suggest
as I need an method to indicate to the underlying PHY that I want to
operate at an specified speed?

-Loc
