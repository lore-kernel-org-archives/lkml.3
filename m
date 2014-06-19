Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228AbaFSXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:09:28 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:59038 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965473AbaFSXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:09:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqVmAOFso1N5LC2vPGdsb2JhbABZgw2DSIUIonYBAQEBAQEGmSkBgQwXBAEBAQE4NYQDAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQc0vFxaFTIkUB4RDBJpCizGLfCs
Date: Fri, 20 Jun 2014 09:09:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] init/do_mounts.c: treat EROFS like EACCES
Message-ID: <20140619230924.GO4453@dastard>
References: <1403107964-1082-1-git-send-email-phdm@macqel.be>
 <20140619141950.18b9026d7d06694291eea311@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619141950.18b9026d7d06694291eea311@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 02:19:50PM -0700, Andrew Morton wrote:
> On Wed, 18 Jun 2014 18:12:44 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> 
> > some combinations of filesystem and block device (at least vfat on mmc)
> > yield -EROFS instead of -EACCES when the device is read-only.  Retry
> > mounting with MS_RDONLY set, just like for the EACCES case, instead of
> > failing directly.
> > 
> > ...
> >
> > --- a/init/do_mounts.c
> > +++ b/init/do_mounts.c
> > @@ -394,6 +394,7 @@ retry:
> >  			case 0:
> >  				goto out;
> >  			case -EACCES:
> > +			case -EROFS:
> >  				flags |= MS_RDONLY;
> >  				goto retry;
> >  			case -EINVAL:
> 
> hm, what's going on here.  I'd have thought it to be very logical that
> file_system_type.mount() would return EROFS if the device is read-only!
> But I'm suspecting that there is some convention that the fs is
> supposed to return EACCES in this case.  So *perhaps* it is vfat-on-mmc
> which needs fixing.  Dunno.
> 
> Al, are you able to shed light?

from the mount(2) man page:

EACCES	A  component  of  a  path  was not searchable.  (See also
	path_resolution(7).)  Or, mounting a read-only filesystem
	was attempted without giving the MS_RDONLY flag.  Or, the
	block device source is located on a filesystem mounted with
	the MS_NODEV option.

So, when the device is read-only, the error should EACCES, not
EROFS. Would seem to me that vfat-on-mmc needs fixing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
