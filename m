Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaGANgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:36:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49838 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753191AbaGANgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:36:35 -0400
Date: Tue, 1 Jul 2014 14:36:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701133627.GP32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk> <53B2B5E5.50502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B2B5E5.50502@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:21:41PM +0200, Sebastian Hesselbarth wrote:
> On 07/01/2014 03:10 PM, Russell King - ARM Linux wrote:
>> On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
>>> +	pdev = platform_device_register_full(&armada_drm_dev_info);
>>> +	/* assign last found lcd node to drm device for clk lookup */
>>> +	pdev->dev.of_node = clknp;
>>
>> NAK.  This really isn't a good way to deal with this, even in a
>> temporary basis.  While assigning a DT node to a manually created
>> platform device does solve that problem, it also introduces the
>> problem that this platform device will now match any platform driver
>> which recognises the "marvell,dove-lcd" compatible type, which may
>> occur _before_ we find the driver to match using the legacy strings.
>
> Right, I never said it is a good solution but there is no driver for
> "marvell,dove-lcd" *and* there is no way to assign clock aliases for
> clocks not yet registered.

Now consider what happens when I get to push the updates which do add
that to David Airlie.

> Well, you may have noticed that three moving subsystems plus new
> bindings plus non-DT/DT drivers quickly create some kind of patch
> deadlock. This is a dirty but tiny step to resolve one of those
> deadlocks.

The deadlock only exists because it is impossible to get anyone to look
outside their own little world and review patches.  This is a growing
problem, and there's a growing number of articles and blogs on the
Internet about how kernel development now sucks rocks because of it.

Where do you get three moving subsystems from anyway?  There's the
component stuff and the DRM stuff - that's two subsystems.  The component
stuff is something which I maintain, but needs to go through Greg.  I'm
seriously thinking about just pushing those three patches to Greg in the
next few days.  Then I'll start talking to David about the rest of it.

The Armada DRM stuff shouldn't be a problem, but the TDA998x may end up
being so /if/ Jean-Francois decides to object to my approach there to
allow tilcdc to continue working with the driver... but then as I now
maintain that as well, that's not much of an issue because I can make
the decision to overrule that point.

>> The other problem in this series is that while you introduce some
>> bindings which may work today, they're not going to work tomorrow, and
>> that's a problem.  Don't do DT piecemeal like this and end up having to
>> break the bindings (which we will have to do to add the endpoints.)
>
> Adding new properties/subnodes never has been a problem for us at all.
> New generic bindings were introduced *often* in the past and added to
> existing bindings, e.g. clocks, gpio, pinctrl.
>
> The proposed binding for dove-lcd simply reflects the tiny part that
> is mandatory for identifying the lcd controllers. It only contains
> reg and interrupts which would also be in the corresponding
> platform_device.

There is a difference between augmenting an existing driver binding for
new features (such as adding a GPIO to allow a new platform to work) and
adding new bindings which are required becaues we've updated the driver.

The former adds a new feature but allows existing users to continue
working.  The latter adds a new feature which breaks existing users.
That's a problem.

In this case, it can be trivially avoided by adding all the properties
that we need right from the start.  We know what we need, and the
of_graph stuff is now established and in use by other DRM drivers.

Just because the existing driver may not make use of it is no excuse to
omit it - it's part of the description of how the hardware is connected,
it conforms to agreed methods to describe this connectivity, we know that
it works, and we know that the driver will need it in the very near future.

Omitting it now just results in additional pain later on that we can
avoid.

>> If you want to do this then you need to add the endpoints from the start
>> even though the driver doesn't yet make use of them - or don't add the
>> DT bits at all.
>
> If you really think that way, I definitely give up on mainline Dove and
> SolidRun Cubox. You are /really/ proposing to wait for *all* related
> subsystem bindings to settle before even starting to add DT support?

*Sigh*.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
