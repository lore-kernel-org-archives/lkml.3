Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967579AbaFTNNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:13:38 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:54220 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965175AbaFTNNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:13:37 -0400
Date: Fri, 20 Jun 2014 15:13:28 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] init/do_mounts.c: treat EROFS like EACCES
Message-ID: <20140620131328.GA31693@frolo.macqel>
References: <1403107964-1082-1-git-send-email-phdm@macqel.be> <20140619141950.18b9026d7d06694291eea311@linux-foundation.org> <20140619230924.GO4453@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619230924.GO4453@dastard>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:09:24AM +1000, Dave Chinner wrote:
> On Thu, Jun 19, 2014 at 02:19:50PM -0700, Andrew Morton wrote:
> > On Wed, 18 Jun 2014 18:12:44 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> > 
> > > some combinations of filesystem and block device (at least vfat on mmc)
> > > yield -EROFS instead of -EACCES when the device is read-only.  Retry
> > > mounting with MS_RDONLY set, just like for the EACCES case, instead of
> > > failing directly.
> > > 
> > > ...
> > >
> > > --- a/init/do_mounts.c
> > > +++ b/init/do_mounts.c
> > > @@ -394,6 +394,7 @@ retry:
> > >  			case 0:
> > >  				goto out;
> > >  			case -EACCES:
> > > +			case -EROFS:
> > >  				flags |= MS_RDONLY;
> > >  				goto retry;
> > >  			case -EINVAL:
> > 
> > hm, what's going on here.  I'd have thought it to be very logical that
> > file_system_type.mount() would return EROFS if the device is read-only!
> > But I'm suspecting that there is some convention that the fs is
> > supposed to return EACCES in this case.  So *perhaps* it is vfat-on-mmc
> > which needs fixing.  Dunno.
> > 
> > Al, are you able to shed light?
> 
> from the mount(2) man page:
> 
> EACCES	A  component  of  a  path  was not searchable.  (See also
> 	path_resolution(7).)  Or, mounting a read-only filesystem
> 	was attempted without giving the MS_RDONLY flag.  Or, the
> 	block device source is located on a filesystem mounted with
> 	the MS_NODEV option.
> 
> So, when the device is read-only, the error should EACCES, not
> EROFS. Would seem to me that vfat-on-mmc needs fixing...

Looking at the sources of mount(1)

https://github.com/karelzak/util-linux/blob/master/sys-utils/mount.c

at line 601, we clearly see that mount(1) allows mount(2) to fail
with EROFS.

We could as well fix the man page of mount(2)

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
