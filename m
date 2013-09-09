Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3IISVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:21:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53981 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3IISVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:21:13 -0400
Date: Mon, 9 Sep 2013 19:21:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130909182111.GQ13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
 <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
 <20130909172905.GN13318@ZenIV.linux.org.uk>
 <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
 <20130909180604.GO13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909180604.GO13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 07:06:04PM +0100, Al Viro wrote:
> I like my proposal for the set of primitives better:
> 
> static inline bool seqretry_and_lock(seqlock_t *lock, unsigned *seq):
> {
>         if ((*seq & 1) || !read_seqretry(lock, *seq))
>                 return true;
>         *seq |= 1;
>         write_seqlock(lock);
>         return false;
> }
> 
> static inline void seqretry_done(seqlock_t *lock, unsigned seq)
> {
>         if (seq & 1)
>                 write_sequnlock(lock);
> }
> 
> with the prepend_path() and friends becoming
> 
> 	rcu_read_lock();
> 	seq = read_seqbegin(&rename_lock);
> again:
> 	....
> 	if (!seqretry_and_lock(&rename_lock, seq))
> 		goto again;	/* now as writer */
> 	seqretry_done(&rename_lock, seq);
> 	rcu_read_unlock();

Actually, it's better for prepend_path() as well, because it's actually
 
	rcu_read_lock();
	seq = read_seqbegin(&rename_lock);
again:
	....
	if (error)
		goto done;
	....
	if (!seqretry_and_lock(&rename_lock, seq))
		goto again;	/* now as writer */
done:
	seqretry_done(&rename_lock, seq);
	rcu_read_unlock();

Posted variant will sometimes hit the following path:
	* seq_readlock()
	* start generating the output
	* hit an error
[another process has taken and released rename_lock for some reason]
	* hit read_seqretry_and_unlock(), which returns 1.
	* retry everything with seq_writelock(), despite the error.

It's not too horrible (we won't be looping indefinitely, ignoring error
all along), but it's certainly subtle enough...
