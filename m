Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJAKCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:02:38 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:64105 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJAKCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:02:36 -0400
Message-ID: <542BD132.7000105@gmail.com>
Date: Wed, 01 Oct 2014 12:02:26 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Doug Ledford <dledford@redhat.com>
CC: mtk.manpages@gmail.com, Davidlohr Bueso <dave@stgolabs.net>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
References: <542921EA.4050709@gmail.com> <1412011687.15492.39.camel@firewall.xsintricity.com>
In-Reply-To: <1412011687.15492.39.camel@firewall.xsintricity.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 07:28 PM, Doug Ledford wrote:
> On Mon, 2014-09-29 at 11:10 +0200, Michael Kerrisk (man-pages) wrote:
>> Hello Doug, David,
>>
>> I think you two were the last ones to make significant 
>> changes to the semantics of the files in /proc/sys/fs/mqueue,
>> so I wonder if you (or anyone else who is willing) might
>> take a look at the man page text below that I've written
>> (for the mq_overview(7) page) to describe past and current
>> reality, and let me know of improvements of corrections.
>>
>> By the way, Doug, your commit ce2d52cc1364 appears to have
>> changed/broken the semantics of the files in the /dev/mqueue 
>> filesystem. Formerly, the QSIZE field in these files showed
>> the number of bytes of real user data in all of the queued
>> messages. After that commit, QSIZE now includes kernel 
>> overhead bytes, which does not seem very useful for user 
>> space. Was that change intentional? I see no mention of the
>> change in the commit message, so it sounds like it was not 
>> intended.
> 
> That change didn't come in that commit.  That commit modified it, but
> didn't introduce it.
> 
> Now, was it intentional? Yes.  Is it valuable, useful?  That depends on
> your perspective.
> 
> One of the problems I ran into with that code relates to the rlimit
> checks that happen at queue creation time.  We used to check to see if
> 
>  msg_num * (msg_size + sizeof struct msg_msg *)
> 
> would fit within the user's currently available rlimit for
> RLIMIT_MSGQUEUE.  This was not an accurate check though.  It accounted
> for the msg number, and the payload size, and the array of pointers we
> used to point to the msg_msg structs that held each message, but ignored
> the msg_msg structs themselves.  Given that we accept the creation of
> message queues with a msg_size of 1, this could be used to create a
> minor DoS because of the fact that there was such a large size
> difference between the sizeof struct msg_msg and the size of our
> messages.  In this scenario, a msg_size of 1 would result in us
> accounting 9/5 bytes per message on 64bit/32bit OSes respecitively, but
> actually using 49bytes/19bytes respectively.  That's a 4:1 ratio at the
> worst case for the different between actual memory used and memory usage
> accounted against the RLIMIT_MSGQUEUE limit. So before I ever got around
> to doing the rbtree update, I fixed this to at least be more accurate
> and it became
> 
>  msg_num * (msg_size + sizeof struct msg_msg * + sizeof struct msg_msg)
> 
> Even this wasn't totally accurate though, as large messages could result
> in the allocation of additional msg_msgseg segments.  However, I ignored
> that inaccuracy because once the message size is large enough to need
> additional SG segments, we are no longer in danger of any sort of minor
> DoS because our own overhead will become nothing more than noise to the
> calculation.

So, for what it's worth, I applied the following patch in getrlimit.2
to describe the post 3.5 behavior. Look okay?

Cheers,

Michael



diff --git a/man2/getrlimit.2 b/man2/getrlimit.2
index 91fed13..a3e4285 100644
--- a/man2/getrlimit.2
+++ b/man2/getrlimit.2
@@ -250,8 +250,19 @@ Each message queue that the user creates counts (until it i
s removed)
 against this limit according to the formula:
 .nf
 
-    bytes = attr.mq_maxmsg * sizeof(struct msg_msg *) +
-            attr.mq_maxmsg * attr.mq_msgsize
+    Since Linux 3.5:
+        bytes = attr.mq_maxmsg * sizeof(struct msg_msg) +
+                min(attr.mq_maxmsg, MQ_PRIO_MAX) *
+                      sizeof(struct posix_msg_tree_node)+ 
+                                /* For overhead */
+                attr.mq_maxmsg * attr.mq_msgsize;
+                                /* For message data */
+
+    Linux 3.4 and earlier:
+        bytes = attr.mq_maxmsg * sizeof(struct msg_msg *) +
+                                /* For overhead */
+                attr.mq_maxmsg * attr.mq_msgsize;
+                                /* For message data */
 
 .fi
 where
@@ -259,11 +270,16 @@ where
 is the
 .I mq_attr
 structure specified as the fourth argument to
-.BR mq_open (3).
+.BR mq_open (3),
+and the
+.I msg_msg
+and
+.I posix_msg_tree_node
+structures are kernel-internal structures.
 
-The first addend in the formula, which includes
-.I "sizeof(struct msg_msg\ *)"
-(4 bytes on Linux/i386), ensures that the user cannot
+The "overhead" addend in the formula accounts for overhead
+bytes required by the implementation
+and ensures that the user cannot
 create an unlimited number of zero-length messages (such messages
 nevertheless each consume some system memory for bookkeeping overhead).
 .TP

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
