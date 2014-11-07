Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaKGQbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:31:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:31:44 -0500
Date: Fri, 7 Nov 2014 08:31:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141107163143.GD10256@kroah.com>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <20141104163845.GA369@kroah.com>
 <20141105091351.GA12033@ulmo>
 <20141106021815.GA17253@kroah.com>
 <20141106102531.GI26297@ulmo>
 <20141106161321.GB14873@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106161321.GB14873@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:13:24PM +0100, Thierry Reding wrote:
> On Thu, Nov 06, 2014 at 11:25:32AM +0100, Thierry Reding wrote:
> > On Wed, Nov 05, 2014 at 06:18:15PM -0800, Greg Kroah-Hartman wrote:
> [...]
> > > Sure, document it better if you want, but I think something needs to be
> > > done differently if at all possible.
> > 
> > try_module_get() is the only way I know of that ensures that the code of
> > a module stays around. Everytime we give out a new reference to a record
> > we also need to increment the module reference count accordingly to make
> > sure the underlying code doesn't go away all of a sudden.
> > 
> > I guess that's not entirely accurate. The module reference count doesn't
> > have to be increment for every record reference, it only needs to track
> > each record. So the try_module_get() and module_put() could move into
> > registry_add() and registry_get(), respectively. But the ->owner field
> > would still be in the record structure.
> 
> On further thought I don't think this will work either. Given that the
> record can be removed from the registry while somebody else still has a
> reference to it, the module owning the record must stay around as long
> as there's a reference to the record.
> 
> Maybe the module reference count needs to be incremented when the record
> is initialized and decremented when the record is released.

The module reference count will never work as it is racy (you can't have
the module itself do the incrementing, which is what is happening here).

I'd argue that the module reference isn't needed at all, because if the
module shuts down and wants to be removed, it will have properly cleaned
up all of its data structures already, right?  So why use it?

greg k-h
