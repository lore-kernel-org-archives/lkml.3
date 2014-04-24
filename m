Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaDXAxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:53:41 -0400
Received: from longford.logfs.org ([213.229.74.203]:43186 "EHLO longford"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbaDXAxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:53:40 -0400
Date: Wed, 23 Apr 2014 20:52:47 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
Message-ID: <20140424005247.GA17713@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 April 2014 23:37:54 +0200, Jiri Kosina wrote:
> 
> This, however, will make RCU stall detector to send NMI to all online CPUs 
> so that they can dump their stacks.
> 
> IOW, this might actually make the whole sysrq dump last for much longer, 
> and have the log polluted with all-CPU dumps for no good reason.

I use the patch below for some time now.  While it doesn't avoid the
log pollution in the first place, it lessens the impact somewhat.

Jörn

--
The cost of changing business rules is much more expensive for software
than for a secretaty.
-- unknown

>From 8286b521865503f92837a036fecdb51f41c0141c Mon Sep 17 00:00:00 2001
From: Joern Engel <joern@logfs.org>
Date: Wed, 20 Mar 2013 09:47:52 -0700
Subject: [PATCH] printk: Print cpu number along with time

Sometimes the printk log is heavily interleaving between different cpus.
This is particularly bad when you have two backtraces at the same time,
but can be annoying in other cases as well.  With an explicit cpu
number, a simple grep can disentangle the mess for you.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 kernel/printk.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index abbdd9e..c5f6dda 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -210,6 +210,7 @@ struct log {
 	u16 len;		/* length of entire record */
 	u16 text_len;		/* length of text buffer */
 	u16 dict_len;		/* length of dictionary buffer */
+	u16 cpu;		/* cpu the message was generated on */
 	u8 facility;		/* syslog facility */
 	u8 flags:5;		/* internal record flags */
 	u8 level:3;		/* syslog level */
@@ -356,6 +357,7 @@ static void log_store(int facility, int level,
 	msg->facility = facility;
 	msg->level = level & 7;
 	msg->flags = flags & 0x1f;
+	msg->cpu = smp_processor_id();
 	if (ts_nsec > 0)
 		msg->ts_nsec = ts_nsec;
 	else
@@ -863,7 +865,7 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static size_t print_time(u64 ts, char *buf)
+static size_t print_time(u64 ts, u16 cpu, char *buf)
 {
 	unsigned long rem_nsec;
 
@@ -871,12 +873,12 @@ static size_t print_time(u64 ts, char *buf)
 		return 0;
 
 	rem_nsec = do_div(ts, 1000000000);
-
 	if (!buf)
-		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
+		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",
+				(unsigned long)ts, cpu);
 
-	return sprintf(buf, "[%5lu.%06lu] ",
-		       (unsigned long)ts, rem_nsec / 1000);
+	return sprintf(buf, "[%5lu.%06lu,%02x] ",
+		       (unsigned long)ts, rem_nsec / 1000, cpu);
 }
 
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
@@ -898,7 +900,7 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 		}
 	}
 
-	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
+	len += print_time(msg->ts_nsec, msg->cpu, buf ? buf + len : NULL);
 	return len;
 }
 
@@ -1396,6 +1398,7 @@ static struct cont {
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
 	u64 ts_nsec;			/* time of first print */
+	u16 cpu;			/* cpu the message was generated on */
 	u8 level;			/* log level of first message */
 	u8 facility;			/* log level of first message */
 	enum log_flags flags;		/* prefix, newline flags */
@@ -1445,6 +1448,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.facility = facility;
 		cont.level = level;
 		cont.owner = current;
+		cont.cpu = smp_processor_id();
 		cont.ts_nsec = local_clock();
 		cont.flags = 0;
 		cont.cons = 0;
@@ -1466,7 +1470,7 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t len;
 
 	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
+		textlen += print_time(cont.ts_nsec, cont.cpu, text);
 		size -= textlen;
 	}
 
-- 
1.7.10.4

