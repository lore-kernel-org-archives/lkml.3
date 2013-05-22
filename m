Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3EVWT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:19:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3EVWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:19:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 3/3] media: mantis: fix silly crash case
Date: Wed, 22 May 2013 15:19:45 -0700
Message-Id: <20130522221335.222721682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522221334.510217272@linuxfoundation.org>
References: <20130522221334.510217272@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit e1d45ae10aea8e8a403e5d96bf5902ee670007ff upstream.

If we set mantis->fe to NULL on an error its not a good idea to then try
passing NULL to the unregister paths and oopsing really.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=16473

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


