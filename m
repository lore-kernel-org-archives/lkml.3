Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbaISPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:32:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbaISPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:32:40 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v3 0/6] usb: hub: convert khubd into workqueue
Date: Fri, 19 Sep 2014 17:32:18 +0200
Message-Id: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3rd version of the patchset is slightly reordered and refactored
as suggested earlier. See below for more details.

IMHO, the result is more clean. But feel free to ask me to revert it.
I do not want to make the review more complicated. Well, I double checked
the diff of patches files between v2 and v3. It is pretty small and only
the expected changes are there.

Changes in:
    + v3:
	+ split the optimization of hub->hdev reference counting
	  into separate patch; usable standalone (1st patch)

	+ switch order of the two patches that convert the kthread
	  and that remove the while cycle in hub_event(); it is
	  cleaner (2nd and 3rd patch)

	+ use ordered workqueue by default; it makes it compatible
	  with the original kthread solution (3rd patch)

        + added optional patch that allows to process events
	  in parallel (6th patch)

	+ fixed the suggested stylistic problems (2nd and 3rd patch)


    + v2:
	+ solved potential races:
	  	 + get hub->kref in kick_hub_wq()
		 + call usb_get_dev(hdev) in hub_probe()
		   and 	usb_put_dev(hdev) in hub_release()
		 + INIT_WORK only once in hub_probe()

	 + do not call cancel_work_sync() in hub_disconnect()
	   to keep it fast

	 + rename kick_khubd() to kick_hub_wq() already
	   in the first patch; IMHO, it is cleaner while
	   adding only very few changes


The workqueue API is well defined and tested. It has many options
that could be used to tune the scheduling. The code is usually
easier and thus more safe. It allows to avoid the extra thread
in most cases. It has has clearly defined behavior vrt. system suspend.

This patchset converts khubd into the workqueue. It saves one thread,
lock, and list.

It  looks huge but the main change is in the first patch. The rest is
simple renaming of functions, comments and documentation.

	   
Thanks a lot Alan Stern and Tejun Heo for hints and guidance.

The patches can be applied either against Linus' tree or linux-next.


Petr Mladek (6):
  usb: hub: keep hub->dev reference all the time when struct usb_hub
    lives
  usb: hub: rename hub_events() to hub_event() and handle only one event
    there
  usb: hub: convert khubd into workqueue
  usb: hub: rename usb_kick_khubd() to usb_kick_hub_wq()
  usb: hub: rename khubd to hub_wq in documentation and comments
  usb: hub: allow to process more usb hub events in parallel

 Documentation/DocBook/usb.tmpl             |   2 +-
 Documentation/usb/WUSB-Design-overview.txt |   6 +-
 Documentation/usb/hotplug.txt              |   2 +-
 drivers/net/usb/usbnet.c                   |  14 +-
 drivers/usb/README                         |   2 +-
 drivers/usb/core/hcd.c                     |  14 +-
 drivers/usb/core/hub.c                     | 380 +++++++++++++----------------
 drivers/usb/core/hub.h                     |   2 +-
 drivers/usb/core/usb.h                     |   2 +-
 drivers/usb/host/ehci-fsl.c                |   2 +-
 drivers/usb/host/ehci-hcd.c                |   2 +-
 drivers/usb/host/ehci-hub.c                |   8 +-
 drivers/usb/host/fhci-hcd.c                |   6 +-
 drivers/usb/host/fotg210-hcd.c             |   8 +-
 drivers/usb/host/fusbh200-hcd.c            |   8 +-
 drivers/usb/host/isp1760-hcd.c             |   6 +-
 drivers/usb/host/ohci-hcd.c                |   6 +-
 drivers/usb/host/ohci-hub.c                |   4 +-
 drivers/usb/host/ohci-omap.c               |   2 +-
 drivers/usb/host/oxu210hp-hcd.c            |  10 +-
 drivers/usb/host/sl811-hcd.c               |   8 +-
 drivers/usb/host/xhci-hub.c                |   2 +-
 drivers/usb/host/xhci.c                    |   4 +-
 drivers/usb/misc/usbtest.c                 |   2 +-
 drivers/usb/musb/am35x.c                   |   1 +
 drivers/usb/musb/tusb6010.c                |   2 +-
 drivers/usb/phy/phy-fsl-usb.c              |   2 +-
 drivers/usb/phy/phy-isp1301-omap.c         |   2 +-
 drivers/usb/wusbcore/devconnect.c          |   6 +-
 drivers/usb/wusbcore/wa-hc.h               |   2 +-
 sound/usb/midi.c                           |   2 +-
 31 files changed, 242 insertions(+), 277 deletions(-)

-- 
1.8.4

