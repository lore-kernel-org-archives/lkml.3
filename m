Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaKFCSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:18:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKFCSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:18:16 -0500
Date: Wed, 5 Nov 2014 18:18:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141106021815.GA17253@kroah.com>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <20141104163845.GA369@kroah.com>
 <20141105091351.GA12033@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105091351.GA12033@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:13:53AM +0100, Thierry Reding wrote:
> On Tue, Nov 04, 2014 at 08:38:45AM -0800, Greg Kroah-Hartman wrote:
> > On Tue, Nov 04, 2014 at 05:29:27PM +0100, Thierry Reding wrote:
> [...]
> > > diff --git a/drivers/base/registry.c b/drivers/base/registry.c
> [...]
> > > +/**
> > > + * registry_record_ref - reference on the registry record
> > > + * @record: record to reference
> > > + *
> > > + * Increases the reference count on the record and returns a pointer to it.
> > > + *
> > > + * Return: A pointer to the record on success or NULL on failure.
> > > + */
> > > +struct registry_record *registry_record_ref(struct registry_record *record)
> > > +{
> > > +	if (!record)
> > > +		return NULL;
> > > +
> > > +	/*
> > > +	 * Refuse to give out any more references if the module owning the
> > > +	 * record is being removed.
> > > +	 */
> > > +	if (!try_module_get(record->owner))
> > > +		return NULL;
> > > +
> > > +	kref_get(&record->kref);
> > 
> > You "protect" from a module being removed, but not from someone else
> > releasing the kref at the same time.  Where is the lock that prevents
> > this from happening?
> 
> You're right, we need a record lock to serialize ref/unref.
> 
> > And do we really care about module reference counts here?
> 
> We need this so that the code of the .release() callback stays in
> memory as long as there are any references.
> 
> Also we need the module reference count for registries because they
> would typically be statically allocated and go away along with a module
> when it is unloaded.

Never use a 'static' variable as a dynamic one with a kref, that's just
asking for trouble.

> > > +/**
> > > + * registry_add - add a record to a registry
> > > + * @registry: registry to add the record to
> > > + * @record: record to add
> > > + *
> > > + * Tries to increase the reference count of the module owning the registry. If
> > > + * successful adds the new record to the registry.
> > > + *
> > > + * Return: 0 on success or a negative error code on failure.
> > > + */
> > > +int registry_add(struct registry *registry, struct registry_record *record)
> > > +{
> > > +	if (!try_module_get(registry->owner))
> > > +		return -ENODEV;
> > > +
> > > +	mutex_lock(&registry->lock);
> > > +	list_add_tail(&record->list, &registry->list);
> > > +	mutex_unlock(&registry->lock);
> > 
> > No incrementing of the reference of the record at all?
> 
> I'm not sure if we really need one. Drivers will have to remove the
> record from the registry before dropping their reference. I guess we
> could throw in another kref_get() here (and a kref_put() in
> registry_remove()) for good measure to prevent breakage with buggy
> drivers.

Or at least warn people that they need to clean stuff up properly if
they do not, otherwise they will get it wrong.  You need to make it very
hard to get wrong.

> > You seem to be using 2 reference counts for the record / registry, a
> > module count, and a kref count, which can cause confusion...
> 
> There is one reference count (kref actually) per registry record and one
> module count for the record owner and the registry owner.

But both counts are in the same structure, which is a mess.

> Can you elaborate what you think is confusing? Perhaps I can add more
> kerneldoc to clarify.

You have 2 references in the same structure, with different lifecycles,
causing confusion, and odds are, bugs...

Sure, document it better if you want, but I think something needs to be
done differently if at all possible.

thanks,

greg k-h
