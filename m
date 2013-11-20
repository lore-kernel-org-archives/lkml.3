Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3KTGap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 01:30:45 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42038 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTGam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 01:30:42 -0500
Date: Wed, 20 Nov 2013 01:30:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: use a separate locking class for open files
 depending on mmap
Message-ID: <20131120063039.GB16081@mtj.dyndns.org>
References: <20131113184538.GA7269@redhat.com>
 <20131113201043.GE13318@ZenIV.linux.org.uk>
 <20131114054116.GC29031@mtj.dyndns.org>
 <20131115011916.GA19453@redhat.com>
 <20131117021736.GA9302@mtj.dyndns.org>
 <20131117032119.GA26529@redhat.com>
 <20131117032937.GB9302@mtj.dyndns.org>
 <20131118044523.GA4814@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118044523.GA4814@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 08:45:23PM -0800, Greg Kroah-Hartman wrote:
> On Sun, Nov 17, 2013 at 12:29:37PM +0900, Tejun Heo wrote:
> > On Sat, Nov 16, 2013 at 10:21:19PM -0500, Dave Jones wrote:
> > > On Sun, Nov 17, 2013 at 11:17:36AM +0900, Tejun Heo wrote:
> > > 
> > >  
> > >  > +	if (has_mmap)
> > >  > +		mutex_init(&of->mutex);
> > >  > +	else
> > >  > +		mutex_init(&of->mutex);
> > > 
> > > ummm...
> > 
> > Supposed to look that way.  It'll give two separate static lock class
> > keys to of->mutex.  Yeah, looks weird.  Any better ideas?
> 
> Doesn't gcc optimize that away to just one lock class anyway?

Well, it basically becomes

	if (has_mmap) {
		static struct lock_class_key key;
		__mutex_init(blah, &key);
	} else {
		static struct lock_class_key key;
		__mutex_init(blah, &key);
	}

So, the compiler isn't allowed to merge the two keys and we actually
use constructs like the above from a few places.  Yeah, it is weird
but does work.

Thanks.

-- 
tejun
