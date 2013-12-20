Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3LTMj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:39:27 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38578 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3LTMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:23 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 00/26] DRBD code reorganization
Date: Fri, 20 Dec 2013 13:28:57 +0100
Message-Id: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we are preparing DRBD for the ability to have multiple connections,
in other words the ability to mirror a single block device to multiple
peers concurrently.

This patch set is the first half of a preparation step. With part 2
it introduces a new in memory object (struct drbd_resource),
and renames the current in memory objects for clarity.

This patch set does not introduce any new functionality. The first
patch of the set is one minor bugfix. The second patch introduces
a new function for IDRs, outside of the drbd tree.

I will post the second part on Monday.

The following paragraphs describe the data structures that are set in
place by this patch set.


A node has a number of DRBD resources.  Each such resource has a number of
devices (aka volumes) and connections to other nodes ("peer nodes"). Each DRBD
device is represented by a block device locally.

The DRBD objects are interconnected to form a matrix as depicted below; a
drbd_peer_device object sits at each intersection between a drbd_device and a
drbd_connection:

  /--------------+---------------+.....+---------------\
  |   resource   |    device     |     |    device     |
  +--------------+---------------+.....+---------------+
  |  connection  |  peer_device  |     |  peer_device  |
  +--------------+---------------+.....+---------------+
  :              :               :     :               :
  :              :               :     :               :
  +--------------+---------------+.....+---------------+
  |  connection  |  peer_device  |     |  peer_device  |
  \--------------+---------------+.....+---------------/

In this table, horizontally, devices can be accessed from resources by their
volume number.  Likewise, peer_devices can be accessed from connections by
their volume number.  Objects in the vertical direction are connected by double
linked lists.  There are back pointers from peer_devices to their connections a
devices, and from connections and devices to their resource.

All resources are in the drbd_resources double-linked list.  In addition, all
devices can be accessed by their minor device number via the drbd_devices idr.

The drbd_resource, drbd_connection, and drbd_device objects are reference
counted.  The peer_device objects only serve to establish the links between
devices and connections; their lifetime is determined by the lifetime of the
device and connection which they reference.


Andreas Gruenbacher (25):
  idr: Add new function idr_is_empty()
  drbd: Describe the future high-level structure of DRBD
  drbd: Split off on-the-wire protocol definitions
  drbd: Rename struct drbd_conf -> struct drbd_device
  drbd: Rename "mdev" to "device"
  drbd: Rename drbd_tconn -> drbd_connection
  drbd: Introduce "peer_device" object between "device" and
    "connection"
  drbd: Improve some function and variable naming
  drbd: Add struct drbd_resource
  drbd: drbd_adm_down(): Move valid resource name check to
    drbd_adm_prepare()
  drbd: Add struct drbd_device->resource
  drbd: Minor cleanup in conn_new_minor()
  drbd: Add struct drbd_resource->devices
  drbd: Replace conn_get_by_name() with drbd_find_resource()
  drbd: conn_try_disconnect(): Use parameter instead of the global
    variable
  drbd: Move resource options from connection to resource
  drbd: Turn connection->volumes into connection->peer_devices
  drbd: Remove the terrible DEV hack
  drbd: Turn drbd_printk() into a polymorphic macro
  drbd: Replace and remove the obsolete conn_() macros
  drbd: Add explicit device parameter to D_ASSERT
  drbd: Rename drbd_{create,delete}_minor ->
    drbd_{create,delete}_device
  drbd: get_one_status(): Iterate over resource->devices instead of
    connection->peer_devices
  drbd: drbd_adm_new_resource(): Check if resource exists, not if it
    has any connections
  drbd: drbd_create_device(): Take a resource instead of a connection
    argument

Philipp Reisner (1):
  drbd: Add missing error goto

 Documentation/blockdev/drbd/data-structure-v9.txt |   38 +
 drivers/block/drbd/drbd_actlog.c                  |  624 +++---
 drivers/block/drbd/drbd_bitmap.c                  |  360 +--
 drivers/block/drbd/drbd_int.h                     | 1087 ++++-----
 drivers/block/drbd/drbd_main.c                    | 1897 ++++++++--------
 drivers/block/drbd/drbd_nl.c                      | 1539 ++++++-------
 drivers/block/drbd/drbd_proc.c                    |  138 +-
 drivers/block/drbd/drbd_protocol.h                |  295 +++
 drivers/block/drbd/drbd_receiver.c                | 2435 +++++++++++----------
 drivers/block/drbd/drbd_req.c                     |  455 ++--
 drivers/block/drbd/drbd_req.h                     |   20 +-
 drivers/block/drbd/drbd_state.c                   |  852 +++----
 drivers/block/drbd/drbd_state.h                   |   40 +-
 drivers/block/drbd/drbd_worker.c                  |  878 ++++----
 drivers/block/drbd/drbd_wrappers.h                |   14 +-
 include/linux/drbd_genl.h                         |    4 +-
 include/linux/idr.h                               |    1 +
 lib/idr.c                                         |   10 +
 18 files changed, 5514 insertions(+), 5173 deletions(-)
 create mode 100644 Documentation/blockdev/drbd/data-structure-v9.txt
 create mode 100644 drivers/block/drbd/drbd_protocol.h

-- 
1.7.9.5

