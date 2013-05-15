Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab3EOR40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:56:26 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40080 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab3EOR4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:56:24 -0400
Date: Wed, 15 May 2013 10:56:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130515175613.GB26222@htj.dyndns.org>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514215945.GA2334@mtj.dyndns.org>
 <20130515090742.GD16164@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515090742.GD16164@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 15, 2013 at 02:07:42AM -0700, Kent Overstreet wrote:
> > > +		__this_cpu_dec(*pcpu_count);
> > > +	else
> > > +		ret = atomic_dec_and_test(&ref->count);
> > > +
> > > +	preempt_enable();
> > > +
> > > +	return ret;
> > 
> > With likely() added, I think the compiler should be able to recognize
> > that the branch on pcpu_count should exclude later branch in the
> > caller to test for the final put in most cases but I'm a bit worried
> > whether that would always be the case and wonder whether ->release
> > based interface would be better.  Another concern is that the above
> > interface is likely to encourage its users to put the release
> > implementation in the same function.  e.g.
> 
> I... don't follow what you mean hear at all - what exactly would the
> compiler do differently? and how would passing a release function
> matter?

So, on the fast path, there should be one branch on the percpu
pointer; however, given the above code, especially without likely(),
the compiler may well choose to emit two branches which are shared by
both hot and cold paths - the first one on the percpu pointer, the
second on whether ref->count reached zero.  It just isn't clear to the
compiler whether duplicated preempt_enable() or an extra branch would
be cheaper.

> > 	void my_put(my_obj)
> > 	{
> > 		if (!percpu_ref_put(&my_obj->ref))
> > 			return;
> > 		destroy my_obj;
> > 		free my_obj;
> > 	}
> > 
> > Which in turn is likely to nudge the developer or compiler towards not
> > inlining the fast path.
> 
> I'm kind of skeptical partial inlining would be worth it for just an
> atomic_dec_and_test()...

Ooh, you can do the slow path inline too but I *suspect* we probably
need a bit more logic in the slowpath anyway if we wanna take care of
the bias overflow and maybe the release callback, and it really
doesn't matter a bit whether you have a call for slowpath, so...

> > So, while I do like the simplicity of put() returning %true on the
> > final put, I suspect it's more likely to slowing down fast paths due
> > to its interface compared to having separate ->release function
> > combined with void put().  Any ideas?
> 
> Oh, you mean having one branch instead of two when we're in percpu mode.
> Yeah, that is a good point.

Yeap, heh, I should have read to the end before repling. :)

> I bet with the likely() added the compiler is going to generate the same
> code either way, but I suppose I can have a look at what gcc actually
> does...

Yeah, with likely(), I *think* gcc should get it right most of the
time.  There might be some edge cases tho.

Thanks.

-- 
tejun
