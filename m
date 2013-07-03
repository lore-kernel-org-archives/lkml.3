Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3GCMdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:33:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3GCMdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:33:40 -0400
Subject: modalias char-major-10-130
From: Jean Delvare <jdelvare@suse.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 03 Jul 2013 14:33:23 +0200
Message-ID: <1372854803.22042.22.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

All watchdog drivers include:

MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

which causes a modalias char-major-10-130 to be added to every watchdog
driver module. As a result, any access to /dev/watchdog on a system with
no watchdog driver loaded and working will result in an attempt to load
several dozen drivers. At best one or two will actually work, the others
will:

* Waste time failing to load.
* Waste memory succeeding to load but not finding any device to bind to.
* Pollute the kernel log.
* Sometimes even load while they should not and break the system. I just
had a report about advantechwdt doing that on some systems.

And the attempt order will presumably be random, so it might as well
load softdog before a hardware-based watchdog which would have been
preferred.

This looks so 90s. Drivers for enumerated devices have hardware-based
modaliases, so char-major-10-130 shouldn't be needed. Other drivers
should certainly not be loaded randomly if they need to poke the
hardware to detect the presence of a supported device.

My opinion is that the char-major-10-130 modalias should ONLY be defined
by user-space, when the user knows he/she needs a watchdog driver which
doesn't support auto-loading via hardware-based auto-loading.

So, can we please get rid of all these
MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) statements? They do more harm than
good as far as I can see.

Thanks,
-- 
Jean Delvare
Suse L3

