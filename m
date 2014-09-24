Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaIXO01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:26:27 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:56665 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:26:25 -0400
X-ASG-Debug-ID: 1411568543-0759e70b73a2810002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Wed, 24 Sep 2014 16:22:22 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] sbs-battery: add forced instantiation from
 device tree
Message-ID: <20140924142222.GC22872@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [RFC PATCH 1/2] sbs-battery: add forced instantiation from
 device tree
References: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
 <1411564278-17207-2-git-send-email-frans.klaver@xsens.com>
 <20140924131655.GG5729@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140924131655.GG5729@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411568544
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9826
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 02:16:55PM +0100, Mark Rutland wrote:
> On Wed, Sep 24, 2014 at 02:11:17PM +0100, Frans Klaver wrote:
> > In some cases you want to instantiate a battery even before it is
> > attached; it is perfectly reasonable for a device to start up on
> > wall-power and be connected to a battery later. The current advice is to
> > instantiate a device explicitly in the kernel, or probe for the device
> > from userspace. The downside of these approaches is that the user needs
> > to keep the information related to the i2c battery in different places,
> > which is inconvenient.
> 
> This really sounds like a Linux policy issue rather than something that
> should be described in dt.
> 
> Presumably there's a reason we sanity cehck this in the first place.
> What happens while the battery isn't plugged in? What can fail, and how?

It was introduced in a22b41a31e53 "sbs-battery: Probe should try talking
to the device", saying:

  "this driver doesn't actually try talking to the device at probe time,
  so if it's incorrectly configured in the device tree or platform data
  (or if the battery has been removed from the system), then probe will
  succeed and every access will sit there and time out. The end result
  is a possibly laggy system that thinks it has a battery but can never
  read status, which isn't very useful."

That's a reasonable thing to do, but it breaks just the feature I need.
Besides that, the driver provides us with a gpio that indicates battery
presence, which will also be useless if the device isn't present at
probe time. That commit also doesn't take into account the fact that a
battery could be removed after probing without any problems, leaving the
system in the same state as before the probe change.

Now if the battery isn't plugged in, it is never detected after it has
been attached, unless you take action from userspace. Basically you
don't know your battery level until it has been explicitly probed.

We might also reduce the severity of the sanity check failure to produce
a warning instead of an error. This would achieve that a developer might
be warned that the battery isn't present, but also allow my use case
where the battery may not be present at boot time. Was that what you
meant with policy by the way?

> 
> > Add the "sbs,always-present" option to the device tree. If set, the
> > battery is instantiated without sanity checking the connection.
> 
> From the description above, this name is incorrect. You're adding this
> property to work around the battery _not_ being present at probe-time.
> From a binding point of view, "instantiated" is somewhat meaningless --
> that's an OS level detail rather than a contract detail.

That's fair. I wasn't entirely sure of the name myself, so feel free to
suggest some other names. It started out with "sbs,force-presence", but
I would be just as happy using "sbs,always-register",
"sbs,no-sanity-check" or something entirely different altogether.

If we go with the downgrade of the status read error, the device tree
requirement will be removed entirely.

Thanks,
Frans
