Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaBLVoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:44:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45522 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaBLVoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:44:14 -0500
Date: Wed, 12 Feb 2014 21:44:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212214411.GQ18016@ZenIV.linux.org.uk>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:32:55PM -0800, Linus Torvalds wrote:
> On Wed, Feb 12, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm...  What if we delay __sigqueue_free()?  After all, that's where the
> > fat sucker normally comes from.  That way we might get away with much
> > smaller structure on stack...
> 
> Sounds like the RightThing(tm) to do to me, and I don't see why it
> wouldn't work.
> 
> We'd have to teach each user of "dequeue_signal()" to free the siginfo
> thing. Which shouldn't be too bad - I think we've collected all of
> that into generic code, and there isn't the mass or architecture code
> that knows about these things any more. But there are a few odd
> drivers etc and signalfd. I didn't look at what the lifetimes were.

Only signalfd, AFAICS.  And there we'd want to use the same small structure -
it's used in
        do {
                ret = signalfd_dequeue(ctx, &info, nonblock);
                if (unlikely(ret <= 0))
                        break;
                ret = signalfd_copyinfo(siginfo, &info);
                if (ret < 0)
                        break;
                siginfo++;
                total += ret;
                nonblock = 1;
        } while (--count);
and using a smaller struct would actually speed the things up - skips one
copying.  sigqueue would be freed as soon as we'd done signalfd_copyinfo()
(if not by signalfd_copyinfo() itself).

I'll try to put something along those lines together, if you or Oleg don't
do it first.
