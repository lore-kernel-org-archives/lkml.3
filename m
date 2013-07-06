Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3GFWRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 18:17:44 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:48273 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3GFWRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 18:17:43 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 0/3] target/vhost-scsi: Add per-cpu ida tag pre-allocation for v3.12
Date: Sat,  6 Jul 2013 22:03:20 +0000
Message-Id: <1373148203-7150-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This is an updated series for adding tag pre-allocation support of
target fabric descriptor memory, utilizing Kent's latest in-flight
per-cpu ida bits here:

   [PATCH v3] lib/idr.c rewrite, percpu ida/tag allocator
   http://marc.info/?l=linux-kernel&m=137308733526328&w=2

Patch #1 includes target-core setup of se_sess->sess_cmd_map +
se_sess->sess_tag_pool resources at session creation time, using
fabric independent code in transport_init_session_tags().

Patch #2 is the initial conversion of vhost-scsi fabric code to use
per-cpu ida logic for obtaining a new tcm_vhost_cmd descriptor via
vhost_scsi_get_tag() during vhost_work_fn_t->handle_kick() ->
vhost_scsi_handle_vq() callback execution.

And patch #3 is a vhost-scsi change that adds pre-allocation of per
tcm_vhost_cmd descriptor scatterlist + user-space page pointer memory,
that allows the last two fast-path allocations to be dropped from
tcm_vhost_submission_work() -> vhost_scsi_map_to_sgl() fast-path
execution.

Please review as v3.12 material.

Thanks!

--nab

Nicholas Bellinger (3):
  target: Add transport_init_session_tags using per-cpu ida
  vhost/scsi: Convert to per-cpu ida_alloc + ida_free command map
  vhost/scsi: Add pre-allocation for tv_cmd SGL + upages memory

 drivers/target/target_core_transport.c |   33 ++++++++
 drivers/vhost/scsi.c                   |  130 ++++++++++++++++++++++++--------
 include/target/target_core_base.h      |    5 +
 include/target/target_core_fabric.h    |    1 +
 4 files changed, 137 insertions(+), 32 deletions(-)

-- 
1.7.2.5

