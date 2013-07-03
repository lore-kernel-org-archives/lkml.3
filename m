Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3GCQZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:25:46 -0400
Received: from nm12-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.126]:46503
	"EHLO nm12-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932966Ab3GCQZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:25:45 -0400
X-Yahoo-Newman-Id: 869959.332.bm@smtp104.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BQ0GWkAVM1kyLXqJZBfN5oPfuawj3CIZngpaXkuIlWAy5qt
 FGlGle2yKkpCpBH1DZWfc0Hh9Fx..2Kq3Ybc8WZ5pNd8IyMPhmIBvXjJV02r
 5Ov3oDzBDLjLFAOx.ymJQhbOl4.rafQ7.KpOQlXsbIkmtnYk3t1lBXfIZfFa
 DWeiqB1sQlL1Zn6.QIPyX7OukL2nN32EurwfIoDx8sLsVoIXUqRDNbnAa1o3
 B751uuGVYSCo3cDQbjyfoateCcgSzpasLk2fzVPGqQ02LoR8rVPuKBwnKczd
 27Q7Lzep27i0WIiyXWt4vQ9g7wcTJUO_DI5XT7.D2NlXx4nOPWinwoF_BKzm
 2PU5iAyoK9nwzxEWxknJI3VZmk2pIBZFxbtGdZ5Bi5tIRsvcR_i7Y3GCQ.yt
 fOQzLv0CLyXtDVOmP088yjZ52KLUcZWtxGJOfGIIV5mnTZUlrHaoOy55gToI
 4DK_QaQPiQkHdF.ZaajriCdkNLUwhROJUBLvPIjQL.6gOuUamEIiFzQuXExL
 TPwpH68dfuyfkrE10g6XdLrPXauhfscNawTKMuIlks_XusBXL656DXfT6pRd
 Pm8vAJjeN
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.gq1.yahoo.com with SMTP; 03 Jul 2013 09:25:43 -0700 PDT
Date: Wed, 3 Jul 2013 09:25:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: Intel HWMON/NIC temperature sensor question
Message-ID: <20130703162545.GA12506@roeck-us.net>
References: <002401ce77e9$da6524b0$8f2f6e10$@lucidpixels.com>
 <20130703144845.GB10323@roeck-us.net>
 <20130703170838.326894c6@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703170838.326894c6@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 05:08:38PM +0200, Jean Delvare wrote:
> On Wed, 3 Jul 2013 07:48:45 -0700, Guenter Roeck wrote:
> > 82575 and 82599. Doesn't matter much, though, since they don't export the "name"
> > attribute from their driver, meaning the sensors command won't find the sensors.
> > Also, they enerate the hwmon device first and then create the attributes, which
> > is the wrong order and creates a potential race condition with demons.
> 
> Yes and no. For devices which are only implementing hwmon features,
> hwmon is just a link and the attributes belong to the device. So we can
> create the attributes first and the hwmon device second.
> 
> However for devices which are primarily something else and only
> register a hwmon device as a side object, the hwmon attributes are
> attached to the hwmon class device and not the main device. In that
> case the hwmon device has to be created first and the attributes
> second. Yes, this is racy. The only clean way around it AFAIK is to
> implement all the attributes as proper class attributes rather than
> creating them manually - but it would take a whole redesign of the
> hwmon core module.
> 

Actually, there would be a simple solution. We can add an API call such as
hwmon_device_register_groups(), which in addition to passing the parent device
would also pass "struct attribute_groups **". It would have to create the device
manually instead of calling device_create(), but would add the groups to the
device structure prior to calling device_register(). The core device handling
code would then automatically create all attributes (and remove them later on).

We might even be able to convince the device core maintainers to let us add a
"device_register_groups()" API into the device core code.

Code itself should be straightforward. Worth a try ?

Guenter
