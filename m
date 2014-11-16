Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaKPKMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:12:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaKPKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:12:50 -0500
Date: Sun, 16 Nov 2014 11:12:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@kernel.org>,
        Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141116101248.GA32483@amd>
References: <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
 <20141106180335.GA21513@earth.universe>
 <20141113162155.GA8512@xo-6d-61-c0.localdomain>
 <20141113174534.GO26481@atomide.com>
 <20141113181803.GB984@fuloong-minipc.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113181803.GB984@fuloong-minipc.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:18:04, Aaro Koskinen wrote:
> Hi,
> 
> On Thu, Nov 13, 2014 at 09:45:36AM -0800, Tony Lindgren wrote:
> > * Pavel Machek <pavel@ucw.cz> [141113 08:23]:
> > > OTOH ofono seems pretty reasonable. So I played a bit, and result
> > > is python/pygtk gui which can receive an sms, initiate a call, and
> > > report missed call. If someone wants to play, source is at
> > > 
> > > https://gitorious.org/tui/tui/source/b6141107e9341a1412720aed4b0d09143dfa2f4e:ofone
> > 
> > Pavel, care to fill in the the following type patch with some
> > instructions in the description now that you got it working?
> 
> Could we even have some "permanent" instructions under Documentation/?

Something like this?

commit 375d8d9f17433ade6afae91d4f34e170f0af04c4
Author: Pavel <pavel@ucw.cz>
Date:   Sun Nov 16 11:10:59 2014 +0100

Add basic documentation for n900 testing.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/cellphones.txt b/Documentation/cellphones.txt
new file mode 100644
index 0000000..d7e8e7a
--- /dev/null
+++ b/Documentation/cellphones.txt
@@ -0,0 +1,90 @@
+Running Linux on Cellphones
+===========================
+
+At this moment (2014), there are no cellphones completely supported by
+mainline kernel. Another problem is lack of hackable userspace to run
+on cellphone, even when kernel support is available.
+
+Openmoko was first phone running Linux with X. GSM support there was
+based on freesmartphone.org daemons.
+
+Sony has project to merge kernel support for Xperia Z1.
+
+Nokia N900
+----------
+
+Nokia N900 orignally shipped with Maemo-based userland, which is close
+enough to GNU/X/apt based Linux; key components communicate using dbus
+and application can be written in pygtk. Kernel patches were
+relatively clean, and the core stuff is merged, unfortunately there's
+quite a lot of non-core stuff and pieces of userland are closed
+source; including some critical support such as bridge between CPU and
+modem for voice calls.
+
+Unfortunately, that means that kernel development is hard, because it
+is non-trivial to test all the various devices in the phone due to
+lack of suitable userspace and userspace development is hard, because
+there's no suitable kernel to work with.
+
+Here are instructions for getting usable userspace for kernel testing,
+and suggestions for some tests. Setting up nfsroot (needs non-mainline
+patch) is strongly recommended for development.
+
+I'm using Debian 7 for testing/development. It works well including
+touchscreen and X support, as of 3.18-rc1. Instructions are here:
+
+https://wiki.debian.org/n900-wheezy-armhf
+https://wiki.debian.org/MaemoAndSqueeze
+
+Following packages are useful on N900:
+
+libts-bin evtest ntpdate module-init-tools udev netbase ifupdown openssh-server
+locales whiptail less mpg123 mplayer ofono gcc strace mdbus2
+
+This calibrates display to usable state on recent kernel and Debian 7:
+
+DISPLAY=:0.0 xinput --set-prop --type=float 8 115  1.10 0.00 -0.05  0.00 1.18 -0.10  0.00 0.00 1.00
+DISPLAY=:0.0 xinput --set-prop --type=int 8 249 0 1
+
+# Test vibrations
+echo 5 | fftest /dev/input/event2
+
+# Test LEDs
+VAL=30
+echo $VAL > lp5523\:kb1/brightness
+echo $VAL > lp5523\:kb1/brightness
+echo $VAL > lp5523\:kb2/brightness
+echo $VAL > lp5523\:kb3/brightness
+echo $VAL > lp5523\:kb4/brightness
+echo $VAL > lp5523\:kb5/brightness
+echo $VAL > lp5523\:kb6/brightness
+echo $VAL > lp5523\:r/brightness
+echo $VAL > lp5523\:g/brightness
+echo $VAL > lp5523\:b/brightness
+echo 100 > /sys/class/backlight/acx565akm/brightness
+echo mem > /sys/power/state
+
+# Display battery/charging state
+cd /sys/bus/i2c/drivers/bq27x00-battery/2-0055/power_supply/bq27200-0
+grep -r . .
+
+# Start	up ofono in debug mode
+rmdir /dev/cmt
+ln -s /sys/bus/hsi/devices/n900-modem/ /dev/cmt
+killall  ofonod
+sleep .1
+ofonod --nodetach --debug &
+
+# Test modem works
+# enable the modem
+mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Powered true
+# enable modem's RF parts
+mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Online true
+# scan for available networks (takes some time)
+mdbus2 -s org.ofono /n900_0 org.ofono.NetworkRegistration.Scan
+
+
+								Good luck!
+
+								Pavel
+


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
