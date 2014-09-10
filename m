Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaIJFLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 01:11:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaIJFLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 01:11:17 -0400
Date: Tue, 9 Sep 2014 22:11:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-Id: <20140909221138.2587d864.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
	<20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
	<alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 07:05:40 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> > > --- a/mm/slab.c
> > > +++ b/mm/slab.c
> > > @@ -3612,7 +3612,7 @@ void kfree(const void *objp)
> > >  
> > >  	trace_kfree(_RET_IP_, objp);
> > >  
> > > -	if (unlikely(ZERO_OR_NULL_PTR(objp)))
> > > +	if (unlikely(ZERO_OR_NULL_PTR(objp) || IS_ERR(objp)))
> > >  		return;
> > 
> > kfree() is quite a hot path to which this will add overhead.  And we
> > have (as far as we know) no code which will actually use this at
> > present.
> 
> We obviously don't, as such code will be causing explosions. This is meant 
> as a prevention of problems such as the one that has just been fixed in 
> ext4.

Well.  I bet there exist sites which can pass an ERR_PTR to kfree but
haven't been know to do so yet because errors are rare.  Your patch
would fix all those by magic, but is it worth the overhead?

This is the sort of error which a static checker could find.  I wonder
if any of them do so.
