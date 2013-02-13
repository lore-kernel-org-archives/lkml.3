Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab3BMUrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:47:13 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49220 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3BMUrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:47:11 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
In-Reply-To: <5115F076.5000909@synopsys.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com> <1357885223-19243-5-git-send-email-vgupta@synopsys.com> <20130208230127.5F3063E2C27@localhost> <5115F076.5000909@synopsys.com>
Date: Wed, 13 Feb 2013 20:47:07 +0000
Message-Id: <20130213204707.1AC143E3557@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2013 12:15:10 +0530, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> On Saturday 09 February 2013 04:31 AM, Grant Likely wrote:
> > On Fri, 11 Jan 2013 11:50:23 +0530, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> >> +- clock-frequency	: the input clock frequency for the UART
> >> +- baud			: baud rate for UART
> > change 'baud' to 'current-speed'. There is already precedence for this
> > with other serial devices.
> 
> While I'm OK with this - I can only see of_serial.c following the rule :-)
> More importantly I'm not clear about the logistics of this fix. Obviously this has
> a bearing on DT files in arch/arc/boot/*. So are such changes (platform + driver)
> routed thru the subsystem tree or the arch tree or bits from both with
> bisectability not considered - which feels wrong. We have to also consider the
> fact that Greg has closed the tty/serial for 3.9. So while I have no objection to
> your comment, it seems that the it needs to wait till 3.9-rc1 - or is there an
> alternate way.

I would consider it a bug fix. The binding isn't what it should be and
it needs to be addressed before appearing in a released kernel. If this
patch has already been merged, then write and post a fixup patch.

> >
> >> @@ -673,8 +693,18 @@ static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
> >>  static int arc_serial_probe(struct platform_device *pdev)
> >>  {
> >>  	int rc, dev_id;
> >> +	struct device_node *np = pdev->dev.of_node;
> >> +
> >> +	/* no device tree device */
> >> +	if (!np)
> >> +		return -ENODEV;
> > This breaks non-DT users. Is this what you intend? It creates a flag day
> > where users have to switch from non-DT to DT cold-turkey.
> 
> Not supporting non-DT user was not the idea - it just simplifies the code a bit
> given that it would only even be runtime used in a ARC Linux port based platform -
> which unconditionally enables OF.  Further - the ARC port itself is not yet
> upstream so there are no "official" user of this in tree driver.
> FWIW, ARC Linux port was recently reviewed on lkml/arch mailing lists and is now
> in linux-next for a possible 3.9 merge.

If there are no users, then nobody is broken. If this driver only
supports DT platforms then my comment can be ignored.

> >> +	dev_id = of_alias_get_id(np, "serial");
> >> +	if (dev_id < 0) {
> >> +		dev_err(&pdev->dev, "failed to get alias id: %d\n", dev_id);
> >> +		return dev_id;
> >> +	}
> > Don't fail on this. If you can't get an id then choose one dynamically.
> 
> You mean just assume 0.

No, I mean dynamically assign an ID from ids that are available. Say you
had two of these devices in a system, and neither had an alias; they
couldn't both be '0'.  :-)

g.

> 
> Thanks for reviewing.
> -Vineet

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
