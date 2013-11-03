Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3KCMgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:36:32 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:36702 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3KCMga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:36:30 -0500
Date: Sun, 3 Nov 2013 13:36:21 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kbuild-all@01.org
Subject: Re: [next:master 23/358] undefined reference to `i2c_add_adapter'
Message-ID: <20131103123621.GA9756@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
	jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org
References: <5275bf42.KMmrPUiia86VoRbL%fengguang.wu@intel.com>
 <20131103120853.GA1731@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131103120853.GA1731@localhost>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu, le Sun 03 Nov 2013 20:08:53 +0800, a écrit :
> It's a bug fix that unveils the link errors.
> 
>    drivers/built-in.o: In function `__input_unregister_device':
>    input.c:(.text+0xf0e55): undefined reference to `input_led_disconnect'

Ok, so the "something like this" in the patch review was really not so
trivial :)

To summarize, input.c needs to call leds.c to register its LEDs,
and leds.c uses input.c functions, such as input_event. So in the
all-modules case we have a circular dependency, and when one is built-in
but not the other, we get an undefined reference.  In my original patch
input.c would not call leds.c when built as module, and then the module
wouldn't be useful any more.

So in the end it would probably be simpler to just stuff leds.c along
input.c in input.ko or built-in. CONFIG_INPUT_LEDS will thus become a
bool.  I'm working on that now.

Samuel
