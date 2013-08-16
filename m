Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3HQATZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:19:25 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:47969 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3HQATP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:19:15 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v3 0/4] target/vhost-scsi: Add per-cpu ida tag pre-allocation for v3.12
Date: Fri, 16 Aug 2013 23:09:05 +0000
Message-Id: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This is an updated series for adding tag pre-allocation support of
target fabric descriptor memory, utilizing Kent's latest per-cpu ida
bits here, along with Christoph Lameter's latest comments:

   [PATCH 04/10] idr: Percpu ida
   http://marc.info/?l=linux-kernel&m=137160026006974&w=2

The first patch is a standalone version of per-cpu-ida, seperate from
the full idr rewrite from Kent that is still being discussed.  Given
that I have a number of other target items aside from this series that
depend on this code, I'd like to go ahead and include this standalone
version into target-pending/for-next as a v3.12 item.

Jens has also expressed interest in a blk-mq conversion to use these
per-cpu-ida primatives, so getting this piece merged for v3.12 would
make life easier for both of us.  ;)

The second patch includes target-core setup of se_sess->sess_cmd_map +
se_sess->sess_tag_pool resources at session creation time, using
fabric independent code in transport_init_session_tags().

The third patch is the initial conversion of vhost-scsi fabric code
to use per-cpu ida logic for obtaining a new tcm_vhost_cmd descriptor
via vhost_scsi_get_tag() during vhost_work_fn_t->handle_kick() ->
vhost_scsi_handle_vq() callback execution.

And the forth patch is a vhost-scsi change that adds pre-allocation of
per tcm_vhost_cmd descriptor scatterlist + user-space page pointer
memory, that allows the last two fast-path allocations to be dropped
from tcm_vhost_submission_work() -> vhost_scsi_map_to_sgl() fast-path
execution.

Please review as v3.12 material.

Thanks!

--nab

Kent Overstreet (1):
  idr: Percpu ida

Nicholas Bellinger (3):
  target: Add transport_init_session_tags using per-cpu ida
  vhost/scsi: Convert to per-cpu ida_alloc + ida_free command map
  vhost/scsi: Add pre-allocation for tv_cmd SGL + upages memory

 drivers/target/target_core_transport.c |   33 ++++
 drivers/vhost/scsi.c                   |  132 +++++++++----
 include/linux/idr.h                    |   53 ++++++
 include/target/target_core_base.h      |    5 +
 include/target/target_core_fabric.h    |    1 +
 lib/idr.c                              |  316 +++++++++++++++++++++++++++++++-
 6 files changed, 501 insertions(+), 39 deletions(-)

-- 
1.7.10.4

