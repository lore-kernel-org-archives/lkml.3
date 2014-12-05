Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaLEV1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:27:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLEV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:27:24 -0500
Date: Fri, 5 Dec 2014 13:27:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tristan Lelong <tristan@lelong.xyz>
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
Message-ID: <20141205212723.GA22536@kroah.com>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 12:03:47AM -0800, Tristan Lelong wrote:
> This patch fix a sparse warning in lustre sources
> 
> warning: incorrect type in argument 1 (different address spaces)
>     expected void [noderef] <asn:1>*to
>     got char *<noident>
> 
> This is done by adding the missing __user attribute on userland pointers inside
> the LPROC_SEQ_FOPS-like macros:
> - LPROC_SEQ_FOPS
> - LPROC_SEQ_FOPS_RW_TYPE
> - LPROC_SEQ_FOPS_WR_ONLY
> - LDLM_POOL_PROC_WRITER
> 
> The patch also updates all the functions that are used by this macro:
> - lprocfs_wr_*
> - *_seq_write
> 
> as well as some helpers used by the previously modified functions (otherwise
> fixing the sparse warning add some new ones):
> - lprocfs_write_frac_helper
> - lprocfs_write_helper
> - lprocfs_write_u64_helper
> 
> The patch also fixes one __user pointer direct dereference by strncmp
> in function fld_proc_hash_seq_write by adding the proper copy_from_user.
> 
> Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
> ---
>  drivers/staging/lustre/lustre/fld/lproc_fld.c      | 14 ++++--
>  .../staging/lustre/lustre/include/lprocfs_status.h | 44 +++++++++--------
>  drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |  5 +-
>  drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  4 +-
>  drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |  7 +--
>  drivers/staging/lustre/lustre/lov/lproc_lov.c      | 20 +++++---
>  drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |  7 +--
>  .../lustre/lustre/obdclass/linux/linux-module.c    |  5 +-
>  .../lustre/lustre/obdclass/lprocfs_status.c        |  2 +-
>  drivers/staging/lustre/lustre/osc/lproc_osc.c      | 57 +++++++++++++---------
>  .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    | 25 +++++-----
>  11 files changed, 114 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
> index 95e7de1..9f1db6c 100644
> --- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
> +++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
> @@ -87,13 +87,21 @@ fld_proc_hash_seq_show(struct seq_file *m, void *unused)
>  }
>  
>  static ssize_t
> -fld_proc_hash_seq_write(struct file *file, const char *buffer,
> -			size_t count, loff_t *off)
> +fld_proc_hash_seq_write(struct file *file,
> +				const char __user *buffer,
> +				size_t count, loff_t *off)
>  {
>  	struct lu_client_fld *fld;
>  	struct lu_fld_hash *hash = NULL;
> +	char name[80];
>  	int i;
>  
> +	if (count > 80)
> +		return -ENAMETOOLONG;
> +
> +	if (copy_from_user(name, buffer, count) != 0)
> +		return -EFAULT;

How was this code ever working before?

And I know Joe asked, but how do you know that 80 is ok?  And why on the
stack?

Shouldn't you just compare count to strlen(fld_hash[i].fh_name)? like you
do later on?

> +
>  	fld = ((struct seq_file *)file->private_data)->private;
>  	LASSERT(fld != NULL);
>  
> @@ -101,7 +109,7 @@ fld_proc_hash_seq_write(struct file *file, const char *buffer,
>  		if (count != strlen(fld_hash[i].fh_name))
>  			continue;
>  
> -		if (!strncmp(fld_hash[i].fh_name, buffer, count)) {
> +		if (!strncmp(fld_hash[i].fh_name, name, count)) {

So right now the code is just accessing user memory directly?
Seriously?  Ugh.

Anyway, I don't like large stack variables like this, can you make it
dynamic instead?

thanks,

greg k-h
