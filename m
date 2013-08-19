Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3HSJmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:15 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48411 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HSJmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:11 -0400
X-AuditID: 85900ec0-cff26b9000001514-3e-5211e8710236
Subject: [RFC PATCH 03/11] [BUGFIX]trace-cmd: Quit from splice(read) if
 there are no data
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:27 +0900
Message-ID: <20130819094627.26597.5222.stgit@yunodevel>
In-Reply-To: <20130819094620.26597.79499.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quit from splice(read) for avoiding to do splice(write) if there are no data.
When splice(read) returns negative or 0, that means no data. So, the recorder
does not need to do splice(write).

Note:
This patch is related to https://lkml.org/lkml/2013/7/21/200. If the patch of
the link is not applied, splice(write) for virtio-serial induces kernel oops
when there are no data. This patch always avoids to do splice(write) in the
case, so this patch is needed.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-recorder.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/trace-recorder.c b/trace-recorder.c
index 7db5f3e..520d486 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -337,7 +337,10 @@ static long splice_data(struct tracecmd_recorder *recorder)
 			warning("recorder error in splice input");
 			return -1;
 		}
-	}
+		if (errno == EINTR)
+			return 0;
+	} else if (ret == 0)
+		return 0;
 
 	ret = splice(recorder->brass[0], NULL, recorder->fd, NULL,
 		     recorder->page_size, 3 /* and NON_BLOCK */);

