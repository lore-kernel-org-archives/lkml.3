Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaABMKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:10:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaABMJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:09:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@osdl.org, chas@cmf.nrl.navy.mil,
        davem@davemloft.net, geert@linux-m68k.org, gregkh@linuxfoundation.org,
        hverkuil@xs4all.nl, mingo@kernel.org, JBottomley@parallels.com,
        perex@perex.cz, axboe@kernel.dk, jslaby@suse.cz, isdn@linux-pingi.de,
        m.chehab@samsung.com, peterz@infradead.org, robinmholt@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org, devel@driverdev.osuosl.org,
        linux-atm-general@lists.sourceforge.net, linux-cris-kernel@axis.com,
        linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH, RFC 00/30] sleep_on removal
Date: Thu,  2 Jan 2014 13:07:24 +0100
Message-Id: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:r0QkM5SEQSrahHUKEu5j8UW+d9dSC3gfTLM2KnQYuea
 KrlHsaG8Degya1Uj5Rn/vO1TlG/kwmx7qtB0Ev374i0ay/xQ9w
 ZOYg0hZaf3Z8G0UOoEd9mkg6JLK1/L+amjBjmjy+UMJo+8/khP
 +wmkRLsD1qIY6rXnbaHMMqorM/NjFrqqsLIvNg82VgzSVygY0w
 sVGJ4hYve+qwvRibE1S7fTJd2yIIi25fGKKOqvXJzOEng9/vRu
 E+3aVbiXDBlyBCSjt0ZJ0f/N8hgcaMSqDLAXadTp2EtNJ056WY
 QbsDAk8s+vfpiewRiaN1/pq7+3YSfpIEjaJ5U/AAh7H1jjp2Y9
 eQpSYk8qYYt50N9qvh/awTJxAHl8O4BrS2l7AEQAj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions sleep_on, sleep_on_timeout, interruptible_sleep_on
and interruptible_sleep_on_timeout have been deprecated for as
long as I can remember, and a number of people have contributed
patches in the past to remove them from various drivers.

This has recently popped up again and I decided to spend some
of my time on tracking down the last users and kill it for good.
The work is somewhat related to the BKL removal I did a couple
of years ago, since most of these drivers were using the BKL
in a way that actually made the sleep_on function safe to call.
As the BKL was converted into mutexes, the semantics changed
slightly and typically opened up a race between checking
a condition and going to sleep.

I don't have any of the hardware that I'm sending the patches
for, so it would be great if someone could test them before
they get applied. Otherwise please review very carefully.

I'm definitely happy for any patches to go into maintainer
trees right away. Obviously the final patch cannot go in
until everything else gets merged first and I suspect there
will be a series of patches for maintainerless drivers that
will go along with it.

	Arnd

