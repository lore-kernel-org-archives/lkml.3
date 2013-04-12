Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3DLVET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:04:19 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:51917 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3DLVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:04:17 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>,
        Alexander Nezhinsky <alexandern@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC-v4 0/9] Add support for iSCSI Extensions for RDMA (ISER) target mode
Date: Fri, 12 Apr 2013 20:52:33 +0000
Message-Id: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series is the forth RFC for iSCSI Extensions for RDMA (ISER) target
mode support planned for an upcoming v3.10 merge.  This series refactors
existing traditional iscsi-target mode logic in order for external
ib_isert.ko module code to function with areas common to traditional
TCP socket based iSCSI and RDMA verbs based ISER operation.

This includes a basic iscsit_transport API that allows different transports
to reside under the existing iscsi-target configfs control plane, using an
pre-defined network portal attribute to enable a rdma_cm listener on top
of existing ipoib portals.

At this point the code is functional and pushing sustained RDMA_WRITE +
RDMA_READ traffic using open-iscsi on top of multiple iser network portals +
multiple IB HCA ports + multiple LUNs.  Thus far we're using Mellanox IB HCAs
for initial development, and will be verfiying with RoCE capable NICs as well
in the near future.

This RFC-v4 code is available in git against v3.9-rc3 here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git iser_target-rfc-v4

Changes since RFC-v3 include:

    - Mark isert_cq_rx_work as static (Or)
    - Drop unnecessary ib_dma_sync_single_for_cpu + ib_dma_sync_single_for_device
      calls for isert_cmd->sense_buf_dma from isert_put_response (Or)
    - Use 12288 for ISER_RX_PAD_SIZE base to save extra page per
      struct iser_rx_desc (Or + nab)
    - Drop now unnecessary isert_rx_desc usage, and convert RX users to
      iser_rx_desc (Or + nab)
    - Move isert_[alloc,free]_rx_descriptors() ahead of
      isert_create_device_ib_res() usage (nab)
    - Mark isert_cq_[rx,tx]_callback() + prototypes as static
    - Fix 'warning: 'ret' may be used uninitialized' warning for
      isert_create_device_ib_res on powerpc allmodconfig (fengguang + nab)
    - Fix 'warning: 'ret' may be used uninitialized' warning for
      isert_connect_request on i386 allyesconfig (fengguang + nab)
    - Fix pr_debug conversion specification in isert_rx_completion()
      (fengguang + nab)
    - Drop unnecessary isert_conn->conn_cm_id != NULL check in
      isert_connect_release causing the build warning:
      "variable dereferenced before check 'isert_conn->conn_cm_id'"
    - Fix isert_lid + isert_np leak in isert_setup_np failure path
    - Add isert_conn->conn_wait_comp_err usage in isert_free_conn()
      for isert_cq_comp_err completion path
    - Add isert_conn->logout_posted bit to determine decrement of
      isert_conn->post_send_buf_count from logout response completion
    - Always set ISER_CONN_DOWN from isert_disconnect_work() callback
    - Add request_module for ib_isert to lio_target_np_store_iser()
    - Add missing iscsit_put_transport() call in iscsi_target_setup_login_socket()
      failure case

RFC-v4 has been rebased this afternoon into target-pending for-next/for-next-merge
to be picked up by monday's -next build.

Please review.

--nab

Nicholas Bellinger (9):
  target: Add export of target_get_sess_cmd symbol
  iscsi-target: Add iscsit_transport API template
  iscsi-target: Initial traditional TCP conversion to iscsit_transport
  iscsi-target: Add iser-target parameter keys + setup during login
  iscsi-target: Add per transport iscsi_cmd alloc/free
  iscsi-target: Refactor RX PDU logic + export request PDU handling
  iscsi-target: Refactor TX queue logic + export response PDU creation
  iscsi-target: Add iser network portal attribute
  iser-target: Add iSCSI Extensions for RDMA (iSER) target driver

 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/Makefile                    |    1 +
 drivers/infiniband/ulp/isert/Kconfig           |    6 +
 drivers/infiniband/ulp/isert/Makefile          |    2 +
 drivers/infiniband/ulp/isert/ib_isert.c        | 2264 ++++++++++++++++++++++++
 drivers/infiniband/ulp/isert/ib_isert.h        |  138 ++
 drivers/infiniband/ulp/isert/isert_proto.h     |   47 +
 drivers/target/iscsi/Makefile                  |    3 +-
 drivers/target/iscsi/iscsi_target.c            | 1169 ++++++++-----
 drivers/target/iscsi/iscsi_target.h            |    3 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   98 +-
 drivers/target/iscsi/iscsi_target_core.h       |   26 +-
 drivers/target/iscsi/iscsi_target_device.c     |    7 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |   13 +-
 drivers/target/iscsi/iscsi_target_login.c      |  472 ++++--
 drivers/target/iscsi/iscsi_target_login.h      |    6 +
 drivers/target/iscsi/iscsi_target_nego.c       |  182 +--
 drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   87 +-
 drivers/target/iscsi/iscsi_target_parameters.h |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_transport.c  |   55 +
 drivers/target/iscsi/iscsi_target_util.c       |   53 +-
 drivers/target/iscsi/iscsi_target_util.h       |    1 +
 drivers/target/target_core_transport.c         |    4 +-
 include/target/iscsi/iscsi_transport.h         |   83 +
 include/target/target_core_fabric.h            |    2 +-
 28 files changed, 3934 insertions(+), 826 deletions(-)
 create mode 100644 drivers/infiniband/ulp/isert/Kconfig
 create mode 100644 drivers/infiniband/ulp/isert/Makefile
 create mode 100644 drivers/infiniband/ulp/isert/ib_isert.c
 create mode 100644 drivers/infiniband/ulp/isert/ib_isert.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
 create mode 100644 include/target/iscsi/iscsi_transport.h

-- 
1.7.2.5

