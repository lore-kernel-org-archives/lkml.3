Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab3GWWvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:51:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934560Ab3GWW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 032/103] ALSA: seq-oss: Initialize MIDI clients asynchronously
Date: Tue, 23 Jul 2013 15:25:43 -0700
Message-Id: <20130723220422.131661466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 256ca9c3ad5013ff8a8f165e5a82fab437628c8e upstream.

We've got bug reports that the module loading stuck on Debian system
with 3.10 kernel.  The debugging session revealed that the initial
registration of OSS sequencer clients stuck at module loading time,
which involves again with request_module() at the init phase.  This is
triggered only by special --install stuff Debian is using, but it's
still not good to have such loops.

As a workaround, call the registration part asynchronously.  This is a
better approach irrespective of the hang fix, in anyway.

Reported-and-tested-by: Philipp Matthias Hahn <pmhahn@pmhahn.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/oss/seq_oss_init.c |   16 +++++++++++++---
 sound/core/seq/oss/seq_oss_midi.c |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

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
@@ -160,6 +169,7 @@ receive_announce(struct snd_seq_event *e
 int
 snd_seq_oss_delete_client(void)
 {
+	cancel_work_sync(&async_lookup_work);
 	if (system_client >= 0)
 		snd_seq_delete_kernel_client(system_client);
 
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -72,7 +72,7 @@ static int send_midi_event(struct seq_os
  * look up the existing ports
  * this looks a very exhausting job.
  */
-int __init
+int
 snd_seq_oss_midi_lookup_ports(int client)
 {
 	struct snd_seq_client_info *clinfo;


