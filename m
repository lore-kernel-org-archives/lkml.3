Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3HaDIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 23:08:43 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52761 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3HaDIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 23:08:42 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Asias He <asias@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v5 0/6] target/vhost/iscsi: Add per-cpu ida tag pre-allocation for v3.12
Date: Sat, 31 Aug 2013 02:52:30 +0000
Message-Id: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This is an updated -v5 series for adding tag pre-allocation support of
target fabric descriptor memory, utilizing Kent's latest per-cpu ida
bits and incorporates akpm's last round of feedback.  The full -v5
changelog is included below.

The first patch is a standalone version of per-cpu-ida, seperate from
the full idr rewrite from Kent that is still being discussed.  Jens has
also expressed interest in a blk-mq conversion to use these per-cpu-ida
primatives, so getting this piece merged for v3.12 would make life easier
for both of us.  ;)

The second patch includes target-core setup of se_sess->sess_cmd_map +
se_sess->sess_tag_pool resources at session creation time, using
fabric independent code in transport_init_session_tags().

The third patch is the initial conversion of vhost-scsi fabric code
to use per-cpu ida logic for obtaining a new tcm_vhost_cmd descriptor
via vhost_scsi_get_tag() during vhost_work_fn_t->handle_kick() ->
vhost_scsi_handle_vq() callback execution.

The forth patch is a vhost-scsi change that adds pre-allocation of
per tcm_vhost_cmd descriptor scatterlist + user-space page pointer
memory, that allows the last two fast-path allocations to be dropped
from tcm_vhost_submission_work() -> vhost_scsi_map_to_sgl() fast-path
execution.

The fifth patch converts iscsi/iser-target to use allocations based on
iscsit_transport->priv_size within iscsit_allocate_cmd(), instead of
using an embedded isert_cmd->iscsi_cmd.  This makes the conversion to
percpu-ida pre-allocation easier.

And the sixth patch enables iscsi-target to use pre-allocation logic for
per-cpu session tag pooling with internal ida_alloc() + ida_free() calls
based upon the saved iscsi_cmd->se_cmd.map_tag id.

v5 changes:

  - Change percpu_ida->cpus_have_tags to cpumask_t (kmo + akpm)
  - Add comment for percpu_ida_cpu->lock + ->nr_free (kmo + akpm)
  - Convert steal_tags() to use cpumask_weight() + cpumask_next() +
    cpumask_first() + cpumask_clear_cpu() (kmo + akpm)
  - Add comment for alloc_global_tags() (kmo + akpm)
  - Convert percpu_ida_alloc() to use cpumask_set_cpu() (kmo + akpm)
  - Convert percpu_ida_free() to use cpumask_set_cpu() (kmo + akpm)
  - Drop percpu_ida->cpus_have_tags allocation in percpu_ida_init()
    (kmo + akpm)
  - Drop percpu_ida->cpus_have_tags kfree in percpu_ida_destroy()
    (kmo + akpm)
  - Add comment for percpu_ida_alloc @ gfp (kmo + akpm)
  - Move to percpu_ida.c + percpu_ida.h (kmo + akpm + nab)
  - Convert target/vhost/iscsi-target to use percpu_ida.h (nab)

Please review as v3.12 material.

Thank you,

--nab

Kent Overstreet (1):
  idr: Percpu ida

Nicholas Bellinger (5):
  target: Add transport_init_session_tags using per-cpu ida
  vhost/scsi: Convert to per-cpu ida_alloc + ida_free command map
  vhost/scsi: Add pre-allocation for tv_cmd SGL + upages memory
  iscsi/iser-target: Convert to command priv_size usage
  iscsi-target: Convert to per-cpu ida_alloc + ida_free command map

 drivers/infiniband/ulp/isert/ib_isert.c      |  114 +++------
 drivers/infiniband/ulp/isert/ib_isert.h      |    2 +-
 drivers/target/iscsi/iscsi_target.c          |   16 +--
 drivers/target/iscsi/iscsi_target.h          |    1 -
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 drivers/target/iscsi/iscsi_target_core.h     |    3 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   28 ++-
 drivers/target/iscsi/iscsi_target_util.c     |   41 ++--
 drivers/target/target_core_transport.c       |   48 ++++
 drivers/vhost/scsi.c                         |  132 ++++++++---
 include/linux/percpu_ida.h                   |   59 +++++
 include/target/iscsi/iscsi_transport.h       |    8 +-
 include/target/target_core_base.h            |    5 +
 include/target/target_core_fabric.h          |    3 +
 lib/Makefile                                 |    5 +-
 lib/percpu_ida.c                             |  335 ++++++++++++++++++++++++++
 16 files changed, 652 insertions(+), 150 deletions(-)
 create mode 100644 include/linux/percpu_ida.h
 create mode 100644 lib/percpu_ida.c

-- 
1.7.2.5

