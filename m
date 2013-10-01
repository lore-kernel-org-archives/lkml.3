Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3JACTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 22:19:03 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47448 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3JACTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 22:19:01 -0400
Message-ID: <1380593933.19002.4.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: spinlock contention of files->file_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 30 Sep 2013 19:18:53 -0700
In-Reply-To: <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
	 <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 18:44 -0700, Linus Torvalds wrote:
> On Mon, Sep 30, 2013 at 6:05 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Speaking of spinlock contention, the files->file_lock is a good example.
> >
> > Multi threaded programs hit this spinlock three times per fd :
> 
> .. do you actually have programs that see contention?

Yes, Google-Bug-Id 9072743 for Googlers ;)

Basically, we have (many) servers with 10,000,000+ sockets, where this
lock contention is a real problem.

We use a SOCK_FD_FASTALLOC accept4()/socket() flag to relax POSIX
requirements and not having to parse huge bitmap in
find_next_zero_bit(fdt->open_fds, fdt->max_fds, fd)  (O_FD_FASTALLOC
uses a random starting point)

I am writing a patch using cmpxchg() to see if I can solve the dup2()
'problem'


