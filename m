Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaE2U7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:59:12 -0400
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:47865 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaE2U7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:59:11 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2014 16:59:11 EDT
X-MXL-Hash: 53879f9f24b78f88-c17c0cce423384b7fe015f792c6be1ee3042ca9a
X-MXL-Hash: 53879dbb76da6d1d-df211a3c3891c61de24a6037108252086e43a193
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 0/2] block,scsi: fixup blk_get_request dead queue scenarios
Date: Thu, 29 May 2014 16:48:47 -0400
Message-ID: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=S9JXwecP c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=ts4K_s6nORMA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=TSbVqHtbAAAA:8 a=ybkoTBZV1DTpBp]
X-AnalysisOut: [Hn9ZIA:9]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014052923); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

This bug was originally reported against 3.10 and still exists in
3.15-rc5 [1] [2].  

These changes were tested on-top of 3.15-rc5 with user-program that
opens a CD device, its media is removed, and then the program issues a
CDROMEJECT ioctl.  Without this change, the kernel can crash in
sg_scsi_ioctl on NULL request pointer.

The first patch adds return checking to a few blk_get_request callers.
The second patch is much larger, modifying the return value to include
an ERR_PTR to indicate failure reason.  I didn't touch any of the IDE
callers save one since all but that one assume success.  As such, the
first can be merged without the second if the change is considered too
dangerous.

Feel free to drop any changes to files (like paride/pd.c) if they're
considered deprecated.

[1] http://thread.gmane.org/gmane.linux.scsi/80934
[2] http://thread.gmane.org/gmane.linux.kernel/1502882

Joe Lawrence (2):
  block,scsi: verify return pointer from blk_get_request
  block,scsi: convert and handle ERR_PTR from blk_get_request

 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          | 13 ++++++++---
 drivers/block/paride/pd.c                   |  2 ++
 drivers/block/pktcdvd.c                     |  2 ++
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 ++
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  2 +-
 20 files changed, 55 insertions(+), 42 deletions(-)

-- 
1.8.3.1

