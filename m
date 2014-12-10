Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbaLJXT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:19:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362AbaLJXTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:19:49 -0500
Date: Wed, 10 Dec 2014 18:01:52 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: do not return the name length
Message-ID: <20141210230152.GC4861@mail.corp.redhat.com>
References: <1418250070-28604-1-git-send-email-benjamin.tissoires@redhat.com>
 <4561294.qneDZ51mgu@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4561294.qneDZ51mgu@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10 2014 or thereabouts, Peter Wu wrote:
> On Wednesday 10 December 2014 17:21:09 Benjamin Tissoires wrote:
> > We do not make any use of the actual name length get through
> > hidpp_get_device_name().
> > 
> > We can drop the extra code and simplify the API a bit.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >  drivers/hid/hid-logitech-hidpp.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index 1a6395d..3846305 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -461,7 +461,7 @@ static int hidpp_devicenametype_get_device_name(struct hidpp_device *hidpp,
> >  	return count;
> >  }
> >  
> > -static char *hidpp_get_device_name(struct hidpp_device *hidpp, u8 *name_length)
> > +static char *hidpp_get_device_name(struct hidpp_device *hidpp)
> >  {
> >  	u8 feature_type;
> >  	u8 feature_index;
> > @@ -484,7 +484,6 @@ static char *hidpp_get_device_name(struct hidpp_device *hidpp, u8 *name_length)
> >  	if (!name)
> >  		goto out_err;
> >  
> > -	*name_length = __name_length + 1;
> >  	while (index < __name_length)
> >  		index += hidpp_devicenametype_get_device_name(hidpp,
> >  			feature_index, index, name + index,
> 
> hidpp_devicenametype_get_device_name can return a non-positive value if
> the USB device is unplugged at the wrong time, or if a malicious device
> is attached (and 0 is returned). An infinite loop is the result.

Oh, yes, you are definitively right.

> 
> Can you apply this change in the patch or should I send you a separate
> one?

Feel free to send your patch directly to the list.

> 
> 	while (index < __name_length) {
> 		ret = hidpp_devicenametype_get_device_name(hidpp,
> 			feature_index, index, name + index,
> 			__name_length - index);
> 		if (ret <= 0) {
> 			kfree(name);
> 			return NULL;
> 		}
> 		index += ret;
> 	}
> 
> > @@ -493,7 +492,6 @@ static char *hidpp_get_device_name(struct hidpp_device *hidpp, u8 *name_length)
> >  	return name;
> >  
> >  out_err:
> > -	*name_length = 0;
> >  	return NULL;
> 
> What about dropping the label out_err here and returning NULL in the
> previous places?

Yep, good idea. You can either send a patch for that if you want to take
credits, or I can send a v2. It's up to you.

Cheers,
Benjamin

> 
> >  }
> >  
> > @@ -989,7 +987,6 @@ static void hidpp_overwrite_name(struct hid_device *hdev, bool use_unifying)
> >  {
> >  	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
> >  	char *name;
> > -	u8 name_length;
> >  
> >  	if (use_unifying)
> >  		/*
> > @@ -999,7 +996,7 @@ static void hidpp_overwrite_name(struct hid_device *hdev, bool use_unifying)
> >  		 */
> >  		name = hidpp_get_unifying_name(hidpp);
> >  	else
> > -		name = hidpp_get_device_name(hidpp, &name_length);
> > +		name = hidpp_get_device_name(hidpp);
> >  
> >  	if (!name)
> >  		hid_err(hdev, "unable to retrieve the name of the device");
> > @@ -1053,7 +1050,6 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
> >  	bool connected = atomic_read(&hidpp->connected);
> >  	struct input_dev *input;
> >  	char *name, *devm_name;
> > -	u8 name_length;
> >  
> >  	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> >  		wtp_connect(hdev, connected);
> > @@ -1080,7 +1076,7 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
> >  		return;
> >  	}
> >  
> > -	name = hidpp_get_device_name(hidpp, &name_length);
> > +	name = hidpp_get_device_name(hidpp);
> >  	if (!name) {
> >  		hid_err(hdev, "unable to retrieve the name of the device");
> >  	} else {
> > 
> 
