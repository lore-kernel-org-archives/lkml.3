Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaILMVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:21:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaILMVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:21:19 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 0/4] usb: hub: convert khubd into workqueue
Date: Fri, 12 Sep 2014 14:21:04 +0200
Message-Id: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workqueue API is well defined, it allows to schedule the work
as needed, and usually allows to avoid an extra thread at all.

This patchset converts khubd into the workqueue. It saves one thread,
lock, and list. IMHO, the new code is a bit cleaner.

It  looks huge but the main change is in the first patch. The rest is
simple renaming of functions, comments and documentaion.

Note that this is my first change of this type. I hope that I selected
reasonable parameters for the workqueue and did it a good way. Also
I hope that I got correctly the logic around hub_event_lock. The result
seems to work but any feedback and testing are much appreciated.


The patches are tested against linux-next. The last commit is
c3f2d223eae58504aae ("Add linux-next specific files for 20140911").

It depends on the patch from the mail "[PATCH] usb: hub: wrong order
of putting interfaces when processing" that was sent few minutes before.

It can be applied also on Linus' tree but you need to apply
the commit c605f3cdff53a743f6d875 ("usb: hub: take hub->hdev reference
when processing from eventlist") first.


Petr Mladek (4):
  usb: hub: convert khubd into workqueue
  usb: hub: remove obsolete while cycle in hub_event()
  usb: hub: rename *kick_khubd to *kick_hub_wq
  usb: hub: rename khubd to hub_wq in documentation and comments

 Documentation/DocBook/usb.tmpl             |   2 +-
 Documentation/usb/WUSB-Design-overview.txt |   6 +-
 Documentation/usb/hotplug.txt              |   2 +-
 drivers/net/usb/usbnet.c                   |  14 +-
 drivers/usb/README                         |   2 +-
 drivers/usb/core/hcd.c                     |  14 +-
 drivers/usb/core/hub.c                     | 357 +++++++++++++----------------
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
 31 files changed, 228 insertions(+), 268 deletions(-)

-- 
1.8.4

