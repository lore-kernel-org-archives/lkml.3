Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3HBKIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:08:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888Ab3HBKIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:08:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Z Lam <azl@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 18/99] tracing: Fix error handling to ensure instances can always be removed
Date: Fri,  2 Aug 2013 18:07:31 +0800
Message-Id: <20130802100228.582619084@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Z Lam <azl@google.com>

commit 609e85a70bcd0eedf4ec60639dbcfb1ab011e054 upstream.

Remove debugfs directories for tracing instances during creation if an error
occurs causing the trace_array for that instance to not be added to
ftrace_trace_arrays. If the directory continues to exist after the error, it
cannot be removed because the respective trace_array is not in
ftrace_trace_arrays.

Link: http://lkml.kernel.org/r/1373502874-1706-2-git-send-email-azl@google.com

Signed-off-by: Alexander Z Lam <azl@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5926,8 +5926,10 @@ static int new_instance_create(const cha
 		goto out_free_tr;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
-	if (ret)
+	if (ret) {
+		debugfs_remove_recursive(tr->dir);
 		goto out_free_tr;
+	}
 
 	init_tracer_debugfs(tr, tr->dir);
 


