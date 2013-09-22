Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3IVUjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:39:51 -0400
Received: from imap.thunk.org ([74.207.234.97]:35986 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3IVUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 05/12] random: fix the tracepoint for get_random_bytes(_arch)
Date: Sun, 22 Sep 2013 16:38:51 -0400
Message-Id: <1379882338-7209-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a problem where get_random_bytes_arch() was calling the tracepoint
get_random_bytes().  So add a new tracepoint for
get_random_bytes_arch(), and make get_random_bytes() and
get_random_bytes_arch() call their correct tracepoint.

Also, add a new tracepoint for add_device_randomness()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c         |  5 ++++-
 include/trace/events/random.h | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 75f04d5..391b05a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -708,7 +708,9 @@ struct timer_rand_state {
 void add_device_randomness(const void *buf, unsigned int size)
 {
 	unsigned long time = get_cycles() ^ jiffies;
+	unsigned long flags;
 
+	trace_add_device_randomness(size, _RET_IP_);
 	mix_pool_bytes(&input_pool, buf, size, NULL);
 	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
 	mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
@@ -1125,6 +1127,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
  */
 void get_random_bytes(void *buf, int nbytes)
 {
+	trace_get_random_bytes(nbytes, _RET_IP_);
 	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
 }
 EXPORT_SYMBOL(get_random_bytes);
@@ -1143,7 +1146,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 {
 	char *p = buf;
 
-	trace_get_random_bytes(nbytes, _RET_IP_);
+	trace_get_random_bytes_arch(nbytes, _RET_IP_);
 	while (nbytes) {
 		unsigned long v;
 		int chunk = min(nbytes, (int)sizeof(unsigned long));
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 422df19..2ffcaec 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -7,6 +7,25 @@
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(add_device_randomness,
+	TP_PROTO(int bytes, unsigned long IP),
+
+	TP_ARGS(bytes, IP),
+
+	TP_STRUCT__entry(
+		__field(	  int,	bytes			)
+		__field(unsigned long,	IP			)
+	),
+
+	TP_fast_assign(
+		__entry->bytes		= bytes;
+		__entry->IP		= IP;
+	),
+
+	TP_printk("bytes %d caller %pF",
+		__entry->bytes, (void *)__entry->IP)
+);
+
 DECLARE_EVENT_CLASS(random__mix_pool_bytes,
 	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
 
@@ -68,7 +87,7 @@ TRACE_EVENT(credit_entropy_bits,
 		  (void *)__entry->IP)
 );
 
-TRACE_EVENT(get_random_bytes,
+DECLARE_EVENT_CLASS(random__get_random_bytes,
 	TP_PROTO(int nbytes, unsigned long IP),
 
 	TP_ARGS(nbytes, IP),
@@ -86,6 +105,18 @@ TRACE_EVENT(get_random_bytes,
 	TP_printk("nbytes %d caller %pF", __entry->nbytes, (void *)__entry->IP)
 );
 
+DEFINE_EVENT(random__get_random_bytes, get_random_bytes,
+	TP_PROTO(int nbytes, unsigned long IP),
+
+	TP_ARGS(nbytes, IP)
+);
+
+DEFINE_EVENT(random__get_random_bytes, get_random_bytes_arch,
+	TP_PROTO(int nbytes, unsigned long IP),
+
+	TP_ARGS(nbytes, IP)
+);
+
 DECLARE_EVENT_CLASS(random__extract_entropy,
 	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
 		 unsigned long IP),
-- 
1.7.12.rc0.22.gcdd159b

