Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3LJM2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:28:41 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:65163 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3LJM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:28:40 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2013 07:28:39 EST
From: "duson" <dusonlin@emc.com.tw>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
References: <1386557990-27445-1-git-send-email-dusonlin@emc.com.tw> <20131209063213.GA30195@core.coreip.homeip.net>
Subject: RE: [PATCH] Add: (1) Detection for newer Elantech touchpads, so that kernel doesn't fall-back to default PS/2 driver. (2) Enable hardware version 4 touchpad right click function.
Date: Tue, 10 Dec 2013 20:18:27 +0800
Message-ID: <4ECEF6F14711446F8898D966AC39E54E@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac70qGz05Gm8TgRSR0ezdyFqzfR/cwA5AH/w
In-Reply-To: <20131209063213.GA30195@core.coreip.homeip.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
[mailto:linux-input-owner@vger.kernel.org]
> On Behalf Of Dmitry Torokhov
> Sent: Monday, December 09, 2013 2:32 PM
> To: Duson Lin
> Cc: linux-kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH] Add: (1) Detection for newer Elantech touchpads, so
that
> kernel doesn't fall-back to default PS/2 driver. (2) Enable hardware
version 4
> touchpad right click function.
> 
> Hi Duson.
> 
> 
> On Mon, Dec 09, 2013 at 10:59:50AM +0800, Duson Lin wrote:
> > Modify:
> > (1) crc_enabled only support for v3 and v4 touchpad, so initialize
crc_enabled as
> false first and
> > check this hardware flag when hw_version as 3 or 4.
> 
> It looks to me there are several fixes rolled up together in this patch:
> 
> 1. Support for the new hardware signatures (8 and 10, although I already
> applied patch for 8)
> 2. Fix to handle CRC check
> 3. Changes to report BTN_RIGHT.
> 
> Could you please split them up please?
OK, I will split them up.

> 
> Also, I am not sure if we can simply start reporting BTN_RIGHT as
> present, even on devices that don't actually have the right button, as
> this will interfere with userspace providing emulation for multiple
> buttons.
> 
> Is it possible to determine if a given model had right button or not?
It is hard to determine if a given model had right button, but depend on
per-discuss in Hans de Goede's mailing list, it is possible to determine if
given model need right click function.
Thanks.
Duosn 

> 
> >
> > Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
> > ---
> >  drivers/input/mouse/elantech.c |   30 ++++++++++++++----------------
> >  drivers/input/mouse/elantech.h |    2 +-
> >  2 files changed, 15 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/input/mouse/elantech.c
b/drivers/input/mouse/elantech.c
> > index 8551dca..b3627cf 100644
> > --- a/drivers/input/mouse/elantech.c
> > +++ b/drivers/input/mouse/elantech.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Elantech Touchpad driver (v6)
> > + * Elantech Touchpad driver (v7)
> >   *
> >   * Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
> >   *
> > @@ -486,6 +486,7 @@ static void elantech_input_sync_v4(struct psmouse
> *psmouse)
> >  	unsigned char *packet = psmouse->packet;
> >
> >  	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
> > +	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
> >  	input_mt_report_pointer_emulation(dev, true);
> >  	input_sync(dev);
> >  }
> > @@ -1047,9 +1048,7 @@ static int elantech_set_input_params(struct
psmouse
> *psmouse)
> >  			 */
> >  			psmouse_warn(psmouse, "couldn't query resolution
data.\n");
> >  		}
> > -		/* v4 is clickpad, with only one button. */
> >  		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
> > -		__clear_bit(BTN_RIGHT, dev->keybit);
> >  		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> >  		/* For X to recognize me as touchpad. */
> >  		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
> > @@ -1186,19 +1185,12 @@ static struct attribute_group
elantech_attr_group = {
> >
> >  static bool elantech_is_signature_valid(const unsigned char *param)
> >  {
> > -	static const unsigned char rates[] = { 200, 100, 80, 60, 40, 20, 10
};
> > -	int i;
> > -
> >  	if (param[0] == 0)
> >  		return false;
> >
> >  	if (param[1] == 0)
> >  		return true;
> >
> > -	for (i = 0; i < ARRAY_SIZE(rates); i++)
> > -		if (param[2] == rates[i])
> > -			return false;
> > -
> >  	return true;
> >  }
> >
> > @@ -1298,6 +1290,14 @@ static int elantech_set_properties(struct
> elantech_data *etd)
> >  {
> >  	/* This represents the version of IC body. */
> >  	int ver = (etd->fw_version & 0x0f0000) >> 16;
> > +	/*
> > +	 * The signatures of v3 and v4 packets change depending on the
> > +	 * value of this hardware flag. But the v1 and v2 have not crc
> > +	 * check mechanism and the same hardware flag are also defined
> > +	 * as other function. So crc_enabled must be initialized as false
> > +	 * first and checking by different hw_version.
> > +	 */
> > +	etd->crc_enabled = false;
> >
> >  	/* Early version of Elan touchpads doesn't obey the rule. */
> >  	if (etd->fw_version < 0x020030 || etd->fw_version == 0x020600)
> > @@ -1309,10 +1309,14 @@ static int elantech_set_properties(struct
> elantech_data *etd)
> >  			etd->hw_version = 2;
> >  			break;
> >  		case 5:
> > +			etd->crc_enabled = ((etd->fw_version & 0x4000) ==
0x4000);
> >  			etd->hw_version = 3;
> >  			break;
> >  		case 6:
> >  		case 7:
> > +		case 8:
> > +		case 10:
> > +			etd->crc_enabled = ((etd->fw_version & 0x4000) ==
0x4000);
> >  			etd->hw_version = 4;
> >  			break;
> >  		default:
> > @@ -1343,12 +1347,6 @@ static int elantech_set_properties(struct
> elantech_data *etd)
> >  			etd->reports_pressure = true;
> >  	}
> >
> > -	/*
> > -	 * The signatures of v3 and v4 packets change depending on the
> > -	 * value of this hardware flag.
> > -	 */
> > -	etd->crc_enabled = ((etd->fw_version & 0x4000) == 0x4000);
> > -
> >  	return 0;
> >  }
> >
> > diff --git a/drivers/input/mouse/elantech.h
b/drivers/input/mouse/elantech.h
> > index 036a04a..c963ac8 100644
> > --- a/drivers/input/mouse/elantech.h
> > +++ b/drivers/input/mouse/elantech.h
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Elantech Touchpad driver (v6)
> > + * Elantech Touchpad driver (v7)
> >   *
> >   * Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
> >   *
> > --
> > 1.7.10.4
> >
> 
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