Arnd Bergmann (30):
  ataflop: fix sleep_on races
  scsi: atari_scsi: fix sleep_on race
  DAC960: remove sleep_on usage
  swim3: fix interruptible_sleep_on race
  [media] omap_vout: avoid sleep_on race
  [media] usbvision: remove bogus sleep_on_timeout
  [media] radio-cadet: avoid interruptible_sleep_on race
  [media] arv: fix sleep_on race
  staging: serqt_usb2: don't use sleep_on
  staging: gdm72xx: fix interruptible_sleep_on race
  staging: panel: fix interruptible_sleep_on race
  parport: fix interruptible_sleep_on race
  cris: sync_serial: remove interruptible_sleep_on
  tty/amiserial: avoid interruptible_sleep_on
  usbserial: stop using interruptible_sleep_on
  tty: synclink: avoid sleep_on race
  atm: nicstar: remove interruptible_sleep_on_timeout
  atm: firestream: fix interruptible_sleep_on race
  isdn: pcbit: fix interruptible_sleep_on race
  isdn: hisax/elsa: fix sleep_on race in elsa FSM
  isdn: divert, hysdn: fix interruptible_sleep_on race
  isdn: fix multiple sleep_on races
  oss: msnd_pinnacle: avoid interruptible_sleep_on_timeout
  oss: midibuf: fix sleep_on races
  oss: vwsnd: avoid interruptible_sleep_on
  oss: dmasound: kill SLEEP() macro to avoid race
  oss: remove last sleep_on users
  sgi-xp: open-code interruptible_sleep_on_timeout
  char: nwbutton: open-code interruptible_sleep_on
  sched: remove sleep_on() and friends

 Documentation/DocBook/kernel-hacking.tmpl    | 10 ------
 arch/cris/arch-v10/drivers/sync_serial.c     |  4 ++-
 arch/cris/arch-v32/drivers/sync_serial.c     |  4 ++-
 drivers/atm/firestream.c                     |  4 +--
 drivers/atm/nicstar.c                        | 13 ++++----
 drivers/block/DAC960.c                       | 34 +++++++++----------
 drivers/block/ataflop.c                      | 16 ++++-----
 drivers/block/swim3.c                        | 18 ++++++----
 drivers/char/nwbutton.c                      |  5 ++-
 drivers/char/pcmcia/synclink_cs.c            |  4 +--
 drivers/isdn/divert/divert_procfs.c          |  7 ++--
 drivers/isdn/hisax/elsa.c                    |  9 +++--
 drivers/isdn/hisax/elsa_ser.c                |  3 +-
 drivers/isdn/hysdn/hysdn_proclog.c           |  7 ++--
 drivers/isdn/i4l/isdn_common.c               | 13 +++++---
 drivers/isdn/pcbit/drv.c                     |  6 ++--
 drivers/media/platform/arv.c                 |  4 +--
 drivers/media/platform/omap/omap_vout_vrfb.c |  3 +-
 drivers/media/radio/radio-cadet.c            | 12 +++++--
 drivers/media/usb/usbvision/usbvision.h      |  4 +--
 drivers/misc/sgi-xp/xpc_channel.c            |  5 ++-
 drivers/parport/share.c                      |  3 +-
 drivers/scsi/atari_scsi.c                    | 12 +++++--
 drivers/staging/gdm72xx/gdm_usb.c            |  5 +--
 drivers/staging/panel/panel.c                |  4 +--
 drivers/staging/serqt_usb2/serqt_usb2.c      | 17 ++++------
 drivers/tty/amiserial.c                      | 26 ++++++++++-----
 drivers/tty/synclink.c                       |  4 +--
 drivers/tty/synclink_gt.c                    |  4 +--
 drivers/tty/synclinkmp.c                     |  4 +--
 drivers/usb/serial/ch341.c                   | 29 +++++++++++-----
 drivers/usb/serial/cypress_m8.c              | 49 ++++++++++++++++++----------
 drivers/usb/serial/f81232.c                  | 29 +++++++++++-----
 drivers/usb/serial/pl2303.c                  | 29 +++++++++++-----
 include/linux/wait.h                         | 11 -------
 kernel/sched/core.c                          | 46 --------------------------
 sound/oss/dmabuf.c                           | 14 ++++----
 sound/oss/dmasound/dmasound.h                |  1 -
 sound/oss/dmasound/dmasound_core.c           | 28 +++++++++++-----
 sound/oss/midibuf.c                          | 18 +++++-----
 sound/oss/msnd_pinnacle.c                    | 31 ++++++++++--------
 sound/oss/sequencer.c                        | 16 ++++-----
 sound/oss/sleep.h                            | 18 ++++++++++
 sound/oss/swarm_cs4297a.c                    | 14 ++++----
 sound/oss/vwsnd.c                            | 14 +++++---
 45 files changed, 334 insertions(+), 277 deletions(-)
 create mode 100644 sound/oss/sleep.h

-- 
1.8.3.2

Cc: akpm@osdl.org
Cc: chas@cmf.nrl.navy.mil
Cc: davem@davemloft.net
Cc: geert@linux-m68k.org
Cc: gregkh@linuxfoundation.org
Cc: hverkuil@xs4all.nl
Cc: mingo@kernel.org
Cc: JBottomley@parallels.com
Cc: perex@perex.cz
Cc: axboe@kernel.dk
Cc: jslaby@suse.cz
Cc: isdn@linux-pingi.de
Cc: m.chehab@samsung.com
Cc: peterz@infradead.org
Cc: robinmholt@gmail.com
Cc: tiwai@suse.de
Cc: alsa-devel@alsa-project.org
Cc: devel@driverdev.osuosl.org
Cc: linux-atm-general@lists.sourceforge.net
Cc: linux-cris-kernel@axis.com
Cc: linux-media@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org

