Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3CZTnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:43:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3CZTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:43:12 -0400
Date: Tue, 26 Mar 2013 12:43:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-Id: <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
In-Reply-To: <20130326192852.GA25899@redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 15:28:52 -0400 Dave Jones <davej@redhat.com> wrote:

> On Thu, Mar 21, 2013 at 02:10:58PM -0700, Andrew Morton wrote:
> 
>  > Whichever way we go, we should get a wiggle on - this has been hanging
>  > around for too long.  Dave, do you have time to determine whether
>  > reverting 88b9e456b1649722673ff ("ipc: don't allocate a copy larger
>  > than max") fixes things up?
> 
> Ok, with that reverted it's been grinding away for a few hours without incident.
> Normally I see the oops within a minute or so.
> 

OK, thanks, I queued a revert:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "ipc: don't allocate a copy larger than max"

Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
during trinity testing.

Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN ipc/msg.c~revert-ipc-dont-allocate-a-copy-larger-than-max ipc/msg.c
--- a/ipc/msg.c~revert-ipc-dont-allocate-a-copy-larger-than-max
+++ a/ipc/msg.c
@@ -820,17 +820,15 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *copy = NULL;
 	unsigned long copy_number = 0;
 
-	ns = current->nsproxy->ipc_ns;
-
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
-				    msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
 	mode = convert_mode(&msgtyp, msgflg);
+	ns = current->nsproxy->ipc_ns;
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {
_

