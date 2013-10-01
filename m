Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JABFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 21:05:11 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63871 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3JABFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 21:05:06 -0400
Message-ID: <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
Subject: spinlock contention of files->file_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 30 Sep 2013 18:05:03 -0700
In-Reply-To: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speaking of spinlock contention, the files->file_lock is a good example.

Multi threaded programs hit this spinlock three times per fd : 

alloc_fd() / fd_install() / close() 

I think fd_install() could be done without this spinlock.

we want to protect fd_install() from a concurrent resize of the fd
table.

We could either :

- Add a spinlock used for resize, and fd_install().
  A bit suboptimal but easy to code and review.

- Add a seqcount, and cmpxchg() to synchronize fd_install() with the
potential resizer. (Might need additional RCU locking)



