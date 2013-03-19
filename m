Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3CSA3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:29:49 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:65294 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3CSA3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:29:47 -0400
Date: Mon, 18 Mar 2013 17:29:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: use atomic_inc_unless_negative in sysfs_get_active
Message-ID: <20130319002942.GI3042@htj.dyndns.org>
References: <5139FEAF.5080200@gmail.com>
 <20130319001418.GA13502@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319001418.GA13502@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 05:14:18PM -0700, Greg KH wrote:
> On Fri, Mar 08, 2013 at 04:07:27PM +0100, Maarten Lankhorst wrote:
> > It seems that sysfs has an interesting way of doing the same thing.
> > This removes the cpu_relax unfortunately, but if it's really needed,
> > it would be better to add this to include/linux/atomic.h to benefit
> > all atomic ops users.
> > 
> > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> >  ---
> 
> Tejun wrote this code originally, so I'll defer to him as to if the
> patch below is a valid cleanup or not.

Yeah, I think that code predates atomic_inc_unless_negative().

> > diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> > index 2fbdff6..7f968ed 100644
> > --- a/fs/sysfs/dir.c
> > +++ b/fs/sysfs/dir.c
> > @@ -165,21 +165,8 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
> >  	if (unlikely(!sd))
> >  		return NULL;
> >  
> > -	while (1) {
> > -		int v, t;
> > -
> > -		v = atomic_read(&sd->s_active);
> > -		if (unlikely(v < 0))
> > -			return NULL;
> > -
> > -		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
> > -		if (likely(t == v))
> > -			break;
> > -		if (t < 0)
> > -			return NULL;
> > -
> > -		cpu_relax();
> > -	}
> > +	if (!atomic_inc_unless_negative(&sd->s_active))
> > +		return NULL;

Looks good to me.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
