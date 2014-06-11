Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaFKORN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:17:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39505 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbaFKORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:17:12 -0400
Date: Wed, 11 Jun 2014 08:17:06 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <hch@lst.de>
Subject: [GIT PULL] Block IO changes for -rc1
Message-ID: <20140611141706.GA22793@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-11_04:2014-06-11,2014-06-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.08638653628645e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.994525499955221
 urlsuspect_oldscore=0.994525499955221 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.994525499955221 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406110176
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Final small batch of fixes to be included before -rc1. Some general
cleanups in here as well, but some of the blk-mq fixes we need for the
NVMe conversion and/or scsi-mq. The pull request contains:

- Support for not merging across a specified "chunk size", if set by the
  driver. Some NVMe devices perform poorly for IO that crosses such a
  chunk, so we need to support it generically as part of request merging
  avoid having to do complicated split logic. From me.

- Bump max tag depth to 10Ki tags. Some scsi devices have a huge shared
  tag space. Before we failed with EINVAL if a too large tag depth was
  specified, now we truncate it and pass back the actual value. From me.

- Various blk-mq rq init fixes from me and others.

- A fix for enter on a dying queue for blk-mq from Keith. This is needed
  to prevent oopsing on hot device removal.

- Fixup for blk-mq timer addition from Ming Lei.

- Small round of performance fixes for mtip32xx from Sam Bradshaw.

- Minor stack leak fix from Rickard Strandqvist.

- Two __init annotations from Fabian Frederick.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Fabian Frederick (2):
      block: add __init to elv_register
      block: add __init to blkcg_policy_register

Jens Axboe (6):
      block: add notion of a chunk size for request merging
      block: add blk_rq_set_block_pc()
      blk-mq: bump max tag depth to 10K tags
      blk-mq: ->timeout should be cleared in blk_mq_rq_ctx_init()
      blk-mq: always initialize request->start_time
      block: ensure that bio_add_page() always accepts a page for an empty bio

Keith Busch (1):
      blk-mq: don't allow queue entering for a dying queue

Ming Lei (1):
      blk-mq: add timer in blk_mq_start_request

Rickard Strandqvist (1):
      block: blk-exec.c: Cleaning up local variable address returnd

Sam Bradshaw (1):
      mtip32xx: minor performance enhancements

 block/bio.c                                 |  8 +++++-
 block/blk-cgroup.c                          |  2 +-
 block/blk-cgroup.h                          |  4 +--
 block/blk-core.c                            | 18 ++++++++++++
 block/blk-exec.c                            |  5 ++++
 block/blk-mq.c                              | 43 ++++++++++++++---------------
 block/blk-settings.c                        | 21 ++++++++++++++
 block/bsg.c                                 |  3 +-
 block/elevator.c                            |  2 +-
 block/scsi_ioctl.c                          |  6 ++--
 drivers/block/mtip32xx/mtip32xx.c           | 15 ++++++----
 drivers/block/mtip32xx/mtip32xx.h           |  8 +++---
 drivers/block/pktcdvd.c                     |  2 +-
 drivers/cdrom/cdrom.c                       |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 +--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 +--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  3 +-
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/sg.c                           |  3 +-
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  3 +-
 include/linux/blk-mq.h                      |  2 +-
 include/linux/blkdev.h                      | 23 ++++++++++++++-
 include/linux/elevator.h                    |  2 +-
 28 files changed, 135 insertions(+), 60 deletions(-)

-- 
Jens Axboe

