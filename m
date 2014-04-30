Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbaD3ODo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:03:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53156 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbaD3ODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:03:41 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-e0-536102ba1766
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stansislawski <t.stanislaws@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: [RFC PATCH 0/4] drivers/base: Generic framework for tracking internal
 interfaces
Date: Wed, 30 Apr 2014 16:02:50 +0200
Message-id: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xy7q7mBKDDSZM0be4te4cq0XvuZNM
	Fn8nHWO3uPL1PZtF8+L1bBaT7k9gsTjb9IbdYtPja6wWl3fNYbPo2bCV1WLG+X1MFrcv81qs
	PXKX3WL9jNcsFvPaX7Ja/Nw1j8VBwKOluYfN4/evSYweO2fdZffY/u0Bq8f+uWvYPe53H2fy
	2Lyk3qNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgyuo+1MBastarYsO4GawPjZ/0uRk4OCQET
	ibOfL7JA2GISF+6tZ+ti5OIQEljKKDH96iQop49J4u+DPcwgVWwCmhJ/N99kA7FFBHQkrvd0
	M4MUMQusZpU48HkSWJGwQLTEmsef2UFsFgFViSWbZ4DFeQWcJdYfmMAKsU5BYtmXtcwTGLkX
	MDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ0687GJceszrEKMDBqMTDK7A1PliINbGs
	uDL3EKMEB7OSCO/RfwnBQrwpiZVVqUX58UWlOanFhxiZODilGhhtZefdVtS61SP0tTbkMC/P
	Y+XmFY+UJh+NEFsa3pQvmCrCc2SFRZXntEtVjxQielqirqSIni5+mZrxceUxlkcNdV3d9U4n
	u7xK/Bh1jJ4z/3afsdkxofLa3VS7zT1PWh2YOjl/Gm6OKj77/be/3OkuVel5J27en3vmjeEF
	96abfDMzLidHtimxFGckGmoxFxUnAgCGN5DSMQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic framework for tracking internal interfaces
==================================================

Summary
-------

interface_tracker is a generic framework which allows to track appearance
and disappearance of different interfaces provided by kernel/driver code inside
the kernel. Examples of such interfaces: clocks, phys, regulators, drm_panel...
Interface is specified by a pair of object pointer and interface type. Object
type depends on interface type, for example interface type drm_panel determines
that object is a device_node. Object pointer is used to distinguish different
interfaces of the same type and should identify object the interface is bound to.
For example it could be DT node, struct device,...

The framework provides two functions for interface providers which should be
called just after interface becomes available or just before interface
removal. Interface consumers can register callback which will be called
when requested interface changes its state, if during callback registration
the interface is already up, notification will be sent also.

The framework allows nesting calls, for example it is possible to signal one
interface in tracker callback of another interface. It is done by putting
every request into the queue. If the queue is empty before adding
the request, the queue will be processed after, if there is already another
request in the queue it means the queue is already processed by different
thread so no additional action is required. With this pattern only spinlock
is necessary to protect the queue. However in case of removal of either
callback or interface caller should be sure that his request has been
processed so framework waits until the queue becomes empty, it is done using
completion mechanism.

The framework functions should not be called in atomic context. Callbacks
should be aware that they can be called in any time between registration and
de-registration, so they should use synchronization mechanisms carefully.
Callbacks should also avoid to perform time consuming tasks, the framework
serializes them, so it could stall other callbacks.

Use cases
---------

The interface is very generic, there are many situations it can be useful:

1. Replacement for subsystem specific methods of publishing/unpublishing
interfaces. Currently many frameworks allows only querying for presence of given
interface. In such cases client can defer probing or implement interface
polling, which is usually subobtimal. Additionally subsystems often do not
provide methods to signal to the consumers that they are about to be destroyed.

2. Monitoring for different interfaces provided by the same object. An example
should explain it better. Lets assume in device tree drm crtc device node have
video link to another node, so it knows only that there is something connected
to its RGB output. It can be a RGB panel (drm_panel framework), it can be an
image enhancer (SoC specific framework) or it can be some signal converter
(drm_encoder, drm_bridge, drm_encoder_slave...). Driver have only phandle to
another node. Currently it is difficult to handle such situations in a generic
way. interface_tracker should make it simple: crtc should monitor all supported
interface types that appears at the device_node pointed by the phandle.

Potential use cases
-------------------

Points mentioned above were the reasons for writing this framework. During
development I have realized that this framework can be also useful for other
tasks.

3. Replacement for deferred probing - if for some reason driver do not wants to
defer but it requires given resources it can use interface_tracker. It should be
possible to create an helper which will wait for appearance of all interfaces
from a given list, and 'continue' probe only when all resources becomes
available.

4. Replacement or helper for subsystem specific solutions:
- V4L2 subdev async registration,
- component framework.
Both frameworks solves a problem of tracking sub-components (un-)registration
by master device, it should be possible to do the same with interface_tracker
framework. Some additional helpers can be convienent to make the implementation
easier.

5. Cure the situation with sysfs 'unbind' property. Currently many drivers are
providers of different resources/interfaces: regulators, clocks, phys,
V4L2 subdevs, ... They are usually protected from module unloading by getting
module reference, but there is no protection from driver unbinding using sysfs
method: echo 'device' >/sys/bus/.../drivers/.../unbind. After unbind consumer
stays with the pointer to non-existing object, next time it tries to use it
system usually crashes. interface_tracker do not add any protection, but it adds
a way to signal to the consumer that given resource will disappear. It allows
to handle such situations more gently.

Potential issues/extensions
---------------------------

1. Scalability - the framework serializes all tasks and callbacks. In case there
are no many users it should not be a problem. If the number of users grows there
are different options to consider:
- run callbacks in parallel, I guess async_schedule_domain can be helpfull,
- partition trackers, for example per interface types - different interface
  types will use different internal queues/lists.

2. Complication of code - asynchronous programming usually seems to be more
complicated. Adding some helpers could make it less painfull.

3. Object comparison - currently object pointers are compared by value, it could
be desirable to allow also other ways of comparison, for example string
comparison. It is not a problem to extend the framework.

TODO
----

1. Testing - the patchset have not been tested yet with multiple users.
2. Add tracker support in other frameworks - currently there is only drm_panel.
   I plan also to add something more complicated, for example use it in
   exynos_drm to track components. If there is positive feedback I can try
   to add also other frameworks.
3. devm_* registration.
4. Helpers - as the situation 'wait for number interfaces before continue'
   seems to be quite common, some helper to easy handling it could be useful.

Final remarks
-------------

Primarily I have planned notifications for DRM panels. Next I have realized
something similar would be necessary for drm_bridge. Discussions with other
developers showed to me that it could be useful in many other areas. I am not
sure if other developers agree with adding it to things like regulators, clocks,
phys, but I will be glad if it can be used at least with drm_panel.

Regards
Andrzej


Andrzej Hajda (4):
  drivers/base: add interface tracker framework
  drm/panel: add interface tracker support
  drm/exynos/dpi: add interface tracker support
  drm/panel/ld9040: do not power off panel on removal

 drivers/base/Makefile                   |   2 +-
 drivers/base/interface_tracker.c        | 307 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_panel.c             |   5 +
 drivers/gpu/drm/exynos/exynos_drm_dpi.c |  58 ++++--
 drivers/gpu/drm/panel/panel-ld9040.c    |   1 -
 include/linux/interface_tracker.h       |  29 +++
 6 files changed, 389 insertions(+), 13 deletions(-)
 create mode 100644 drivers/base/interface_tracker.c
 create mode 100644 include/linux/interface_tracker.h

-- 
1.8.3.2

