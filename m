Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3HRXwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:52:09 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:32889 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab3HRXwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:52:07 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 0/4] iscsi-target: Add support for login multi-plexing support
Date: Sun, 18 Aug 2013 23:36:21 +0000
Message-Id: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This -v2 series for v3.12-rc1 adds support for login multi-plexing,
that allows subsequent login request/request PDUs beyond the initial 
exchange to be pushed off to workqueue process context, so that other
incoming login requests can be serviced in parallel.

This addresses a long-standing issue with login latency with many (100's)
of parallel login requests to the same network portal being shared
across many (100's) of TargetName+TargetPortalGroup endpoints.

Note that login negotiation to the same TargetName+TargetPortalGroup
endpoint is still sychronized in order to enforce session reinstatement
state machines.

The changes for v2 include:

  - Fix iscsit_transport reference leak during NP thread reset
  - Remove duplicate call to iscsi_post_login_handler() in
    __iscsi_target_login_thread()
  - Drop unused iscsi_np->np_login_tpg
  - Add login_timer in iscsi_target_do_login_rx() to avoid
    possible endless sleep with MSG_WAITALL for traditional
    iscsi-target in certain network configurations.
  - Convert lprintk() -> pr_debug()
  - Remove forward declarations of iscsi_target_set_sock_callbacks(),
    iscsi_target_restore_sock_callbacks() and iscsi_target_sk_data_ready()
  - Make iscsi_target_set_sock_callbacks + iscsi_target_restore_sock_callbacks()
    static (Fengguang)
  - Make iscsi_target_do_login_rx() safe for iser-target w/o conn->sock
  - Updates to iser-target for login negotiation multi-plexing support

The main remaining FIXME is to keep track of connections that are pushed
out to workqueue process context for explicit network portal shutdown
purposes.

Thanks!

--nab

Nicholas Bellinger (4):
  iscsi-target: Fix iscsit_transport reference leak during NP thread
    reset
  iscsi-target: Prepare login code for multi-plexing support
  iscsi-target: Add login negotiation multi-plexing support
  iser-target: Updates for login negotiation multi-plexing support

 drivers/infiniband/ulp/isert/ib_isert.c   |   17 +++-
 drivers/target/iscsi/iscsi_target.c       |   53 ++++----
 drivers/target/iscsi/iscsi_target.h       |    6 +-
 drivers/target/iscsi/iscsi_target_core.h  |   12 ++-
 drivers/target/iscsi/iscsi_target_login.c |  171 +++++++++++++----------
 drivers/target/iscsi/iscsi_target_login.h |    3 +
 drivers/target/iscsi/iscsi_target_nego.c  |  209 +++++++++++++++++++++++++++-
 drivers/target/iscsi/iscsi_target_tpg.c   |   23 +++-
 drivers/target/iscsi/iscsi_target_tpg.h   |    4 +-
 9 files changed, 378 insertions(+), 120 deletions(-)

-- 
1.7.2.5

