Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3IKO4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:56:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32825 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3IKOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:55:59 -0400
Date: Wed, 11 Sep 2013 15:55:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 1/2] seqlock: Add a new blocking reader type
Message-ID: <20130911145536.GJ13318@ZenIV.linux.org.uk>
References: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:28:26AM -0400, Waiman Long wrote:
> The sequence lock (seqlock) was originally designed for the cases
> where the readers do not need to block the writers by making the
> readers retry the read operation when the data change.
> 
> Since then, the use cases have been expanded to include situations
> where a thread does not need to change the data (effectively a reader)
> at all but have to take the writer lock because it can't tolerate
> changes to the protected structure. Some examples are the d_path()
> function and the getcwd() syscall in fs/dcache.c where the functions
> take the writer lock on rename_lock even though they don't need
> to change anything in the protected data structure at all. This is
> inefficient as a reader is now blocking other non-blocking readers
> by pretending to be a writer.
> 
> This patch tries to eliminate this inefficiency by introducing a new
> type of blocking reader to the seqlock locking mechanism. This new
> blocking reader will not block other non-blocking readers, but will
> block other blocking readers and writers.

Umm...  That's misleading - it doesn't _block_, it spins.  Moroever,
seq_readbegin() also spins in presense of writer; the main property
of this one is that it keeps writers away.

Folks, any suggestions on better names?  The semantics we are getting is
this:
	* a thread is a writer from the moment of seq_writelock() to
seq_writeunlock()
	* a thread is exclusive reader from the moment of seq_readlock()
to seq_readunlock() [and these names and/or descriptions might need
replacement]
	* at most one writer or excluding reader at any moment
	* seq_readbegin() spins in presense of writers; it doesn't
care about exclusive readers.
	* seq_readretry() checks if there had been any writers
since the moment of matching seq_readbegin(); again, it doesn't
care about exclusive readers

IOW, it's not writer vs. reader in sense of rwlock (i.e. exclusive vs.
shared); it's "does vs. doesn't disrupt the structures seq_read{begin/retry}
sections care about".
