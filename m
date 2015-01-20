Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbbATSdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:33:11 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59315 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751585AbbATSdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:33:09 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dev@openvswitch.org, pshelar@nicira.com
Subject: [PATCH net-next v13 0/5]  openvswitch: Introduce 128-bit unique flow identifiers.
Date: Tue, 20 Jan 2015 10:32:47 -0800
Message-Id: <1421778772-11879-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series extends the openvswitch datapath interface for flow commands to use
128-bit unique identifiers as an alternative to the netlink-formatted flow key.
This significantly reduces the cost of assembling messages between the kernel
and userspace, in particular improving Open vSwitch revalidation performance by
40% or more.

v13:
- Embed sw_flow_id in sw_flow to save memory allocation in UFID case.
- Malloc unmasked key for id in non-UFID case.
- Fix bug where non-UFID case could double-serialize keys.

v12:
- Userspace patches fully merged into Open vSwitch master
- New minor refactor patches (2,3,4)
- Merge unmasked_key, ufid representation of flow identifier in sw_flow
- Improve memory allocation sizes when serializing ufid
- Handle corner case where a flow_new is requested with a flow that has an
  identical ufid as an existing flow, but a different flow key
- Limit UFID to between 1-16 octets inclusive.
- Add various helper functions to improve readibility

v11:
- Pushed most of the prerequisite patches for this series to OVS master.
- Split out openvswitch.h interface changes from datapath implementation
- Datapath implementation to be reviewed on net-next, separately

v10:
- New patch allowing datapath to serialize masked keys
- Simplify datapath interface by accepting UFID or flow_key, but not both
- Flows set up with UFID must be queried/deleted using UFID
- Reduce sw_flow memory usage for UFID
- Don't periodically rehash UFID table in linux datapath
- Remove kernel_only UFID in linux datapath

v9:
- No kernel changes

v8:
- Rename UID -> UFID
- Fix null dereference in datapath when paired with older userspace
- All patches are reviewed/acked except datapath changes.

v7:
- Remove OVS_DP_F_INDEX_BY_UID
- Rework datapath UID serialization for variable length UIDs

v6:
- Reduce netlink conversions for all datapaths
- Various bugfixes

v5:
- Various bugfixes
- Improve logging

v4:
- Datapath memory leak fixes
- Enable UID-based terse dumping and deleting by default
- Various fixes

RFCv3:
- Add datapath implementation

Joe Stringer (5):
  openvswitch: Refactor ovs_nla_fill_match().
  openvswitch: Refactor ovs_flow_tbl_insert().
  openvswitch: Use sw_flow_key_range for key ranges.
  genetlink: Add genlmsg_parse() helper function.
  openvswitch: Add support for unique flow IDs.

 Documentation/networking/openvswitch.txt |   13 ++
 include/net/genetlink.h                  |   17 +++
 include/uapi/linux/openvswitch.h         |   20 +++
 net/openvswitch/datapath.c               |  226 ++++++++++++++++++++----------
 net/openvswitch/flow.h                   |   28 +++-
 net/openvswitch/flow_netlink.c           |  102 +++++++++++++-
 net/openvswitch/flow_netlink.h           |   13 +-
 net/openvswitch/flow_table.c             |  226 +++++++++++++++++++++++-------
 net/openvswitch/flow_table.h             |    8 +-
 9 files changed, 519 insertions(+), 134 deletions(-)

-- 
1.7.10.4

