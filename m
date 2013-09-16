Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3IPIp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:45:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab3IPIpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:45:25 -0400
Date: Mon, 16 Sep 2013 11:47:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
Message-ID: <20130916084727.GB1222@redhat.com>
References: <87ioy11k8s.fsf@rustcorp.com.au>
 <20130916165344.144f0d0f1b58111f1c8c87cc@canb.auug.org.au>
 <20130916072603.GA11007@redhat.com>
 <20130916180231.1570f7c5cebab599cef5b4bb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916180231.1570f7c5cebab599cef5b4bb@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 06:02:31PM +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> On Mon, 16 Sep 2013 10:26:03 +0300 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >
> > On Mon, Sep 16, 2013 at 04:53:44PM +1000, Stephen Rothwell wrote:
> > > 
> > > On Mon, 16 Sep 2013 13:38:35 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > >
> > > > Predates git, does anyone remember the rationale?
> > > > 
> > > > ie:
> > > >         int test_bit(int nr, const volatile unsigned long *addr)
> > > 
> > > Because we sometimes pass volatile pointers to it and gcc will complain
> > > if you pass a volatile to a non volatile  (I think).
> > 
> > Where are these? I did git grep -W test_bit and looked for volatile,
> > couldn't find anything.
> 
> OK, so it was a bit of a guess.  Have you really checked the type of
> every address passed to every call of test_bit()?

Yea, I have this magic tool called gcc :)

Change
-static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(long nr, const unsigned long *addr)

and watch for new warnings.

I didn't see any.

> Second guess:  we wanted to make the test_bit access volatile (as opposed
> to the datatypes of the objects being tested) so that things like
> 
> 	while (testbit(bit, addr)) {
> 		do_very_little();
> 	}
> 
> don't get over optimised (since we are operating in a very threaded
> environment that the compiler not might expect).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


