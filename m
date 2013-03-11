Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3CKLve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:51:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52840 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3CKLvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:51:33 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-a3-513dc5435e3a
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] perf: Reset detached siblings' group_flags
References: <1362629990-10053-1-git-send-email-namhyung@kernel.org>
	<1362995984.14933.0.camel@laptop>
Date: Mon, 11 Mar 2013 20:51:31 +0900
In-Reply-To: <1362995984.14933.0.camel@laptop> (Peter Zijlstra's message of
	"Mon, 11 Mar 2013 10:59:44 +0100")
Message-ID: <87620yqhmk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the code again, I found that the detached siblings
should call perf_event__header_size() for themselves in the loop since
after moving them to the list the previous leader will have empty
sibling_list.  Something like below is needed IMHO:


diff --git a/kernel/events/core.c b/kernel/events/core.c
index dc96fee942a6..53ac21cc4012 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1100,6 +1100,13 @@ static void perf_group_detach(struct perf_event *event)
 
 		/* Inherit group flags from the previous leader */
 		sibling->group_flags = event->group_flags;
+
+		/*
+		 * The leader will forget about siblings from now on.
+		 * So below loop to update header size of each sibling won't
+		 * work for this case. Do it directly.
+		 */
+		perf_event__header_size(sibling);
 	}
 
 out:
