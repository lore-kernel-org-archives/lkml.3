Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaJXQTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:19:36 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:48745 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaJXQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:19:33 -0400
Date: Fri, 24 Oct 2014 09:19:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
Message-ID: <20141024161919.GA29600@roeck-us.net>
References: <1414037002-25528-7-git-send-email-linux@roeck-us.net>
 <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
 <54488CE1.2000106@roeck-us.net>
 <20141023134706.GB25190@lunn.ch>
 <20141023162754.GA21343@roeck-us.net>
 <20141023165459.GE25190@lunn.ch>
 <20141023173847.GA22988@roeck-us.net>
 <20141023180357.GG25190@lunn.ch>
 <20141023184322.GA24281@roeck-us.net>
 <20141023195526.GH25190@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141023195526.GH25190@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.544A7C14.02EC,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:55:26PM +0200, Andrew Lunn wrote:
> On Thu, Oct 23, 2014 at 11:43:22AM -0700, Guenter Roeck wrote:
> > On Thu, Oct 23, 2014 at 08:03:57PM +0200, Andrew Lunn wrote:
> > > > No, I am not saying that. The hwmon device's parent device will tell,
> > > > which is how it works for all other hwmon devices.
> > > 
> > > O.K, so parent is important.
> > > 
> > > > Not really. Again, the parent device provides that information. libsensors,
> > > > which is the preferred way of accessing sensors information from user space,
> > > > provides the parent device instance as part of the logical sensor device
> > > > name. In this case, the names will end up being dsa-isa-0000, dsa-isa-0001,
> > > > and so on. With your added tags it would be dsa.0.0-isa-0000, dsa.0.1-isa-0001,
> > > > and so on. I don't see how this would add any value.
> > > 
> > > isa is the name of the ethernet device? Why is it not eth0? Most
> > 
> > isa is just an internal name made up by libsensors, and pretty much just
> > indicates something like "neither i2c nor spi". It is mostly historic,
> > but nowadays almost part of the ABI. It is made up by user space,
> > based on the parent device type, not by the kernel.
> 
> So for DSA, since it is not i2c or spi, the parent is actually
> irrelevant, because libsensor ignores it and says "IsSomethingAlien".
> So the name alone needs to identify it.
> 
>  > You have convinced me that 'dsa' as hwmon attribute name is insufficient,
> > so let's see what we have.
> > 
> > - the parent network device in dst->master_netdev
> > - the dsa device in 'parent'
> > - the host device in host_dev
> > - the switch index in 'index'
> > 
> > First question is what should be the parent device.
> 
> Does it even matter, given the observation above?  I would probably go
> for dsa, since as you said, the Ethernet device may have a temperature
> sensor of its own. DSA is a virtual device...
> 
> > Second is what to choose for the hwmon device 'name' attribute.
> > 'dsa' is not sufficient, but what to choose instead ? dsa.X or dsa_X,
> > where X is the switch index ? At this point I am open to suggestions.
> > Note that we can not use the name returned from the switch probe
> > functions as it may contain spaces and other invalid characters.
> > Including the ethernet device name (eg as in eth0_dsa_0) may also be
> > problematic if it can contain '-', which is illegal for hwmon devices.
> 
> Does hwmon offer a function to sanitise a string?
> 
> The switch index definitely should be used and i would probably
> combine that with a sanitised version of the ethernet device name and
> "dsa".
> 
Here is another naming option:

em1dsa0-virtual-0
Adapter: Virtual device
temp1:        +52.0°C  (high = +100.0°C)

I think I'll go with that one. I get it by not specifying
a parent device when registering with the hwmon subsystem.
It is kind of similar to the thermal sensor data reported
through acpi.

acpitz-virtual-0
Adapter: Virtual device
temp1:        +52.0°C  (crit = +111.0°C)
temp2:        +52.0°C  (crit = +111.0°C)

Guenter
