Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaLEIhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:37:23 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55273 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaLEIhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:37:22 -0500
Date: Fri, 5 Dec 2014 00:37:41 -0800
From: Tristan Lelong <tristan@lelong.xyz>
To: Joe Perches <joe@perches.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, askb23@gmail.com, john.hammond@intel.com,
        gdonald@gmail.com, anhlq2110@gmail.com, fabio.falzoi84@gmail.com,
        oort10@gmail.com, agimenez@sysvalve.es, rupran@einserver.de,
        surya.seetharaman9@gmail.com, Julia.Lawall@lip6.fr,
        a.terekhov@gmail.com, liang.zhen@intel.com, vthakkar1994@gmail.com,
        amk@cray.com, srikrishanmalik@gmail.com, rd@radekdostal.com,
        bergwolf@gmail.com, dan.carpenter@oracle.com,
        paul.gortmaker@windriver.com, tapaswenipathak@gmail.com,
        email@christophjaeger.info, uja.ornl@gmail.com, brilliantov@inbox.ru,
        dmitry.eremin@intel.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Message-ID: <20141205083741.GA5570@dunderer>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
 <1417768091.2721.47.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417768091.2721.47.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 12:28:11AM -0800, Joe Perches wrote:
> On Fri, 2014-12-05 at 00:03 -0800, Tristan Lelong wrote:
> > This patch fix a sparse warning in lustre sources
> > 
> > warning: incorrect type in argument 1 (different address spaces)
> >     expected void [noderef] <asn:1>*to
> >     got char *<noident>
> []
> > diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
> []
> > @@ -87,13 +87,21 @@ fld_proc_hash_seq_show(struct seq_file *m, void *unused)
> >  }
> >  
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
> > +
> >  	fld = ((struct seq_file *)file->private_data)->private;
> >  	LASSERT(fld != NULL);
> >  
> 
> Why 80?  Is there no #define for this length?
> 
No, there is no define.

I thought about adding one, but several other files and structure members in the lustre sources are using this specific value, and it seemed like a modification to do in another patch.

Let me know if you feel I should do it in a patch serie.

Regards
