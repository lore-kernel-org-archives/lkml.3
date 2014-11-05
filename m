Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbaKEO16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:27:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:20357 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbaKEO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:27:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411829724"
Message-ID: <1415197672.958.96.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH 1/5 v2] mtd: ubi: Read disturb infrastructure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: richard@nod.at, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 05 Nov 2014 16:27:52 +0200
In-Reply-To: <1414331373-28024-1-git-send-email-tlinder@codeaurora.org>
References: <1414331373-28024-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

let me summarize.

1. To handle the read disturb problem you selected the read counters
solution. PEB (physical erase block) read counter is the trigger for
scrubbing.

When the PEB read counter reaches a threshold value - we scrub.
The threshold value is set to 100000 by default. Users may it via sysfs.

Read-counters are stored on the flash media, in the fastmap structure.


2. To handle the data retention problem you selected the time-stamps
approach. Each PEB gets a time-stamp. Time-stamp gets updated when the
PEB is erased.

When PEB becomes old enough (by comparing to the current system time),
it gets scrubbed.

The threshold for "old enough" is 120 days by default. Users may change
it via sysfs.

Timestamps are stored on the flash media, in the erase counter header of
the PEB.


For both, the read-disturb and data retention problems to be taken care
of, user-space has to periodically trigger scanning, which will go
through all PEBs, check the read counter and the timestamp, and scrub if
needed.


Hopefully I got right. I have concerns.


This is rather complex design, and it is not clear why just doing full
flash read from time to time is not good enough. Why the complexity is
worth it.

In this case the trigger for scrubbing is a bit-flip. It indicates that
there is a problem, and this is a reliable trigger.

Is the 100000 reads threshold a reliable trigger? What if it is 10 times
larger for me, or smaller?

Is the 120 days threshold a reliable trigger? What if it is much larger
for me?

Do you think it is even possible to get the thresholds right?

Let me re-emphasize: bit-flip is an objective, reliable reason to scrub.
Thresholds are more of a pessimistic prediction. No?

Let's think of someone having a R/O storage with video files. Compare:

1. Do full media read every 120 days in background with low priority
(possibly implemented as UBI service). And because it is R/O, cut the
power all you want.

2. Have UBI write data to media all the time to maintain the read
counters. Lose your fastmap and have slow mounts on power cuts. Have
extra work on boot-time. Spend more RAM.

Why 2 is better than 1?

Thanks!

