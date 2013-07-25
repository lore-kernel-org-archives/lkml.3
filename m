Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3GYNPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:15:17 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:52448 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab3GYNPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:15:13 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 0/4] iommu: Add event tracing feature to iommu 
Date: Thu, 25 Jul 2013 07:15:01 -0600
Message-Id: <cover.1374711464.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu: Add event tracing feature to iommu

This patch set adds tracing feature to iommu driver to report various
iommu events. Classes iommu_group, iommu_device, iommu_map_unmap, and
iommu_amd_event are defined.

iommu_group class events can be enabled to trigger when devices get added
to and removed from an iommu group. Trace information includes iommu group
id and device name.

iommu:add_device_to_group
iommu:remove_device_from_group

iommu_device class events can be enabled to trigger when devices are attached
to and detached from a domain. Trace information includes device name.

iommu:attach_device_to_domain
iommu:detach_device_from_domain

iommu_map_unmap class events can be enabled to trigger when iommu map and
unmap iommu ops complete. Trace information includes iova, physical address
(map event only), and size.

iommu:unmap
iommu:map

iommu_amd_event class can be enabled to trigger when AMD IOMMU driver finds
events when it polls the IOMMU Event Log. Trace information includes the
event string derived from the event type in human friendly form, event type,
id of the domain the device is placed in, device (bus number, slot number,
and function number), address associated with the event, and flags.

iommu:amd_event

In addition to defining the new traces, iommu and amd_iommu drivers are changed
to call trace events.

Testing:
The following is trace is generated when intel-iommu driver adds devices to
to iommu groups during boot-time during its initialization:

#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
       swapper/0-1     [003] ....     1.854793: add_device_to_group: IOMMU: groupID=0 device=0000:00:00.0
       swapper/0-1     [003] ....     1.854797: add_device_to_group: IOMMU: groupID=1 device=0000:00:02.0
       swapper/0-1     [003] ....     1.854802: add_device_to_group: IOMMU: groupID=2 device=0000:00:16.0
       swapper/0-1     [003] ....     1.854803: add_device_to_group: IOMMU: groupID=2 device=0000:00:16.3
       swapper/0-1     [003] ....     1.854805: add_device_to_group: IOMMU: groupID=3 device=0000:00:19.0
       swapper/0-1     [003] ....     1.854807: add_device_to_group: IOMMU: groupID=4 device=0000:00:1a.0
       swapper/0-1     [003] ....     1.854810: add_device_to_group: IOMMU: groupID=5 device=0000:00:1b.0
       swapper/0-1     [003] ....     1.854817: add_device_to_group: IOMMU: groupID=6 device=0000:00:1c.0
       swapper/0-1     [003] ....     1.854821: add_device_to_group: IOMMU: groupID=6 device=0000:00:1c.2
       swapper/0-1     [003] ....     1.854823: add_device_to_group: IOMMU: groupID=7 device=0000:00:1d.0
       swapper/0-1     [003] ....     1.854825: add_device_to_group: IOMMU: groupID=8 device=0000:00:1e.0
       swapper/0-1     [003] ....     1.854828: add_device_to_group: IOMMU: groupID=9 device=0000:00:1f.0
       swapper/0-1     [003] ....     1.854830: add_device_to_group: IOMMU: groupID=9 device=0000:00:1f.2
       swapper/0-1     [003] ....     1.854831: add_device_to_group: IOMMU: groupID=9 device=0000:00:1f.3

Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
       swapper/0-1     [003] ....     1.854099: amd_event: IOMMU:Event 0x01 00:00.0 d=0x0010 a=0x00000000cb800000 f=0x0002
       swapper/0-1     [003] ....     1.854101: remove_device_from_group: IOMMU: groupID=0 device=0000:00:02.0
       swapper/0-1     [003] ....     1.854102: attach_device_to_domain: IOMMU: device=0000:00:02.0
       swapper/0-1     [003] ....     1.854102: detach_device_from_domain: IOMMU: device=0000:00:02.0
       swapper/0-1     [003] ....     1.854102: map: IOMMU: iova=0x00000000cb800000 paddr=0x00000000cf9fffff size=0x400
       swapper/0-1     [003] ....     1.854102: unmap: IOMMU: iova=0x00000000cb800000 size=0x400

Shuah Khan (4):
  iommu: Add event tracing feature to iommu - Add iommu trace events
  iommu: Add event tracing feature to iommu - export trace events
  iommu: Add event tracing feature to iommu - amd_iommu driver trace
    events
  iommu: Add event tracing feature to iommu - iommu driver trace events

 drivers/iommu/Makefile       |    1 +
 drivers/iommu/amd_iommu.c    |   19 +++++
 drivers/iommu/iommu-traces.c |   27 +++++++
 drivers/iommu/iommu.c        |   17 ++++-
 include/trace/events/iommu.h |  174 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommu-traces.c
 create mode 100644 include/trace/events/iommu.h

-- 
1.7.10.4

