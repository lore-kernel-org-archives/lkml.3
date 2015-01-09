Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbbAIOOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:14:14 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:45011 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbbAIOOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:14:12 -0500
Message-ID: <54AFE22D.3010306@hurleysoftware.com>
Date: Fri, 09 Jan 2015 09:14:05 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com> <1896224.oMI8M6J5T7@wuerfel> <54AF6378.6030202@hurleysoftware.com> <3250953.b8pGJSWkfs@wuerfel>
In-Reply-To: <3250953.b8pGJSWkfs@wuerfel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 03:48 AM, Arnd Bergmann wrote:
> On Friday 09 January 2015 00:13:28 Peter Hurley wrote:
>> On 01/08/2015 05:05 PM, Arnd Bergmann wrote:
>>> On Thursday 08 January 2015 11:11:51 Peter Hurley wrote:
>>>>
>>>> This interface is just storage and minor allocation, since the
>>>> port-reuse behavior will be limited to the "universal" driver.
>>>> From a sub-driver perspective, the shared storage is actually
>>>> a hindrance, so that reduces the requirement to minor allocation.
>>>>
>>>> And that's where I'm stuck at the moment -- how to share ttyS
>>>> minor allocation. ttyS console is a related problem.
>>>
>>> One idea that has come up in the past but never saw an implementation
>>> is to make the ttyS namespace and minor numbers completely generic and
>>> let any serial port driver use it. This would be a major rework, but
>>> have the added advantage of cleaning up a number of other namespace
>>> issues as well. There also lots of open question, in particular how
>>> to maintain compatibility with existing drivers. One could imagine
>>> that each uart always gets a ttyS device and optionally also gets
>>> a device node for the same port with a driver specific chardev as
>>> most of them do today. Or it could be an either/or decision that is
>>> made at compile time or as a module parameter.
>>
>> I'm not totally convinced that sharing minor allocation is the right
>> solution. ISTM that the main goal is for at least one serial driver
>> to represent ttyS (assuming that it is a suitable work-alike to the
>> 8250 driver) while other ttyS serial drivers must still be able to
>> load and operate.
> 
> Unfortunately, we have already seen a case where we need to have
> two drivers enabled at the same time that both use the ttyS
> namespace and minor numbers at the moment.

Maybe you misunderstood me here. I'm suggesting that every ttyS-capable
driver would be able to load into a pre-determined, unique alternate
namespace. So at least one ttyS driver would be present, without naming
conflicts, and every other ttyS-conflicting driver would be loaded
in their respective alternate namespace.

Unless what you mean is there is some userspace requirement for the
ttyS namespace to be shared. If so, would you please expand on this use
case so I can better understand the requirements.

>> So for example, a UART that is ttyS in a typical configuration, might
>> be ttyX when another driver has been configured as ttyS instead.
>> Assuming that every uart driver has a unique, alternate base name,
>> then the problem is reduced to selecting the appropriate driver for
>> ttyS.
>>
>> Some use cases would require selecting the ttyS driver at build time.
>> Others would probably require the notion of a preferred driver.
> 
> Build-time selection looks problematic to me in the case of an
> ARM distro kernel that wants to support dozens of different
> uart drivers. At the moment this works for the most part because
> the conflicts are rare, but it's getting worse.

A dt property could indicate which uart is the preferred ttyS.


>> What got me thinking about this approach instead of sharing minor
>> allocation was based on the 'first-come, first-served' question
>> I asked back in Dec. What happens when probe order varies and
>> console=ttyS0/login prompt doesn't show up where it's supposed to?
>> I've had this experience with multiple ethernet adapters and it's
>> not fun.
> 
> In a lot of cases, we can solve the problem for a particular board
> by hardcoding the 'aliases' in the board specific dts file, at least
> when devicetree is used (as it is for the majority of the cases that
> are causing problems now).
> 
> Using the aliases correctly at the moment is really awkward when you
> have multiple drivers for uarts on the same system and your serial0
> and serial1 uart turn into ttyS0 and ttyX1.

I'm concerned that this will devolve into some attempt at a
persistent naming scheme from kernel-space; which has repeatedly been
shown in other subsystems to be fruitless. That was my point about
the ethernet adapters.

I have no problem sequentially numbering uarts as ttyS, but it would
suck if that amount of work ultimately proved useless, when udev rules
would have sufficed or became necessary anyway.

Regards,
Peter Hurley

