Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3IKEaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3IKE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:55 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=V2vx2PFyenEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5f8nCWy8MNgA:10 a=VwQbUJbxAAAA:8 a=79SWGuG1IPVX6XBPgOMA:9 a=0kPLrQdw3YYA:10 a=WMO-rUWO3a4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042852.874990716@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [004/251] ALSA: seq-oss: Initialize MIDI clients asynchronously
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0004-ALSA-seq-oss-Initialize-MIDI-clients-asynchronously.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 256ca9c3ad5013ff8a8f165e5a82fab437628c8e ]

We've got bug reports that the module loading stuck on Debian system
with 3.10 kernel.  The debugging session revealed that the initial
registration of OSS sequencer clients stuck at module loading time,
which involves again with request_module() at the init phase.  This is
triggered only by special --install stuff Debian is using, but it's
still not good to have such loops.

As a workaround, call the registration part asynchronously.  This is a
better approach irrespective of the hang fix, in anyway.

Reported-and-tested-by: Philipp Matthias Hahn <pmhahn@pmhahn.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/core/seq/oss/seq_oss_init.c |   16 +++++++++++++---
 sound/core/seq/oss/seq_oss_midi.c |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index e3cb46f..b3f39b5 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -31,6 +31,7 @@
 #include <linux/export.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 /*
  * common variables
@@ -60,6 +61,14 @@ static void free_devinfo(void *private);
 #define call_ctl(type,rec) snd_seq_kernel_client_ctl(system_client, type, rec)
 
 
+/* call snd_seq_oss_midi_lookup_ports() asynchronously */
+static void async_call_lookup_ports(struct work_struct *work)
+{
+	snd_seq_oss_midi_lookup_ports(system_client);
+}
+
+static DECLARE_WORK(async_lookup_work, async_call_lookup_ports);
+
 /*
  * create sequencer client for OSS sequencer
  */
@@ -85,9 +94,6 @@ snd_seq_oss_create_client(void)
 	system_client = rc;
 	debug_printk(("new client = %d\n", rc));
 
-	/* look up midi devices */
-	snd_seq_oss_midi_lookup_ports(system_client);
-
 	/* create annoucement receiver port */
 	memset(port, 0, sizeof(*port));
 	strcpy(port->name, "Receiver");
@@ -115,6 +121,9 @@ snd_seq_oss_create_client(void)
 	}
 	rc = 0;
 
+	/* look up midi devices */
+	schedule_work(&async_lookup_work);
+
  __error:
 	kfree(port);
 	return rc;
@@ -160,6 +169,7 @@ receive_announce(struct snd_seq_event *ev, int direct, void *private, int atomic
 int
 snd_seq_oss_delete_client(void)
 {
+	cancel_work_sync(&async_lookup_work);
 	if (system_client >= 0)
 		snd_seq_delete_kernel_client(system_client);
 
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 677dc84..862d8489 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -72,7 +72,7 @@ static int send_midi_event(struct seq_oss_devinfo *dp, struct snd_seq_event *ev,
  * look up the existing ports
  * this looks a very exhausting job.
  */
-int __init
+int
 snd_seq_oss_midi_lookup_ports(int client)
 {
 	struct snd_seq_client_info *clinfo;
-- 
1.7.10.4


