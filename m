Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3E1DzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52531 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758837Ab3E1DyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Cox" <alan@linux.intel.com>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.514872606@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [92/94] [media] mantis: fix silly crash case
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit e1d45ae10aea8e8a403e5d96bf5902ee670007ff upstream.

If we set mantis->fe to NULL on an error its not a good idea to then try
passing NULL to the unregister paths and oopsing really.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=16473

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/mantis/mantis_dvb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -248,8 +248,10 @@ int __devinit mantis_dvb_init(struct man
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
 

