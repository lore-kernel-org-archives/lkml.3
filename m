Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbaICPw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:52:57 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:63022 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaICPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:52:52 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [REPOST PATCH v4 0/2] PM QoS: Add support for memory bandwidth constraints
Date: Wed,  3 Sep 2014 17:49:31 +0200
Message-Id: <1409759373-22696-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is just a rebase on top of latest linux-next. Follows the original blurb:

Some device drivers need to sustain transfers to or from external memory at
given fixed rates for a period of time. If we wait for the devfreq drivers to
react to this load, the user is likely going to perceive glitches in the user
experience.

Some common scenarios that would benefit from it are display controllers
setting a new mode, USB drivers starting isochronous transfers, camera drivers
starting to capture and hw media codecs doing their thing.

I'm proposing adding a new PM_QOS_MEMORY_BANDWIDTH class that device drivers
can use to register their memory bandwidth needs right when they become known,
so the external memory clock can be set at the optimum frequency, thus
preventing glitches.

There have been similar proposals before [0], the first main concern being that
constraints need to refer to a global resource such as CPUs. If they referred
to a network NIC or to a UART, there would be no way of knowing how to actually
constrain each device because there would be a single list of requests.

In this case, the memory bus is a global resource just like the CPUs are, and
all requests in this class will apply to a single device driver in any
particular system.

The second serious concern was that constraints need to be defined in a way
generic enough so they can be consumed in a wide array of particular systems
without placing the burden of taking into account hw specifics in the driver of
the memory client.

Here, the PM_QOS_MEMORY_BANDWIDTH constraints are specified always in kbs,
being the amount of data that the device driver wants to see transferred per
second. This allows for example for a camera driver to calculate the
appropriate value based on the size of each frame and the desired FPS and,
depending on the particular system where the camera block is used, the
appropriate external memory driver will convert that to the bus clock frequency
that makes sense for the hardware at hand.

The first patch adds the new class and also a new PM_QOS_SUM class type.

The second illustrates how the driver for such a memory client would request
its memory bandwidth requirement.

Most vendor trees carry their own solution for this specific issue, so it would
be pretty neat if mainline gained a similar mechanism so we get more power
management goodies in the right place.

[0] https://lkml.org/lkml/2012/3/10/165

Thanks,

Tomeu

Tomeu Vizoso (2):
  PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
  drm/tegra: Request memory bandwidth for the display controller

 Documentation/power/pm_qos_interface.txt |  4 +++-
 drivers/gpu/drm/tegra/dc.c               | 15 +++++++++++++++
 drivers/gpu/drm/tegra/drm.h              |  3 +++
 include/linux/pm_qos.h                   |  5 ++++-
 kernel/power/qos.c                       | 27 ++++++++++++++++++++++++++-
 5 files changed, 51 insertions(+), 3 deletions(-)

-- 
1.9.3

