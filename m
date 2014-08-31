Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaHaE6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 00:58:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaHaE6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 00:58:06 -0400
Date: Sun, 31 Aug 2014 06:58:01 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "m.chehab" <m.chehab@samsung.com>, hans.verkuil@cisco.com,
        felipensp@gmail.com, mkrufky@linuxtv.org, crazycat69@narod.ru,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: randconfig build error with next-20140829, in
	drivers/media/usb/dvb-usb/technisat-usb2.c
Message-ID: <20140831045801.GL3347@wotan.suse.de>
References: <CA+r1ZhhfV+fLKY6X0fp2QevQGZMx4g=okSeZjPN9Z3LZJqykGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1ZhhfV+fLKY6X0fp2QevQGZMx4g=okSeZjPN9Z3LZJqykGg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 09:19:42AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `technisat_usb2_set_voltage':
> technisat-usb2.c:(.text+0x3b4919): undefined reference to `stv090x_set_gpio'
> make: *** [vmlinux] Error 1

This is because MEDIA_SUBDRV_AUTOSELECT is designed to let you
pick and choose, technically we should just have:

diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index c5d9566..5a4e82e 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -313,7 +313,7 @@ config DVB_USB_AZ6027
 config DVB_USB_TECHNISAT_USB2
 	tristate "Technisat DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
-	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV090x
 	select DVB_STV6110x if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Technisat USB2 DVB-S/S2 device

and that would fix the issue you saw but then again if we do that
we might as well also do the same for DVB_STV6110x and a slew of
different Kconfig entries on that file.

Someone needs to make a judgement call and either fix all these
Kconfig entries or document that MEDIA_SUBDRV_AUTOSELECT will
let you shoot yourself in the foot at build time. Then what
I recommend in the meantime is simply to not trust randomconfig
builds unless you are always enabling MEDIA_SUBDRV_AUTOSELECT.

I think its fair to expect for 'make randomconfig' to give you
a configuration that lets you build things without issue so
I see this more of an issue with MEDIA_SUBDRV_AUTOSELECT and
this sloppy embedded craze.

  Luis
