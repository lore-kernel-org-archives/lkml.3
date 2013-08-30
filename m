Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3H3Vak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:30:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35103 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3H3Vai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:30:38 -0400
Date: Fri, 30 Aug 2013 22:30:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
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
Message-ID: <20130830213029.GG13318@ZenIV.linux.org.uk>
References: <52200DAE.2020303@hp.com>
 <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
 <5220E56A.80603@hp.com>
 <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
 <5220F090.5050908@hp.com>
 <CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
 <5220FD51.2010709@hp.com>
 <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
 <20130830205404.GF13318@ZenIV.linux.org.uk>
 <52210A55.8010308@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52210A55.8010308@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 05:10:45PM -0400, Waiman Long wrote:
> On 08/30/2013 04:54 PM, Al Viro wrote:
> >On Fri, Aug 30, 2013 at 01:43:11PM -0700, Linus Torvalds wrote:
> >>On Fri, Aug 30, 2013 at 1:15 PM, Waiman Long<waiman.long@hp.com>  wrote:
> >>>The prepend_path() isn't all due to getcwd. The correct profile should be
> >>Ugh. I really think that prepend_path() should just be rewritten to
> >>run entirely under RCU.
> >>
> >>Then we can remove *all* the stupid locking, and replace it with doing
                                                     ^^^^^^^^^^^^^^^^^^^^^
> >>a read-lock on the rename sequence count, and repeating if requited.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>
> >>That shouldn't even be hard to do, it just requires mindless massaging
> >>and being careful.
> >Not really.  Sure, you'll retry it if you race with d_move(); that's not
> >the real problem - access past the end of the object containing ->d_name.name
> >would screw you and that's what ->d_lock is preventing there.  Delayed freeing
> >of what ->d_name is pointing into is fine, but it's not the only way to get
> >hurt there...
> 
> Actually, prepend_path() was called with rename_lock taken. So
> d_move() couldn't be run at the same time. Am I right?

See above.  You are right, but if Linus wants to turn that sucker into
reader (which is possible - see e.g. cifs build_path_from_dentry() and its
ilk), d_move() races will start to play.
