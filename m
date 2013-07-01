Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3GADKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:10:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54460 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3GADKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:10:51 -0400
MIME-Version: 1.0
Date: Sun, 30 Jun 2013 23:10:49 -0400
X-Google-Sender-Auth: wvDq9uvSfEg9FJGPhTzsEhzV0i4
Message-ID: <CAKb7Uvi8Ha_NJ=oy_2HAg1iJrbw008Tz+cRqCAV=gnqi0TEN8Q@mail.gmail.com>
Subject: Error creating sysfs files when reloading cx88 driver
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a pcHDTV 3000 card [0], on a 3.10-rc6 kernel. Every so often,
it stops working [1]. When I try to reload cx88_dvb, module loads, but
init errors out because some sysfs file is already there [2]. Removing
more of the video-related modules doesn't seem to help (at least not
once this happens). Any ideas? It seems like this has been asked
before [3] but no response. The files it fails to re-create are:

[334698.061395] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1e.0/0000:09:00.2/dvb/dvb0.frontend0'
[334698.062420] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1e.0/0000:09:00.2/dvb/dvb0.demux0'
[334698.062881] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1e.0/0000:09:00.2/dvb/dvb0.dvr0'

And the other warnings are just fallout from that. After removing all
of the video-related modules, that dvb directory is still there:

# ls /sys/devices/pci0000:00/0000:00:1e.0/0000:09:00.2/dvb
dvb0.demux0  dvb0.dvr0  dvb0.frontend0
# ls -l /sys/devices/pci0000:00/0000:00:1e.0/0000:09:00.2/dvb/dvb0.demux0
total 0
-r--r--r-- 1 root root 4096 Jun 30 23:03 dev
lrwxrwxrwx 1 root root    0 Jun 30 23:03 device -> ../../../0000:09:00.2
drwxr-xr-x 2 root root    0 Jun 27 01:43 power
lrwxrwxrwx 1 root root    0 Jun 27 01:43 subsystem ->
../../../../../../class/dvb
-rw-r--r-- 1 root root 4096 Jun 26 21:43 uevent

Note that subsystem there is a broken link, /sys/class/dvb no longer
exists since I've unloaded those modules.

Let me know if there's anything I should try. I'm pretty sure I can
reproduce this at will (just reloading the cx88_dvb module should do
it, even if the card isn't wedged) but I haven't tried it.

Thanks,

  -ilia

[0] 09:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
09:00.2 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev
05)

[1] http://pastebin.com/3JAnDUDX
[2] http://pastebin.com/QEpajhaF
[3] https://lkml.org/lkml/2013/2/6/274
