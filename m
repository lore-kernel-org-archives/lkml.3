Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3ETHOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:14:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab3ETHMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:12:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,706,1363104000"; 
   d="scan'208";a="7310995"
From: Ren Mingxin <renmx@cn.fujitsu.com>
To: James.Bottomley@HansenPartnership.com, james.smart@emulex.com,
        Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com,
        michaelc@cs.wisc.edu
Cc: robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de,
        bprakash@broadcom.com, agk@redhat.com, neilb@suse.de,
        gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/5] scsi: Allow fast io fail without waiting through timeout
Date: Mon, 20 May 2013 15:14:58 +0800
Message-Id: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/20 15:11:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/20 15:11:03,
	Serialize complete at 2013/05/20 15:11:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there is a scsi command timed-out or failed, the scsi eh
tries a thorugh recovery, which is necessary for non-redundant
systems. However, the thorugh recovery usually takes much time,
which is not acceptable for misson critical systems. To improve
this latency, if we are working on a redundant system, we should
avoid the scsi eh for its long time failing recovery, and quick
failover to another path.

This set of patches is trying to implement above.

NOTE: the userland tools need to eusure the environment
restriction, which will be implemented later.

Thanks,
Ren

Ren Mingxin (5):
  scsi: rename return code FAST_IO_FAIL to FAST_IO
  FC transport: Add interface to specify fast io level for timed-out cmds
  SAS transport: Add interface to specify fast io level for timed-out cmds
  lpfc: Allow fast timed-out io recovery
  mptfusion: Allow fast timed-out io recovery

 drivers/message/fusion/mptscsih.c   |   29 ++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c       |   34 ++++++++++
 drivers/scsi/scsi_error.c           |   18 ++---
 drivers/scsi/scsi_sas_internal.h    |    4 -
 drivers/scsi/scsi_transport_fc.c    |  112 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/scsi_transport_iscsi.c |    6 -
 drivers/scsi/scsi_transport_sas.c   |  103 ++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h                 |    2 
 include/scsi/scsi_transport_fc.h    |   11 +++
 include/scsi/scsi_transport_sas.h   |    8 ++
 10 files changed, 303 insertions(+), 24 deletions(-)

