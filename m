Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaGVTB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:01:27 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63122 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaGVTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:24 -0400
Date: Tue, 22 Jul 2014 15:01:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] resource: Add device-managed
 request/release_resource()
Message-ID: <20140722190120.GM13851@htj.dyndns.org>
References: <1405062505-2606-1-git-send-email-thierry.reding@gmail.com>
 <20140722185002.GC19181@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722185002.GC19181@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 22, 2014 at 12:50:02PM -0600, Bjorn Helgaas wrote:
> [+cc Tejun, LKML]
> 
> On Fri, Jul 11, 2014 at 09:08:24AM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> > 
> > Provide device-managed implementations of the request_resource() and
> > release_resource() functions. Upon failure to request a resource, the
> > new devm_request_resource() function will output an error message for
> > consistent error reporting.
> > 
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> 
> This seems OK to me, but I don't consider myself a devres maintainer.  I
> added Tejun and LKML for any comment.  Minor nit below.

If there are gonna be users of the interface, sure.

> > +int devm_request_resource(struct device *dev, struct resource *root,
> > +			  struct resource *new)
> > +{
> > +	struct resource *conflict, **ptr;
> > +
> > +	ptr = devres_alloc(devm_resource_release, sizeof(*ptr), GFP_KERNEL);
> > +	if (!ptr)
> > +		return -ENOMEM;
> > +
> > +	*ptr = new;
> > +
> > +	conflict = request_resource_conflict(root, new);
> > +	if (!conflict) {
> > +		devres_add(dev, ptr);
> > +		return 0;
> > +	}
> > +
> > +	dev_err(dev, "resource collision: %pR conflicts with %s %pR\n", new,
> > +		conflict->name, conflict);
> > +	devres_free(ptr);
> > +	return -EBUSY;
> 
> Personally I would write this as:
> 
>   conflict = request_resource_conflict(...);
>   if (conflict) {
>     dev_err(...);
>     devres_free(...);
>     return -EBUSY;
>   }
> 
>   devres_add(...);
>   return 0;
> 
> so the straight-line path is the normal, non-error path and errors are
> detected and dealt with in the "if" bodies.  Right now the "if" bodies
> are a mix of error handling and normal path.  But that's just my personal
> preference.

Agreed.

> > +static int devm_resource_match(struct device *dev, void *res, void *data)
> > +{
> > +	struct resource **ptr = res;
> > +
> > +	if (WARN_ON(!ptr || !*ptr))
> > +		return 0;

How would !ptr or !*ptr possibly happen?  Wouldn't that be a bug
already?

Thanks.

-- 
tejun
