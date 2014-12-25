Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaLYPTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 10:19:49 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34598 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaLYPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 10:19:46 -0500
Message-ID: <549C2B0D.1000607@gmail.com>
Date: Thu, 25 Dec 2014 16:19:41 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Evgeni Dobrev <evgeni@studio-punkt.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] add support for Seagate BlackArmor NAS220
References: <20141215203855.GA28940@anne> <20141222125750.GA29163@anne> <549C0C3C.8060601@gmail.com> <20141225133109.GI19265@lunn.ch> <549C1465.6030909@gmail.com> <20141225141240.GJ19265@lunn.ch>
In-Reply-To: <20141225141240.GJ19265@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.12.2014 15:12, Andrew Lunn wrote:
>>> Hi Sebastian
>>>
>>> I'm not sure what you mean here. The binding Documentation says:
>>
>> I was hoping that using phys/phy-names would allow us to get rid of
>> nr-ports property. I haven't checked the corresponding code and likely
>> will not before next year, but we should try to get rid of the nr-ports
>> property completely.
>>
>>> Required Properties:
>>> - compatibility : "marvell,orion-sata" or "marvell,armada-370-sata"
>>> - reg           : Address range of controller
>>> - interrupts    : Interrupt controller is using
>>> - nr-ports      : Number of SATA ports in use.
>>>
>>> Optional Properties:
>>> - phys          : List of phandles to sata phys
>>> - phy-names     : Should be "0", "1", etc, one number per phandle
>>>
>>> The optional phys/phy-names have just been added to
>>> kirkwood-6192.dtsi.
>>
>> Yeah, saw that patch after the review.. and my understanding of the
>> phys/phy-names properties is that
>> (a) they allow to count the number of _available_ ports
>> (b) they allow to determine the number of _used_ ports
>> (c) they allow to e.g. disable port 0 but enable port 1
>>
>> while nr-ports only allows (a). You can derive (b) only if you use
>> the first out of two but you cannot do (c) with nr-ports.
>>
>> Which is why we introduced the phys/phy-names properties.
>
> We introduced them for turning the phys on and off.

Actually, the main reason was to turn the unused phys off. IIRC,
just reducing nr-ports from 2 to 1 allowed the SATA driver to skip
the second port, but left the PHY up and running. It also doesn't
allow to disable the first port and keep the second up.

Using phys/phy-names now allows a more detailed description by having
three devices (SATA + 2 PHY nodes), e.g. SATA controller with 2
potential ports, port 0 unconnected, port 1 connected. PHY0 will be
auto-disabled after device probe, PHY1 will be enabled by SATA driver.

IIRC, this is the setup used by Guruplug, where port1 is connected to
eSATA while port0 is unconnected.

> We don't do any derivation from this information. It is the same for
> all devices, since it is in the kirkwood-*.dtsi file, not per board.
>
> Also, orion5x does not allow such control of the phys, they are always
> on. So i don't know if we can derive anything from this information,
> since it is not always present.

Ok, you made me look it up in the code ;)

AFAIKS, nr-ports is only used for preallocating SATA host, clks, and
phys structs. The code logic implies that #phys/clk has to match
nr-ports property anyway. Unfortunately, n_ports variable and
hpriv->n_ports is mangled irritatingly often in current sata_mv.c.

What I was proposing (hoping we already do) is: remove the redundant
information passed by nr-ports were we can, e.g. count the number of
clocks/phys passed instead of reading nr-ports property.

I do understand that Orion5x neither has clocks nor phys on SATA so
we may either stick with nr-ports there or add fake (&tclk) clocks
instead.

Anyway, for this patch, I agree it could stay the way it is.

Sebastian

