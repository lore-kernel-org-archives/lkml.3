Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3FDOHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:07:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3FDOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 06/70] mantis: fix silly crash case
Date: Tue,  4 Jun 2013 15:06:22 +0100
Message-Id: <1370354846-14213-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit e1d45ae10aea8e8a403e5d96bf5902ee670007ff upstream.

If we set mantis->fe to NULL on an error its not a good idea to then try
passing NULL to the unregister paths and oopsing really.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=16473

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb/mantis/mantis_dvb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index e5180e4..5d15c6b 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -248,8 +248,10 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
 err5:
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
-	dvb_unregister_frontend(mantis->fe);
-	dvb_frontend_detach(mantis->fe);
+	if (mantis->fe) {
+		dvb_unregister_frontend(mantis->fe);
+		dvb_frontend_detach(mantis->fe);
+	}
 err4:
 	mantis->demux.dmx.remove_frontend(&mantis->demux.dmx, &mantis->fe_mem);
 
-- 
1.8.1.2

