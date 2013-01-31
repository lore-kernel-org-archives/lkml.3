Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3AaTTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:19:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3AaTTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:19:45 -0500
Date: Thu, 31 Jan 2013 20:18:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] uprobes/tracing: Fix dentry/mount leak in
	create_trace_uprobe()
Message-ID: <20130131191815.GA30429@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131191752.GA30410@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_trace_uprobe() does kern_path() to find ->d_inode, but forgets
to do path_put(). We can do this right after igrab().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 7d5b407..6563f00 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -253,12 +253,13 @@ static int create_trace_uprobe(int argc, char **argv)
 	if (ret)
 		goto fail_address_parse;
 
+	inode = igrab(path.dentry->d_inode);
+	path_put(&path);
+
 	ret = kstrtoul(arg, 0, &offset);
 	if (ret)
 		goto fail_address_parse;
 
-	inode = igrab(path.dentry->d_inode);
-
 	argc -= 2;
 	argv += 2;
 
-- 
1.5.5.1

