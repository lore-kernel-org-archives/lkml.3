Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaHXO72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:59:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34132 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaHXO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:59:25 -0400
Date: Sun, 24 Aug 2014 07:59:13 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-06b2afc0b9a26e7673856a24ab57bfb307dad394@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org, jmario@redhat.com,
        jolsa@redhat.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        jmario@redhat.com, jolsa@redhat.com, tglx@linutronix.de,
        dzickus@redhat.com
In-Reply-To: <1408591511-57884-1-git-send-email-dzickus@redhat.com>
References: <1408591511-57884-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Fallback to MAP__FUNCTION if daddr maps are NULL
Git-Commit-ID: 06b2afc0b9a26e7673856a24ab57bfb307dad394
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06b2afc0b9a26e7673856a24ab57bfb307dad394
Gitweb:     http://git.kernel.org/tip/06b2afc0b9a26e7673856a24ab57bfb307dad394
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 20 Aug 2014 23:25:11 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 22 Aug 2014 13:12:13 -0300

perf machine: Fallback to MAP__FUNCTION if daddr maps are NULL

As we run "perf c2c" on more applications, we noticed we're missing
significant samples from a common customer's application.  Looking at
the /proc/<pid>/maps file for the app, we see "rwxs" and "rwxp"
permissions on many of the shared memory & heap regions, and on all the
thread stacks.

Because those regions have the "x" bit set, perf marks them with a
MAP_FUNCTION type.  Hence ip_resolve_data() never finds load or store
events coming from them.

We fixed this by re-calling thread__find_addr_location with
MAP__FUNCTION in the case where map is NULL as a last ditch effort to
map the sample before giving up and dropping it.

Reported-by: Joe Mario <jmario@redhat.com>
Tested-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408591511-57884-1-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e00daf0..b2ec38b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1314,6 +1314,16 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 
 	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr,
 				   &al);
+	if (al.map == NULL) {
+		/*
+		 * some shared data regions have execute bit set which puts
+		 * their mapping in the MAP__FUNCTION type array.
+		 * Check there as a fallback option before dropping the sample.
+		 */
+		thread__find_addr_location(thread, machine, m, MAP__FUNCTION, addr,
+					   &al);
+	}
+
 	ams->addr = addr;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
