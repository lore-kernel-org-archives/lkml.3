Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbaJ1Fsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:48:36 -0400
Received: from relay.parallels.com ([195.214.232.42]:50949 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaJ1Fse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:48:34 -0400
Message-ID: <1414475309.8574.8.camel@tkhai>
Subject: Re: [PATCH 2/3] introduce probe_slab_address()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Christoph Lameter <cl@linux.com>
Date: Tue, 28 Oct 2014 08:48:29 +0300
In-Reply-To: <1414475091.8574.6.camel@tkhai>
References: <1413962231.19914.130.camel@tkhai>
	 <20141027195339.GA11736@redhat.com> <20141027195425.GC11736@redhat.com>
	 <1414475091.8574.6.camel@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 28/10/2014 в 08:44 +0300, Kirill Tkhai пишет:
> В Пн, 27/10/2014 в 20:54 +0100, Oleg Nesterov пишет:
> > Extract the ifdef(CONFIG_DEBUG_PAGEALLOC) code from get_freepointer_safe()
> > into the new generic helper, probe_slab_address(). The next patch will add
> > another user.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  include/linux/uaccess.h |   15 +++++++++++++++
> >  mm/slub.c               |    6 +-----
> >  2 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> > index effb637..3367396 100644
> > --- a/include/linux/uaccess.h
> > +++ b/include/linux/uaccess.h
> > @@ -71,6 +71,21 @@ static inline unsigned long __copy_from_user_nocache(void *to,
> >  	__probe_kernel_read(&(retval), (__force void *)(addr), sizeof(retval))
> >  
> >  /*
> > + * Same as probe_kernel_address(), but @addr must be the valid pointer
> > + * to a slab object, potentially freed/reused/unmapped.
> > + */
> > +#ifdef CONFIG_DEBUG_PAGEALLOC
> > +#define probe_slab_address(addr, retval)	\
> > +	probe_kernel_address(addr, retval)
> > +#else
> > +#define probe_slab_address(addr, retval)	\
> > +	({							\
> > +		(retval) = *(typeof(retval) *)(addr);		\
> > +		0;						\
> > +	})
> > +#endif
> > +
> > +/*
> >   * probe_kernel_read(): safely attempt to read from a location
> >   * @dst: pointer to the buffer that shall take the data
> >   * @src: address to read from
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 3e8afcc..0467d22 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -265,11 +265,7 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
> >  {
> >  	void *p;
> >  
> > -#ifdef CONFIG_DEBUG_PAGEALLOC
> > -	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
> > -#else
> > -	p = get_freepointer(s, object);
> > -#endif
> > +	probe_slab_address(object + s->offset, p);
> >  	return p;
> >  }
> >  
> 
> probe_kernel_read() was arch-dependent on tree platforms:

Of course, I mean get_freepointer_safe() used to use arch-dependent
probe_kernel_read() on blackfin, parisc and um.

> arch/blackfin/mm/maccess.c
> arch/parisc/lib/memcpy.c
> arch/um/kernel/maccess.c
> 
> But now we skip these arch-dependent implementations. Is there no a problem?


