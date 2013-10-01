Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3JAByF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 21:54:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54277 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3JAByE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 21:54:04 -0400
Date: Tue, 1 Oct 2013 02:53:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: spinlock contention of files->file_lock
Message-ID: <20131001015344.GV13318@ZenIV.linux.org.uk>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 06:05:03PM -0700, Eric Dumazet wrote:
> Speaking of spinlock contention, the files->file_lock is a good example.
> 
> Multi threaded programs hit this spinlock three times per fd : 
> 
> alloc_fd() / fd_install() / close() 
> 
> I think fd_install() could be done without this spinlock.

The problem is dup2(), not table resize...  I'm not saying it can't be
done, but it won't be trivial and you seem to be looking for potential
trouble in the wrong place.  dup2() semantics is the real bitch.
What we want is
	* dup2() over unused descriptor => insert and be done with that
	* dup2() over opened one => replace and do equivalent of close()
for what had been there before
The trouble is, what to do with dup2() over reserved, but still not
installed descriptor?  We handle that as -EBUSY and we use ->file_lock
to get atomicity wrt transitions between those states.

And yes, dup2() is a lousy API in multithreaded situation.  It's still
there...  See comments in do_dup2() for some amusement.
