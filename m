Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3IARtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 13:49:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49030 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3IARtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 13:49:11 -0400
Date: Sun, 1 Sep 2013 18:48:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130901174853.GR13318@ZenIV.linux.org.uk>
References: <5220FD51.2010709@hp.com>
 <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
 <20130830205404.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
 <20130830214452.GH13318@ZenIV.linux.org.uk>
 <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
 <20130831212355.GN13318@ZenIV.linux.org.uk>
 <CA+55aFwxQ2zN+kbt0Atob-Rims4B1pxgFniXbbA=YDAfb+wWAg@mail.gmail.com>
 <20130831232758.GO13318@ZenIV.linux.org.uk>
 <20130901001306.GP13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130901001306.GP13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 01:13:06AM +0100, Al Viro wrote:
> > Actually, right now I'm debugging a variant that avoids local buffers; use
> > is %pD3 for grandparent/parent/name, etc., up to %pD4.  %pd is equivalent
> > to %pD1 (just the dentry name).  Keep in mind that things like NFS use
> > a _lot_ of what would be %pD2 in debugging printks and the string can grow
> > fairly long, so I'd rather live with widen() than mess with local buffers
> > here.  I'll send an updated variant when I'm more or less satisfied with
> > it...
> 
> Seems to be working...  This doesn't include the metric arseload of
> conversions in fs/*/* - just the sprintf part.

FWIW, now that I've looked at more users (and we do have a shitload
of those), it seems that we need the following set:
	dentry name
	dentry path 2--4 levels deep (most of the users want 2 right now,
but that's mostly a matter of arguments being too painful to type for
deeper ones)
	same for file - sure, we can just pass file->f_path.dentry,
but there's a lot of such guys and I'd like to reduce the amount of
places where we have ->f_path.dentry mentioned in source.

Suggestions regarding formats to use would be welcome.  For now I'm using
pd/pd<n>/pD/pD<n>, the latter two being for struct file, but I'd gladly
take anything prettier than that.
