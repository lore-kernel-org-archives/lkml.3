Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaHZBJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:09:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41110 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbaHZBJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:09:53 -0400
Date: Mon, 25 Aug 2014 18:11:12 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Aloni <dan@kernelim.com>, Benjamin LaHaise <bcrl@kvack.org>,
        "security@kernel.org" <security@kernel.org>, linux-aio@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, stable <stable@vger.kernel.org>
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user
 space"
Message-ID: <20140826011112.GA10095@kmo-pixel>
References: <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
 <20140819163733.GA10132@gmail.com>
 <20140819165404.GD13858@kvack.org>
 <20140819171426.GA11811@gmail.com>
 <20140820004651.GJ13858@kvack.org>
 <20140822160111.GD20391@kvack.org>
 <20140822161502.GA30392@gmail.com>
 <20140822162630.GF20391@kvack.org>
 <20140822185110.GA2333@gmail.com>
 <CA+55aFzZbRkEh_MbB-XmurVP-4seMP3z9tbq+YQOhkjtDNTzfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZbRkEh_MbB-XmurVP-4seMP3z9tbq+YQOhkjtDNTzfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 02:43:56PM -0700, Linus Torvalds wrote:
> On Fri, Aug 22, 2014 at 11:51 AM, Dan Aloni <dan@kernelim.com> wrote:
> >
> > Ben, seems that the test program needs some twidling to make the bug
> > appear still by setting MAX_IOS to 256 (and it still passes on a
> > kernel with the original patch reverted). Under this condition the
> > ring buffer size remains 128 (here, 32*4 CPUs), and it is overrun on
> > the second attempt.
> 
> Ugh.
> 
> Ben, at this point my gut feel is that we should just revert the
> original "fix", and you should take a much deeper look at this all.
> The original "fix" was more broken then the leak it purported to fix,
> and now the patch to fix your fix has gone through two iterations and
> *still* Dan is finding bugs in it.  I'm getting the feeling that this
> code needs more thinking than you are actually putting into it.

Ugh, I should've dug into this a lot sooner... mea culpa, I originally wrote
this percpu reqs_available() nonsense (can I unwrite code?)

Coming into the discussion late, here's my understanding, please correct me if
I'm wrong and I'll blame the cold medication...

The original patch f8567a3845ac05bb28f3c1b478ef752762bd39ef was broken because
it changed the logic so that a slot was considered available once an iocb
completion had been delivered to the ring buffer. BUT THE THING THAT IT'S
COUNTING IS AVAILABLE SLOTS IN THE RINGBUFFER: get_reqs_available() is reserving
a slot in the ringbuffer, we can't do the put() until the event is actually
consumed.

took me a minute to figure out the logic in Ben's current patch, but here's
what's going on as I understand it

 * maintain a count of events we add to the ring
 * if there's fewer events in the ring than that count, the difference has been
   reaped so we can release their slots

and nothing else changes. we're just accounting one more thing,
completed_events, and the rest stays the same.

so, it took me a bit to figure out what was being accounted, I think the code
could stand some new comments explaining how this works (though I'm certainly
not one to throw stones) - but the new version makes sense to me, I do agree
with the approach.

Reviewed-by: Kent Overstreet <kmo@daterainc.com>

I think I owe Ben beer at some point...
