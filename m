Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab3CEPuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:50:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3CEPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:50:10 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=QIvdI-ESzzIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=aG2A6zNsvYEA:10 a=MLgBt4qJIxULhIdcTSsA:9 a=PUjeQqilurYA:10 a=bEATC11fGy_3KvLx:21 a=t3sitlCHVz4dg34s:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362498608.31874.28.camel@gandalf.local.home>
Subject: snapshot error on non allocated buffer?
From: Steven Rostedt <rostedt@goodmis.org>
To: hiraku.toyooka.gu@hitachi.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 05 Mar 2013 10:50:08 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiraku,

I'm doing a lot of reconstruction of ftrace's buffering, and I'm also
modifying a lot of the snapshot feature to work with the new stuff
that's coming.

I'm looking at the -EINVAL when you write something other than '0' or
'1' into the snapshot file when the snapshot is not allocated. I'm
thinking that it should just return as if it succeeded. I don't
understand why it should return -EINVAL?

Now if you want to know if the snapshot is allocated or not, I have a
patch that shows how to use the snapshot feature when the snapshot is
empty, and also give the status of the snapshot itself:

[root] # cat /debug/tracing/snapshot 
# tracer: nop
#
#
# * Snapshot is freed *
#
# Snapshot commands:
# echo 0 > snapshot : Clears and frees snapshot buffer
# echo 1 > snapshot : Allocates snapshot buffer, if not already
allocated.
#                      Takes a snapshot of the main buffer.
# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
#                      (Doesn't have to be '2' works with any number
that
#                       is not a '0' or '1')

[root] # echo 1 > /debug/tracing/snapshot
[root] # echo 2 > /debug/tracing/snapshot
[root] # cat /debug/tracing/snapshot
# tracer: nop
#
#
# * Snapshot is allocated *
#
# Snapshot commands:
# echo 0 > snapshot : Clears and frees snapshot buffer
# echo 1 > snapshot : Allocates snapshot buffer, if not already
allocated.
#                      Takes a snapshot of the main buffer.
# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
#                      (Doesn't have to be '2' works with any number
that
#                       is not a '0' or '1')


As this is a new feature for 3.9, and we are still in -rc1, I think this
might be a good thing to add now. As well as not returning -EINVAL on
writing to the file when the snapshot buffer isn't allocated.

What do you think?

-- Steve


