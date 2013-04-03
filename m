Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3DCQIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:08:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61728 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3DCQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:08:13 -0400
Date: Wed, 3 Apr 2013 09:08:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] sysfs: check if one entry has been removed before freeing
Message-ID: <20130403160811.GA21383@kroah.com>
References: <1364957903-10341-1-git-send-email-ming.lei@canonical.com>
 <20130403030403.GA26913@redhat.com>
 <CACVXFVPOC=d3-1UBu6UbqJXMS2gG=DXnBJeuLaFc3R4QKAzWyg@mail.gmail.com>
 <20130403053534.GA8091@kroah.com>
 <CACVXFVMV6cFhrybrE_oNSthzPF71xOE7dbwTK9GP+x08d3TpQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMV6cFhrybrE_oNSthzPF71xOE7dbwTK9GP+x08d3TpQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 03:05:37PM +0800, Ming Lei wrote:
> On Wed, Apr 3, 2013 at 1:35 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Apr 03, 2013 at 11:52:39AM +0800, Ming Lei wrote:
> >> On Wed, Apr 3, 2013 at 11:04 AM, Dave Jones <davej@redhat.com> wrote:
> >> > On Wed, Apr 03, 2013 at 10:58:23AM +0800, Ming Lei wrote:
> >> >
> >> >  > diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> >> >  > index 1bf016b..328ef9b 100644
> >> >  > --- a/fs/sysfs/dir.c
> >> >  > +++ b/fs/sysfs/dir.c
> >> >  > @@ -268,6 +268,13 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
> >> >  >       */
> >> >  >      parent_sd = sd->s_parent;
> >> >  >
> >> >  > +    if (unlikely(!(sd->s_flags & SYSFS_FLAG_REMOVED))) {
> >> >  > +            printk(KERN_ERR "sysfs: free using entry: %s/%s\n",
> >> >  > +                    parent_sd ? parent_sd->s_name : "",
> >> >  > +                    sd->s_name);
> >> >  > +            BUG();
> >> >  > +    }
> >> >
> >> > Please use WARN instead of BUG.  For an in-ram filesystem like
> >> > sysfs, there's no real reason to lock-up the machine in this way
> >> > making it harder to debug.
> >>
> >> If WARN is used, the freed memory will be allocated to other
> >> kernel components, then sysfs may change the memory and cause
> >> destruction, so maybe it is better to use BUG to stop kernel.
> >
> > No, it's never ok to call BUG(), sorry, please fix this.
> 
> Sorry, could you explain it in a bit detail? IMO, it is really a bug
> when code runs here, and there are much similar BUG_ON()
> uses in current sysfs code too.

Then make it a WARN() call, like David said, to give us a chance to get
the report from a user so we can fix it.  If the machine crashes after
that, fine, but hopefully we will get a oops report out of it.

greg k-h
