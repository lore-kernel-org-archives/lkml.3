Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3LBUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:25:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3LBTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Bill Gray <bgray@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>,
        Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3.12 028/212] perf tools: Synthesize anon MMAP records again
Date: Mon,  2 Dec 2013 11:13:39 -0800
Message-Id: <20131202191251.751826789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Don Zickus <dzickus@redhat.com>

commit 9d4ecc8893832337daf241236841db966fa53489 upstream.

When introducing the PERF_RECORD_MMAP2 in:

5c5e854bc760 perf tools: Add attr->mmap2 support

A check for the number of entries parsed by sscanf was introduced that
assumed all of the 8 fields needed to be correctly parsed so that
particular /proc/pid/maps line would be considered synthesizable.

That broke anon records synthesizing, as it doesn't have the 'execname'
field.

Fix it by keeping the sscanf return check, changing it to not require
that the 'execname' variable be parsed, so that the preexisting logic
can kick in and set it to '//anon'.

This should get things like JIT profiling working again.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Bill Gray <bgray@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bo4akalno7579shpz29u867j@git.kernel.org
[ commit log message is mine, dzickus reported the problem with a patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -212,8 +212,10 @@ static int perf_event__synthesize_mmap_e
 		       &event->mmap.start, &event->mmap.len, prot,
 		       &event->mmap.pgoff,
 		       execname);
-
-		if (n != 5)
+		/*
+ 		 * Anon maps don't have the execname.
+ 		 */
+		if (n < 4)
 			continue;
 
 		if (prot[2] != 'x')


