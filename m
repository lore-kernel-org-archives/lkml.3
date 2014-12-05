Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaLEWls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:41:48 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34747 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaLEWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:41:47 -0500
Date: Fri, 5 Dec 2014 14:41:43 -0800
From: Tristan Lelong <tristan@lelong.xyz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, askb23@gmail.com,
        john.hammond@intel.com, gdonald@gmail.com, anhlq2110@gmail.com,
        fabio.falzoi84@gmail.com, oort10@gmail.com, agimenez@sysvalve.es,
        rupran@einserver.de, surya.seetharaman9@gmail.com,
        Julia.Lawall@lip6.fr, joe@perches.com, a.terekhov@gmail.com,
        liang.zhen@intel.com, vthakkar1994@gmail.com, amk@cray.com,
        srikrishanmalik@gmail.com, rd@radekdostal.com, bergwolf@gmail.com,
        dan.carpenter@oracle.com, paul.gortmaker@windriver.com,
        tapaswenipathak@gmail.com, email@christophjaeger.info,
        uja.ornl@gmail.com, brilliantov@inbox.ru, dmitry.eremin@intel.com,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Message-ID: <20141205224143.GB5698@localhost.localdomain>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
 <20141205212723.GA22536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205212723.GA22536@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 01:27:23PM -0800, Greg KH wrote:
> On Fri, Dec 05, 2014 at 12:03:47AM -0800, Tristan Lelong wrote:
> >  static ssize_t
> > -fld_proc_hash_seq_write(struct file *file, const char *buffer,
> > -			size_t count, loff_t *off)
> > +fld_proc_hash_seq_write(struct file *file,
> > +				const char __user *buffer,
> > +				size_t count, loff_t *off)
> >  {
> >  	struct lu_client_fld *fld;
> >  	struct lu_fld_hash *hash = NULL;
> > +	char name[80];
> >  	int i;
> >  
> > +	if (count > 80)
> > +		return -ENAMETOOLONG;
> > +
> > +	if (copy_from_user(name, buffer, count) != 0)
> > +		return -EFAULT;
> 
> How was this code ever working before?

I have no idea, and was actually surprised that this was there.

> 
> And I know Joe asked, but how do you know that 80 is ok?  And why on the
> stack?

80 is the sizeof(struct lu_fld_hash.fh_name) and there is no define for that.
A few other structure members are using this 80 value internally, and as I told
Joe, I will analyze if they are all related and submit a patch to use a define instead.

> 
> Shouldn't you just compare count to strlen(fld_hash[i].fh_name)? like you
> do later on?
> 

This is actually done in the for loop already. I first compare with the maximum size,
then the loop use the strlen of each entries in the table, and finally does the strncmp.

> 
> Anyway, I don't like large stack variables like this, can you make it
> dynamic instead?
> 

I can definitely do this with a kmalloc, I'll submit a v2 tonight.

Thanks
