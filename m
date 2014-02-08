Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaBHAs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:48:56 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3223 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaBHAsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:48:54 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 0/6] mailbox: add common framework and port drivers
Date: Fri, 7 Feb 2014 16:50:13 -0800
Message-ID: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently no common framework for mailbox drivers, so this is my
attempt to come up with something suitable.  There seems to be a need for
making this generic, so I have attempted to do just that.  Most of this is
modeled pretty strongly after the pwm core, with some influences from the clock
core.

Looking at the existing use-cases, and some new ones, it would appear that the
requirements here are rather simple. We need essentially two things for
consumers:
	- put_message
	- callback for receiving messages

The code currently uses atomic notifiers for callbacks.  The common omap core
deals with fifos and work-queues in order to escape atomic contexts, but from
what I can see, this is unneeded.  I am also of the opinion that the contexts
can be much better managed in the drivers which are working with these
contexts, rather than generically.

Hopefully this will be suitable for the plethora of other drivers around the
kernel which implement mailboxes, as well.  In any case, I'm rather interested
to see what the rest of the world thinks.

Keep in mind that while the pl320 & omap code should compile, I don't currently
have a platform on which I can perform proper testing.  I also removed the
context save/restore code from omap2 mailbox support, because I think it should
be able to be done via driver suspend/resume, but haven't done a full
investigation just yet.

I'm also aware that breaking omap, just to fix it again probably isn't the best
course of action, and I'm open to suggestions.

-Courtney

Courtney Cavin (6):
  mailbox: add core framework
  mailbox: document bindings
  mailbox: pl320: migrate to mbox framework
  mailbox: omap: remove omap-specific framework
  mailbox: omap1: move to common mbox framework
  mailbox: omap2+: move to common mbox framework

 .../devicetree/bindings/mailbox/mailbox.txt        |  44 ++
 drivers/mailbox/Kconfig                            |  17 -
 drivers/mailbox/Makefile                           |   2 +-
 drivers/mailbox/core.c                             | 573 +++++++++++++++++++++
 drivers/mailbox/mailbox-omap1.c                    | 153 +++---
 drivers/mailbox/mailbox-omap2.c                    | 315 +++++------
 drivers/mailbox/omap-mailbox.c                     | 469 -----------------
 drivers/mailbox/omap-mbox.h                        |  67 ---
 drivers/mailbox/pl320-ipc.c                        | 258 +++++++---
 include/linux/mailbox.h                            |  29 +-
 include/linux/mbox.h                               | 175 +++++++
 include/linux/omap-mailbox.h                       |  45 +-
 12 files changed, 1261 insertions(+), 886 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
 create mode 100644 drivers/mailbox/core.c
 delete mode 100644 drivers/mailbox/omap-mailbox.c
 delete mode 100644 drivers/mailbox/omap-mbox.h
 create mode 100644 include/linux/mbox.h

-- 
1.8.1.5

