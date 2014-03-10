Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaCJNqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:46:13 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:53948 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaCJNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:46:11 -0400
Message-ID: <531DC21F.6060103@gmail.com>
Date: Mon, 10 Mar 2014 14:46:07 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mtk.manpages@gmail.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Pavel Emelianov <xemul@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND]  ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

While testing and documenting the msgrcv() MSG_COPY flag that Stanislav 
Kinsbursky added in commit 4a674f34ba04a002244edaf891b5da7fc1473ae8 
(==> kernel 3.8), I discovered a  couple of bugs in the implementation. 
The two bugs concern MSG_COPY interactions with other msgrcv() flags, namely:

(A) MSG_COPY + MSG_EXCEPT
(B) MSG_COPY + !IPC_NOWAIT

The bugs are distinct (and the fix for the first one is obvious),
however my fix for both is a single-line patch, which is why I'm
combining them in a single mail, rather than writing two mails+patches.

===== (A) MSG_COPY + MSG_EXCEPT =====

With the addition of the MSG_COPY flag, there are now two msgrcv()
flags--MSG_COPY and MSG_EXCEPT--that modify the meaning of the 'msgtyp' 
argument in unrelated ways. Specifying both in the same call is a logical 
error that is currently permitted, with the effect that MSG_COPY has 
priority and MSG_EXCEPT is ignored. The call should give an error if both
flags are specified. The patch below implements that behavior.

===== (B) (B) MSG_COPY + !IPC_NOWAIT =====

The test code that was submitted in commit
3a665531a3b7c2ad2c87903b24646be6916340e4 shows MSG_COPY being used in
conjunction with IPC_NOWAIT. In other words, if there is no message
at the position 'msgtyp'. return immediately with the error in ENOMSG.

What was not (fully) tested is the behavior if MSG_COPY is specified
*without* IPC_NOWAIT, and there is an odd behavior. If the queue contains
less than 'msgtyp' messages, then the call blocks until the next message
is written to the queue. At that point, the msgrcv() call returns a copy
of the newly added message, regardless of whether that message is at the
ordinal position 'msgtyp'. This is clearly bogus, and problematic for
applications that might want to make use of the MSG_COPY flag.

I considered the following possible solutions to this problem:

(1) Force the call to block until a message *does* appear at the position
    'msgtyp'.

(2) If the MSG_COPY flag is specified, the kernel should implicitly add
    IPC_NOWAIT, so that the call fails with ENOMSG for this case.

(3) If the MSG_COPY flag is specified, but IPC_NOWAIT is not, generate an
    error (probably, EINVAL is the right one).

I do not know if any application would really want to have the functionality
of solution (1), especially since an application can determine in advance
the number of messages in the queue using msgctl() IPC_STAT. Obviously, this
solution would be the most work to implement.

Solution (2) would have the effect of silently fixing any applications that
tried to employ broken behavior. However, it would mean that if we later
decided to implement solution (1), then user-space could not easily detect
what the kernel supports (but, since I'm somewhat doubtful that solution (1)
is needed, I'm not sure that this is much of a problem).

Solution (3) would have the effect of informing broken applications that
they are doing something broken. The downside is that this would cause a
ABI breakage for any applications that are currently employing the broken
behavior. However:

a) Those applications are almost certainly not getting the results they
   expect.
b) Possibly, those applications don't even exist, because MSG_COPY is
   currently hidden behind CONFIG_CHECKPOINT_RESTORE.

The upside of solution (3) is that if we later decided to implement
solution (1), user-space could determine what the kernel supports,
via the error return.

In my view, solution (3) is mildly preferable to solution (2), and
solution (1) could still be done later if anyone really cares.
The patch below implements solution (3).

PS For anyone out there still listening, it's the usual story:
documenting an API (and the thinking about, and the testing of the API,
that documentation  entails) is the one of the single best ways of
finding bugs in the API, as  I've learned from a lot of experience.
Best to do that documentation before releasing the API.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: stable@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---

Acked by Stanislaw in 
http://thread.gmane.org/gmane.linux.kernel/1634534/focus=1636681


diff --git a/ipc/msg.c b/ipc/msg.c
index 245db11..6498531 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -901,6 +901,8 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 		return -EINVAL;
 
 	if (msgflg & MSG_COPY) {
+		if ((msgflg & MSG_EXCEPT) || !(msgflg & IPC_NOWAIT))
+			return -EINVAL;
 		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);


