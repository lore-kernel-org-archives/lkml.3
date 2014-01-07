Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaAGOQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:16:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaAGOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:16:07 -0500
Date: Tue, 7 Jan 2014 06:16:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bvanassche@acm.org>,
        Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        mingo@kernel.org
Subject: Re: kobject: provide kobject_put_wait to fix module unload race
Message-ID: <20140107141622.GA32290@kroah.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
 <52C98BCC.9040900@acm.org>
 <20140105182640.GA2522@kroah.com>
 <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com>
 <20140106213111.GA2536@redhat.com>
 <alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 11:01:22PM -0500, Mikulas Patocka wrote:
> 
> 
> On Mon, 6 Jan 2014, Mike Snitzer wrote:
> 
> > On Mon, Jan 06 2014 at  1:55pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > 
> > > 
> > > On Sun, 5 Jan 2014, Greg Kroah-Hartman wrote:
> > > 
> > > > On Sun, Jan 05, 2014 at 05:43:56PM +0100, Bart Van Assche wrote:
> > > > > On 01/04/14 19:06, Mikulas Patocka wrote:
> > > > > > -	if (t && !t->release)
> > > > > > -		pr_debug("kobject: '%s' (%p): does not have a release() "
> > > > > > -			 "function, it is broken and must be fixed.\n",
> > > > > > -			 kobject_name(kobj), kobj);
> > > > > > -
> > > > > 
> > > > > Has it been considered to issue a warning if no release function has
> > > > > been defined and free_completion == NULL instead of removing the above
> > > > > debug message entirely ? I think even with this patch applied it is
> > > > > still wrong to invoke kobject_put() on an object without defining a
> > > > > release function.
> > > > 
> > > > This patch isn't going to be applied, and I've reverted the original
> > > > commit, so there shouldn't be any issues anymore with this code.
> > > 
> > > Why? This patch does the same thing as 
> > > eee031649707db3c9920d9498f8d03819b74fc23, but it's smaller. So why did you 
> > > accept eee031649707db3c9920d9498f8d03819b74fc23 and not this?
> > > 
> > > The code to wait for kobject destruction using completion already exists 
> > > in cpufreq_sysfs_release, cpuidle_sysfs_release, 
> > > cpuidle_state_sysfs_release, cpuidle_driver_sysfs_release, 
> > > ext4_sb_release, ext4_feat_release, f2fs_sb_release (these are the only 
> > > kobject users that are correct w.r.t. module unloading), so if you accept 
> > > this patch, you can simplify them to use kobject_put_wait.
> > 
> > Hi Mikulas,
> > 
> > Please just submit a DM-only patch that follows the same racey pattern
> > of firing a completion from the kobj_type .release method in dm_mod.
> > I'll get it queued up for 3.14.
> > 
> > If/when we gets reports of a crash due to dm_mod unload racing with
> > kobject_put we can revisit this.
> > 
> > Thanks,
> > Mike
> 
> Here I'm sending dm-only patch.
> 
> 
> 
> dm: wait until kobject is destroyed
> 
> There may be other parts of the kernel taking reference to the dm kobject.
> We must wait until they drop the references before deallocating the md
> structure.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-sysfs.c |   10 +++++++++-
>  drivers/md/dm.c       |   11 +++++++++++
>  drivers/md/dm.h       |    2 ++
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> Index: linux-3.13-rc7/drivers/md/dm-sysfs.c
> ===================================================================
> --- linux-3.13-rc7.orig/drivers/md/dm-sysfs.c	2014-01-07 02:06:08.000000000 +0100
> +++ linux-3.13-rc7/drivers/md/dm-sysfs.c	2014-01-07 02:07:09.000000000 +0100
> @@ -79,6 +79,11 @@ static const struct sysfs_ops dm_sysfs_o
>  	.show	= dm_attr_show,
>  };
>  
> +static void dm_kobject_release(struct kobject *kobj)
> +{
> +	complete(dm_get_completion_from_kobject(kobj));
> +}

Please read the kobject documentation in the kernel tree for why this
isn't ok.  The fact that you didn't have a release function at all means
this code has always been broken, why have you been ignoring the kernel
complaining about this for so long before?

You need to free the memory in the release function, not just sit around
and wait for potentially forever.

thanks,

greg k-h
