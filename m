Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3CUVLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:11:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3CUVLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:11:00 -0400
Date: Thu, 21 Mar 2013 14:10:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Peter Hurley <peter@hurleysoftware.com>, Dave Jones <davej@redhat.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-Id: <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013 15:55:30 -0400 Rik van Riel <riel@surriel.com> wrote:

> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.
> 
> The first four patches were written by Davidlohr Buesso, and
> reduce the hold time of the semaphore lock.
> 
> The last three patches change the sysv semaphore code locking
> to be more fine grained, providing a performance boost when
> multiple semaphores in a semaphore array are being manipulated
> simultaneously.

These patches conflict pretty badly with Peter's:

ipc-clamp-with-min.patch
ipc-separate-msg-allocation-from-userspace-copy.patch
ipc-tighten-msg-copy-loops.patch
ipc-set-efault-as-default-error-in-load_msg.patch
ipc-remove-msg-handling-from-queue-scan.patch
ipc-implement-msg_copy-as-a-new-receive-mode.patch
ipc-simplify-msg-list-search.patch
ipc-refactor-msg-list-search-into-separate-function.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch

(they're at http://ozlabs.org/~akpm/mmots/broken-out/)



We're in a bit of a mess at present.

Last month Peter sent a ten-patch series which fixed an oops (Subject:
"ipc MSG_COPY fixes").  The series did other stuff, so we merged into
mainline just two bugfix patches.  Then davej hit a trinity oops
(Subject: "ipc/testmsg GPF.") and testing confirmed that the remaining
eight patches in Peter's series fixed that up.  Nobody has yet
identified which of the eight does the good deed.  So we need to
either:

a) revert the original two fixes "ipc: fix potential oops when src
   msg > 4k w/ MSG_COPY" and "ipc: don't allocate a copy larger than
   max" or 

b) try reverting "ipc: don't allocate a copy larger than max", as
   "ipc: fix potential oops when src msg > 4k w/ MSG_COPY" looks pretty
   harmless or

c) work out which of the remaining 8 fixes the new oops and merge that or

d) merge all 8 fixes or

e) something else.

Whichever way we go, we should get a wiggle on - this has been hanging
around for too long.  Dave, do you have time to determine whether
reverting 88b9e456b1649722673ff ("ipc: don't allocate a copy larger
than max") fixes things up?

