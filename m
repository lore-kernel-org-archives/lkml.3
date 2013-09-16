Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3IPItm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:49:42 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45357 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3IPItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:49:41 -0400
Message-ID: <1379321380.15916.23.camel@linux-fkkt.site>
Subject: Re: Why does test_bit() take a volatile addr?
From: Oliver Neukum <oliver@neukum.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, torvalds@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 10:49:40 +0200
In-Reply-To: <20130916084453.GA1222@redhat.com>
References: <87ioy11k8s.fsf@rustcorp.com.au>
	 <1379320800.15916.15.camel@linux-fkkt.site>
	 <20130916084453.GA1222@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 11:44 +0300, Michael S. Tsirkin wrote:
> On Mon, Sep 16, 2013 at 10:40:00AM +0200, Oliver Neukum wrote:
> > On Mon, 2013-09-16 at 13:38 +0930, Rusty Russell wrote:
> > > Predates git, does anyone remember the rationale?
> > > 
> > > ie:
> > >         int test_bit(int nr, const volatile unsigned long *addr)
> > > 
> > > I noticed because gcc failed to elimiate some code in a patch I was
> > > playing with.
> > > 
> > > I'm nervous about subtle bugs involved in ripping it out, even if noone
> > > knows why.  Should I add __test_bit()?
> > 
> > It seems to me that if you do
> > 
> > b = *ptr & 0xf;
> > c = b << 2;
> > if (test_bit(1, ptr))
> > 
> > the compiler could optimize away the memory access on ptr without
> > the volatile. We'd have to add a lot of mb().
> > 
> > 	Regards
> > 		Oliver
> 
> What is this code supposed to do?
> Any specific examples?
> 

Often you see

while (test_bit(...) && condition) ... ;

If the compiler can show that you don't change the memory you
do the test_bit on, it can change this to:

if (test_bit(...))
	while (condition) ...;

That must not happen.

	Regards
		Oliver


