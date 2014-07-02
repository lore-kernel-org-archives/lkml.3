Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbaGBTgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:36:02 -0400
Received: from p02c11o143.mxlogic.net ([208.65.144.76]:47470 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaGBTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:36:00 -0400
X-MXL-Hash: 53b45f203bd7d931-ac039f2ed289eae12e71e1f16fd002c7c204f500
X-MXL-Hash: 53b45f1146536c6a-5d92fa150b62ad0f101aac61030a0f23bfc437b3
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
Date: Wed, 2 Jul 2014 15:35:15 -0400
Message-ID: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=E9FDpMtl c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=P6_3lDKxg5cA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=DVZht-lom0_DqD6U3boA:9]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014070216); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3: rebase to 3.16-rc2, consider return values from the
        blk_mq_alloc_request leg of the blk_get_request callchain
        (noted by Jeff), noted in the second patch changelog.

	blk_mq_queue_enter may return 0 or errno, which
        blk_mq_alloc_request can propogate out via ERR_PTR.
	__blk_mq_alloc_request doesn't include any blk_queue_dying
	checks, so I'm assuming that its failures can be attributed
        to -EWOULDBLOCK under !GFP_WAIT conditions.

v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
        tags.

Joe Lawrence (2):
  block,scsi: verify return pointer from blk_get_request
  block,scsi: fixup blk_get_request dead queue scenarios

 block/blk-core.c                            |   34 +++++++++++++--------------
 block/blk-mq.c                              |    8 +++++--
 block/bsg.c                                 |    8 +++----
 block/scsi_ioctl.c                          |   13 +++++++---
 drivers/block/paride/pd.c                   |    2 ++
 drivers/block/pktcdvd.c                     |    2 ++
 drivers/block/sx8.c                         |    2 +-
 drivers/cdrom/cdrom.c                       |    4 ++--
 drivers/ide/ide-park.c                      |    2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    2 +-
 drivers/scsi/osd/osd_initiator.c            |    4 ++--
 drivers/scsi/osst.c                         |    2 +-
 drivers/scsi/scsi_error.c                   |    2 ++
 drivers/scsi/scsi_lib.c                     |    2 +-
 drivers/scsi/scsi_tgt_lib.c                 |    2 +-
 drivers/scsi/sg.c                           |    4 ++--
 drivers/scsi/st.c                           |    2 +-
 drivers/target/target_core_pscsi.c          |    2 +-
 21 files changed, 61 insertions(+), 44 deletions(-)

-- 
1.7.10.4

