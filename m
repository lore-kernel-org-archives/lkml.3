Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3LXOVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 09:21:11 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61985 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3LXOVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 09:21:08 -0500
Date: Tue, 24 Dec 2013 09:21:04 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.13-rc5
Message-ID: <20131224142104.GA3512@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

libata fixes for v3.13-rc5.  There's one interseting commit - "libata,
freezer: avoid block device removal while system is frozen".  It's an
ugly hack working around a deadlock condition between driver core
resume and block layer device removal paths through freezer which was
made more reproducible by writeback being converted to workqueue some
releases ago.  The bug has nothing to do with libata but it's just an
workaround which is easy to backport.  After discussion, Rafael and I
seem to agree that we don't really need kernel freezables - both
kthread and workqueue.  There are few specific workqueues which
constitute PM operations and require freezing, which will be converted
to use workqueue_set_max_active() instead.  All other kernel freezer
uses are planned to be removed, followed by the removal of kthread and
workqueue freezer support, hopefully.

Others are device-specific fixes.  The most notable is the addition of
NO_NCQ_TRIM which is used to disable queued TRIM commands to Micro
M500 SSDs which otherwise suffers data corruption.

The following changes since commit c5700766975c69d27150256444db63fbfd103791:

  ATA: Fix port removal ordering (2013-11-27 13:55:16 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.13-fixes

for you to fetch changes up to 85fbd722ad0f5d64d1ad15888cd1eb2188bfb557:

  libata, freezer: avoid block device removal while system is frozen (2013-12-19 13:50:32 -0500)

Thanks.
----------------------------------------------------------------
Marc Carino (1):
      libata: implement ATA_HORKAGE_NO_NCQ_TRIM and apply it to Micro M500 SSDs

Marek Vasut (1):
      ahci: imx: Explicitly clear IMX6Q_GPR13_SATA_MPLL_CLK_EN

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8

Paul Bolle (1):
      ahci: bail out on ICH6 before using AHCI BAR

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Tejun Heo (1):
      libata, freezer: avoid block device removal while system is frozen

 Documentation/kernel-parameters.txt |  2 ++
 drivers/ata/ahci.c                  | 18 +++++++++---------
 drivers/ata/ahci_imx.c              |  3 ++-
 drivers/ata/libata-core.c           | 19 +++++++++++++++++--
 drivers/ata/libata-scsi.c           | 21 +++++++++++++++++++++
 include/linux/libata.h              |  1 +
 kernel/freezer.c                    |  6 ++++++
 7 files changed, 58 insertions(+), 12 deletions(-)

-- 
tejun
