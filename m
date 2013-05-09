Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3EIT0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:26:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35407 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3EIT0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:26:06 -0400
Date: Thu, 9 May 2013 14:24:20 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv10 1/4] debugfs: add get/set for atomic types
Message-ID: <20130509192420.GA13705@medulla>
References: <1368052661-27143-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368052661-27143-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <xr934necrndi.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr934necrndi.fsf@gthelen.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050919-2876-0000-0000-0000086DB011
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:58:49AM -0700, Greg Thelen wrote:
> On Wed, May 08 2013, Seth Jennings wrote:
> 
> > debugfs currently lack the ability to create attributes
> > that set/get atomic_t values.
> >
> > This patch adds support for this through a new
> > debugfs_create_atomic_t() function.
> >
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Acked-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  fs/debugfs/file.c       | 42 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/debugfs.h |  2 ++
> >  2 files changed, 44 insertions(+)
> >
> > diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> > index c5ca6ae..fa26d5b 100644
> > --- a/fs/debugfs/file.c
> > +++ b/fs/debugfs/file.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/debugfs.h>
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > +#include <linux/atomic.h>
> >  
> >  static ssize_t default_read_file(struct file *file, char __user *buf,
> >  				 size_t count, loff_t *ppos)
> > @@ -403,6 +404,47 @@ struct dentry *debugfs_create_size_t(const char *name, umode_t mode,
> >  }
> >  EXPORT_SYMBOL_GPL(debugfs_create_size_t);
> >  
> > +static int debugfs_atomic_t_set(void *data, u64 val)
> > +{
> > +	atomic_set((atomic_t *)data, val);
> > +	return 0;
> > +}
> > +static int debugfs_atomic_t_get(void *data, u64 *val)
> > +{
> > +	*val = atomic_read((atomic_t *)data);
> > +	return 0;
> > +}
> > +DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_t, debugfs_atomic_t_get,
> > +			debugfs_atomic_t_set, "%llu\n");
> > +DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_t_ro, debugfs_atomic_t_get, NULL, "%llu\n");
> > +DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_t_wo, NULL, debugfs_atomic_t_set, "%llu\n");
> > +
> > +/**
> > + * debugfs_create_atomic_t - create a debugfs file that is used to read and
> > + * write an atomic_t value
> > + * @name: a pointer to a string containing the name of the file to create.
> > + * @mode: the permission that the file should have
> > + * @parent: a pointer to the parent dentry for this file.  This should be a
> > + *          directory dentry if set.  If this parameter is %NULL, then the
> > + *          file will be created in the root of the debugfs filesystem.
> > + * @value: a pointer to the variable that the file should read to and write
> > + *         from.
> > + */
> > +struct dentry *debugfs_create_atomic_t(const char *name, umode_t mode,
> > +				 struct dentry *parent, atomic_t *value)
> > +{
> > +	/* if there are no write bits set, make read only */
> > +	if (!(mode & S_IWUGO))
> > +		return debugfs_create_file(name, mode, parent, value,
> > +					&fops_atomic_t_ro);
> > +	/* if there are no read bits set, make write only */
> > +	if (!(mode & S_IRUGO))
> > +		return debugfs_create_file(name, mode, parent, value,
> > +					&fops_atomic_t_wo);
> > +
> > +	return debugfs_create_file(name, mode, parent, value, &fops_atomic_t);
> > +}
> > +EXPORT_SYMBOL_GPL(debugfs_create_atomic_t);
> >  
> >  static ssize_t read_file_bool(struct file *file, char __user *user_buf,
> >  			      size_t count, loff_t *ppos)
> > diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> > index 63f2465..d68b4ea 100644
> > --- a/include/linux/debugfs.h
> > +++ b/include/linux/debugfs.h
> > @@ -79,6 +79,8 @@ struct dentry *debugfs_create_x64(const char *name, umode_t mode,
> >  				  struct dentry *parent, u64 *value);
> >  struct dentry *debugfs_create_size_t(const char *name, umode_t mode,
> >  				     struct dentry *parent, size_t *value);
> > +struct dentry *debugfs_create_atomic_t(const char *name, umode_t mode,
> > +				     struct dentry *parent, atomic_t *value);
> >  struct dentry *debugfs_create_bool(const char *name, umode_t mode,
> >  				  struct dentry *parent, u32 *value);
> 
> Looking at v3.9 I see a conflicting definition of
> debugfs_create_atomic_t() in lib/fault-inject.c.  A kernel with this
> patch and CONFIG_FAULT_INJECTION=y and CONFIG_FAULT_INJECTION_DEBUG_FS=y
> will not build:
> 
>     lib/fault-inject.c:196:23: error: static declaration of 'debugfs_create_atomic_t' follows non-static declaration
>     include/linux/debugfs.h:87:16: note: previous declaration of 'debugfs_create_atomic_t' was here
> 

Wow... didn't think to look for debugfs functions _outside_ the debugfs code :-/

Great find though, thanks Greg!

Seth

