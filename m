Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968Ab3FUT4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:56:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945935Ab3FUT4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:56:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: line6: avoid __sync_fetch_and_{and,or}
Date: Fri, 21 Jun 2013 21:55:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306212155.36196.arnd@arndb.de>
X-Provags-ID: V02:K0:uP0ff6iZq55/58U7kB2cPaHc/LT3ccOMCRxQjZB4kY5
 3aFp+AQHGepYTD3KXaepHoTnMlIa8etA/3efhc68dkYrER7pxl
 zrax/3PLydmOUpJSrliiJUbNNcGEoeCie+wj6VhONRnHUsUMta
 lg9Zl1HhBIpsTVwAYEZmeRUsXQM3CFoEFsVlTXwIJv5KO3q/jv
 iedPs+qnBSRSfl2GSlRsTrz7DWvPEs8zoWVbyBTvqmzFNeQNBW
 BnIx4gb0ACQY6ihuoMWJXFP0l8Z5dcVHIEYuNNMqwM9je0yNfY
 zOojP6rxZxLFZ144McK47sHRo9FRkk5YrbgsOXbT9kZniXlZiI
 RKkKn8eAtsnSHKBDQFmA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__sync_fetch_and_and and __sync_fetch_and_or are functions that are provided
by gcc and depending on the target architecture may be implemented in libgcc,
which is not always available in the kernel. This leads to a build failure
on ARMv5:

drivers/built-in.o: In function `line6_pcm_release':
:(.text+0x3bfe80): undefined reference to `__sync_fetch_and_and_4'
drivers/built-in.o: In function `line6_pcm_acquire':
:(.text+0x3bff30): undefined reference to `__sync_fetch_and_or_4'

To work around this, we can use the kernel-provided cmpxchg macro.

Build-tested only.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Markus Grabner <grabner@icg.tugraz.at>

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 02f77d7..4795f12 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -107,11 +107,15 @@ static bool test_flags(unsigned long flags0, unsigned long flags1,
 
 int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
 {
-	unsigned long flags_old =
-	    __sync_fetch_and_or(&line6pcm->flags, channels);
-	unsigned long flags_new = flags_old | channels;
-	unsigned long flags_final = flags_old;
-	int err = 0;
+	unsigned long flags_old, flags_new, flags_final;
+	int err;
+
+	do {
+		flags_old = ACCESS_ONCE(line6pcm->flags);
+		flags_new = flags_old | channels;
+	} while (cmpxchg(&line6pcm->flags, flags_old, flags_new) != flags_old);
+
+	flags_final = flags_old;
 
 	line6pcm->prev_fbuf = NULL;
 
@@ -197,9 +201,12 @@ pcm_acquire_error:
 
 int line6_pcm_release(struct snd_line6_pcm *line6pcm, int channels)
 {
-	unsigned long flags_old =
-	    __sync_fetch_and_and(&line6pcm->flags, ~channels);
-	unsigned long flags_new = flags_old & ~channels;
+	unsigned long flags_old, flags_new;
+
+	do {
+		flags_old = ACCESS_ONCE(line6pcm->flags);
+		flags_new = flags_old & ~channels;
+	} while (cmpxchg(&line6pcm->flags, flags_old, flags_new) != flags_old);
 
 	if (test_flags(flags_new, flags_old, LINE6_BITS_CAPTURE_STREAM))
 		line6_unlink_audio_in_urbs(line6pcm);
