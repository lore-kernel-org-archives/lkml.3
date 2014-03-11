Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaCKKRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:17:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbaCKKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:17:12 -0400
Date: Tue, 11 Mar 2014 03:16:57 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-fdf57dd052d5cbd415533ae98f4d423286a85220@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1393386227-149412-2-git-send-email-dzickus@redhat.com>
References: <1393386227-149412-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine:
  Use map as success in ip__resolve_ams
Git-Commit-ID: fdf57dd052d5cbd415533ae98f4d423286a85220
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

Commit-ID:  fdf57dd052d5cbd415533ae98f4d423286a85220
Gitweb:     http://git.kernel.org/tip/fdf57dd052d5cbd415533ae98f4d423286a85220
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 25 Feb 2014 22:43:45 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Mar 2014 11:19:36 -0300

perf machine: Use map as success in ip__resolve_ams

When trying to map a bunch of instruction addresses to their respective
threads, I kept getting a lot of bogus entries [I forget the exact
reason as I patched my code months ago].

Looking through ip__resolve_ams, I noticed the check for

  if (al.sym)

and realized, most times I have an al.map definition but sometimes an
al.sym is undefined.  In the cases where al.sym is undefined, the loop
keeps going even though a valid al.map exists.

Modify this check to use the more reliable al.map.  This fixed my bogus
entries.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393386227-149412-2-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c872991..620a198 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1213,7 +1213,7 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 		 */
 		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
 				ip, &al);
-		if (al.sym)
+		if (al.map)
 			goto found;
 	}
 found:
