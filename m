Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaJWQ2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:28:13 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:57147 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaJWQ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:28:10 -0400
Date: Thu, 23 Oct 2014 09:27:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
Message-ID: <20141023162754.GA21343@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
 <1414037002-25528-7-git-send-email-linux@roeck-us.net>
 <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
 <54488CE1.2000106@roeck-us.net>
 <20141023134706.GB25190@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023134706.GB25190@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.54492C99.02B5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Oct 23, 2014 at 03:47:06PM +0200, Andrew Lunn wrote:
> > >>+static DEVICE_ATTR_RO(temp1_input);
> > >
> > >You probably want the number of temperature sensors to come from the
> > >switch driver, and support arbitrary number of temperature sensors?
> > 
> > In that case we would need the number of sensors, pass a sensor index,
> > and create a dynamic number of attributes. The code would get much more
> > complex without real benefit unless there is such a chip 
> 
> We are two different use cases here:
> 
> One switch chip with multiple temperature sensors

I understand this case. However, quite frankly, I consider this quite
unlikely to happen.

> Multiple switch chips, each with its own temperature sensor.
> 
I don't really see the problem. My understanding is that each of those
switch chips will instantiate itself, dsa_switch_setup will be called,
which will create a new hwmon device with its own sensors. That is
how all other hwmon devices do it, and it works just fine.
Why would that approach not work for switches in the dsa infrastructure ?
Am I missing something ?

If the concern or assumption is that there can not be more than one
"temp1_input" attribute, here is an example from a system with a large
number of chips with temperature sensors.

root@evo-xb49:/sys/class/hwmon# ls hwmon*/temp1_input
hwmon1/temp1_input   hwmon22/temp1_input  hwmon35/temp1_input
hwmon10/temp1_input  hwmon23/temp1_input  hwmon36/temp1_input
hwmon11/temp1_input  hwmon24/temp1_input  hwmon37/temp1_input
hwmon12/temp1_input  hwmon25/temp1_input  hwmon38/temp1_input
hwmon13/temp1_input  hwmon26/temp1_input  hwmon39/temp1_input
hwmon14/temp1_input  hwmon27/temp1_input  hwmon4/temp1_input
hwmon15/temp1_input  hwmon28/temp1_input  hwmon40/temp1_input
hwmon16/temp1_input  hwmon29/temp1_input  hwmon5/temp1_input
hwmon17/temp1_input  hwmon3/temp1_input   hwmon6/temp1_input
hwmon18/temp1_input  hwmon30/temp1_input  hwmon7/temp1_input
hwmon19/temp1_input  hwmon31/temp1_input  hwmon8/temp1_input
hwmon2/temp1_input   hwmon32/temp1_input  hwmon9/temp1_input
hwmon20/temp1_input  hwmon33/temp1_input
hwmon21/temp1_input  hwmon34/temp1_input

There are 6xDS1625, 11xDS1721, 1xLM95234, 4xMAX6697, and 17xLTC2978
in this system if I counted correctly. That doesn't mean that the
drivers need to do anything special for their multiple instances.
Also, the "name" of each instance does not have to be unique.
The "name" reflects the driver name, not its instance.

root@evo-xb49:/sys/class/hwmon# grep . */name | grep max
hwmon20/name:max6697
hwmon21/name:max6697
hwmon22/name:max6697
hwmon23/name:max6697

> I don't know of any hardware using either of these uses cases, but
> they could appear in the future.
> 
> If we are not doing the generic implementation now, how about avoiding
> an ABI break in the future, by hard coding the sensors with .0.0 on
> the end?

I am a little lost. What would that be for, and what would the ABI breakage
be ?

Thanks,
Guenter
