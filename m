Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaFKPau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:30:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56801 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaFKPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:30:47 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 11 Jun 2014 17:30:05 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: jkosina@suse.cz, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v3] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140611153005.GI10256@localhost>
References: <CAEEjW06BnCiLyDDL82fjhFtwg5LyaGzKP+swzLFNKKwmZcvViQ@mail.gmail.com>
 <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
 <20140611140542.GG10256@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611140542.GG10256@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:05:42PM +0200, Johan Hovold wrote:
> On Wed, Jun 11, 2014 at 12:21:39AM +0300, Janne Kanniainen wrote:

> > +static const char gt683r_led_select_leds[GT683R_BUFFER_SIZE] = { 0x01, 0x02, 0x30, 0x00,
> > +								 0x00, 0x00, 0x00, 0x00 };
> > +static const char gt683r_led_select_type[GT683R_BUFFER_SIZE] = { 0x01, 0x02, 0x20, 0x00,
> > +								 0x01, 0x00, 0x00, 0x00 };
> 
> 80 char limit.
> 
> Perhaps move these to gt683r_led_set, which is the only place where they
> are used?

Or, as I hinted earlier, just allocate the 8-byte buffer using kzalloc
and only initialise the non-zero bytes directly. The first byte should
be the report id (0x01). I noticed that some hid-drivers use this fact
when sending the raw request (see below).

> > +
> > +static void gt683r_brightness_set(struct led_classdev *led_cdev,
> > +				  enum led_brightness brightness)
> > +{
> > +	struct gt683r_led *led =
> > +			container_of(led_cdev, struct gt683r_led, led_dev);
> > +
> > +	led->brightness = brightness;
> > +
> > +	schedule_work(&led->work);
> > +}
> > +
> > +static int gt683r_led_snd_msg(struct gt683r_led *led, char *msg)
> > +{
> > +	int ret;
> > +
> > +	ret = hid_hw_raw_request(led->hdev, 0x01, msg, GT683R_BUFFER_SIZE,
> > +				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);

That is, you could use msg[0] here instead of 0x01.

> > +	if (ret < 0) {
> > +		hid_err(led->hdev,
> > +			"failed to send set report request: %i\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}

Johan
