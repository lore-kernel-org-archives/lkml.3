Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbaKUJbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:31:03 -0500
Received: from mout.web.de ([212.227.15.14]:55132 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbaKUJbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:31:00 -0500
Message-ID: <546F0642.4060007@users.sourceforge.net>
Date: Fri, 21 Nov 2014 10:30:42 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] target: Deletion of unnecessary checks before the function
 call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:iPjx0GbdTAfrif+y7qtsq06ytVe/MgSkskyxsG9Pe4rG7jHuFDl
 QUEHxZaeVd8bYAud6glWOKq4VcUbKjkUSlQPyOIHtwIFyhIt05VLOGzjAG3gbobfLzB7gVF
 jNfw6kQSVzHYRqZhBYGPYii+wZsKZsh5dCPLoHwig242kwNaL9LDgo7WKgJ+lczEsAvOgy4
 bwNTI22sMxDDBhtfjgy9A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 10:25:45 +0100

The module_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_transport.c | 3 +--
 drivers/target/target_core_hba.c              | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
index 882728f..08217d6 100644
--- a/drivers/target/iscsi/iscsi_target_transport.c
+++ b/drivers/target/iscsi/iscsi_target_transport.c
@@ -26,8 +26,7 @@ struct iscsit_transport *iscsit_get_transport(int type)
 
 void iscsit_put_transport(struct iscsit_transport *t)
 {
-	if (t->owner)
-		module_put(t->owner);
+	module_put(t->owner);
 }
 
 int iscsit_register_transport(struct iscsit_transport *t)
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index a25051a..e6e496f 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -137,8 +137,7 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 	return hba;
 
 out_module_put:
-	if (hba->transport->owner)
-		module_put(hba->transport->owner);
+	module_put(hba->transport->owner);
 	hba->transport = NULL;
 out_free_hba:
 	kfree(hba);
@@ -159,8 +158,7 @@ core_delete_hba(struct se_hba *hba)
 	pr_debug("CORE_HBA[%d] - Detached HBA from Generic Target"
 			" Core\n", hba->hba_id);
 
-	if (hba->transport->owner)
-		module_put(hba->transport->owner);
+	module_put(hba->transport->owner);
 
 	hba->transport = NULL;
 	kfree(hba);
-- 
2.1.3

