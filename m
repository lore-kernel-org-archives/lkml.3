Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaD1CiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:38:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47531 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaD1Ch6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:37:58 -0400
From: Shan Hai <shan.hai@windriver.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] ftrace/ring_buffer: reset reader page after consuming read
Date: Mon, 28 Apr 2014 10:37:39 +0800
Message-ID: <1398652660-4560-1-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reading from the 'trace' file after force stopping (by signal) consuming
read reveals there are stale trace entries in the output, this patch fixes
the bug by resetting read/write pointers of reader page after the consuming
read is stopped by force.

The issue can be reproduced as below:

echo 0 > tracing_on
echo function > current_tracer
echo 1 > tracing_on

1, read the trace file as normal
        cat trace | head -n 20
        ...
        cat trace | head -n 20

        The trace entries are changing at the head of the output.
        NOTE:
        If it's not changing at the start please repeat the reading
        several times because the tracer need time to fill up the
        whole buffer.

2, read the trace file after stopping 'cat trace_pipe' by Ctrl-C
        cat trace_pipe
        Ctrl-C
        cat trace | head -n 200
        ...
        cat trace | head -n 200

        The trace entries at the head of the output stop changing,
        followed by changing trace entries.
        NOTE:
        Please carefully check the time stamps of the trace entries,
        the time stamps of some of them at the head stop changing
        in the consecutive read.

        The results of test 1 and 2 are not consistent with respect to the
        updating of trace buffers, some part of the trace buffers are
        not updated in the test 2 while all of them are updated in the
        test 1.

        And the result of test 1 is correct because the trace entries
        supposed to be changed for the reason the tracer works under
        overwrite mode by default.

Thanks
Shan Hai

