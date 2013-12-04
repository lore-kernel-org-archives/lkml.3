Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3LDXZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:25:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55439 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3LDXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:25:03 -0500
Date: Wed, 4 Dec 2013 23:21:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>, arve@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, ccross@android.com, Dave.Butcher@arm.com,
        irogers@google.com, romlem@android.com
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat
 layer
Message-ID: <20131204232118.1c3db844@alan.etchedpixels.co.uk>
In-Reply-To: <20131204183554.GA16693@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013 10:35:54 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Dec 04, 2013 at 06:09:41PM +0000, Serban Constantinescu wrote:
> > +#define size_helper(x) ({						    \
> > +	size_t __size;							    \
> > +	if (!is_compat_task())						    \
> > +		__size = sizeof(x);					    \
> > +	else if (sizeof(x) == sizeof(struct flat_binder_object))	    \
> > +		__size = sizeof(struct compat_flat_binder_object);	    \
> > +	else if (sizeof(x) == sizeof(struct binder_transaction_data))	    \
> > +		__size = sizeof(struct compat_binder_transaction_data);	    \
> > +	else if (sizeof(x) == sizeof(size_t))				    \
> > +		__size = sizeof(compat_size_t);				    \
> > +	else								    \
> > +		 BUG();							    \
> > +	__size;								    \
> > +	})
> 
> Ick.
> 
> First off, no driver should ever be able to crash the kernel, which you
> just did.

And which would appear to mean that this code hasn't actually been
tested - at least not properly with error cases ?

You talk about type safety too but your code is already full of
"put_user(node->ptr, (void * __user *)ptr))"

The binder_copy_to_user thing is pretty confusingly named - it sounds
like a wrapper but is in fact a whole set of operations with two
different values and extra cookie structures and the like

Would something like

binder_put_userptr(mode->ptr, &ptr)

perhaps be a shade easier to follow as a set of changes, and less clunky ?


And 3/9 you could have done a clean up .. instead of replacing endless
repeats of 

-			cmd == BC_INCREFS_DONE ?
-			"BC_INCREFS_DONE" :
-			"BC_ACQUIRE_DONE",
+			acquire ?
+			"BC_ACQUIRE_DONE" :
+			"BC_INCREFS_DONE",

couldn't you do that bit in just one place ?

Ditto


-			cmd == BC_REQUEST_DEATH_NOTIFICATION ?
+			request ?
 			"BC_REQUEST_DEATH_NOTIFICATION" :
 			"BC_CLEAR_DEATH_NOTIFICATION",


The "_helper" stuff with type and size magic also really obfuscates the
code horribly


+static inline struct flat_binder_object *copy_flat_binder_object(void
__user *ptr) +{
+	return (struct flat_binder_object *)ptr;
+}


What were you arguing about type safety again ?


While I'm tempted to answer "and that children is what happens when you
don't take your interfaces mainstream and peer review them in the first
place" I appreciate it won't help ;-)

I think I'd rather see the structures fixed up to be correct and properly
type stable for 64bit on a 64bit box including u64 user pointers.

For 32bit then yes you probably have to do something icky like


struct binder_foo64 {
}

struct binder_foo_compat {
}

#if 32bit
#define binder_foo binder_foo_compat
#else
#define binder_foo binder_foo64
#endif

but I do think it would make the rest of the code look less like a lesson
on pointer and GNU extension obfuscation and when 32bit finally gets
buried the uglies can be removed.

Alan
