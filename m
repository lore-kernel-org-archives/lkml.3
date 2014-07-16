Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaGPLha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:37:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53550 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbaGPLh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:37:27 -0400
Message-ID: <1405510640.1466.16.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v1 3/3] ima: pass 'opened' flag to identify newly
 created files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 16 Jul 2014 07:37:20 -0400
In-Reply-To: <53C636FC.6050206@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
	 <c24beb8d1cc2cc0c4986f430eb0c84fe28470f66.1405078844.git.d.kasatkin@samsung.com>
	 <1405462367.2124.13.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53C636FC.6050206@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071611-0928-0000-0000-0000036F44D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 11:25 +0300, Dmitry Kasatkin wrote: 
> On 16/07/14 01:12, Mimi Zohar wrote:
> > On Fri, 2014-07-11 at 14:47 +0300, Dmitry Kasatkin wrote: 
> >> Empty file size and missing xattrs do not guaranty that file
> > ^guarantee
> >
> >> was just created. It could be originally made empty and labeled
> >> with needed LSM labels. Current implementation makes it possible
> >> to remove security.ima, and set arbitrary LSM related attribute.
> >> On open, IMA would be forced to update security.evm to 'fake' LSM
> >> xattrs.
> > Only in 'fix' mode, is the security.ima value written out on file
> > open.  The previous patch introduced the ability to set "arbitrary LSM
> > related attributes" without a security.evm label.
> 
> Comment is a bit unclear to me...
> 
> Previous patch does not allow to set arbitrary LSM value,
> but if runtime permission allows, it allows to set "initial" xattrs for
> newly created files...
> 
> I think description I made is a bit unclear..
> 
> What I wanted to tell is that..
> 
> "Assuming that empty file is a newly created file, IMA skips EVM
> verification which allows "offline" removing security.ima and set
> arbitrary security xattrs. Updating and closing file will make EVM to
> update security.evm with forged secirity xattrs.

Sure the security IMA and EVM xattrs can be removed offline, but can not
be replaced one without the other.  The file size indicates  a "new"
file, only if there aren't any existing xattrs.  The question is whether
just removing an xattr provides a benefit.

> The question is if making file empty on purpose, clearing security.ima
> and changing xattrs will allow any attack as file is empty.
> If so, then using FILE_CREATED flag is safe choice.
> 
> - Dmitry

Can we say, "Clearly identifying new files further limits possible
attacks."

Mimi

> 
> > The patch itself is fine.  Please update the patch description.
> >
> > thanks,
> >
> > Mimi
> >
> >> This patch passes FILE_CREATED flag to IMA to reliably identify new
> >> files.
> >>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >> ---
> >>  fs/namei.c                            |  2 +-
> >>  fs/nfsd/vfs.c                         |  2 +-
> >>  include/linux/ima.h                   |  4 ++--
> >>  security/integrity/ima/ima.h          |  4 ++--
> >>  security/integrity/ima/ima_appraise.c |  4 ++--
> >>  security/integrity/ima/ima_main.c     | 14 +++++++-------
> >>  6 files changed, 15 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/fs/namei.c b/fs/namei.c
> >> index 985c6f3..005771f 100644
> >> --- a/fs/namei.c
> >> +++ b/fs/namei.c
> >> @@ -3058,7 +3058,7 @@ opened:
> >>  	error = open_check_o_direct(file);
> >>  	if (error)
> >>  		goto exit_fput;
> >> -	error = ima_file_check(file, op->acc_mode);
> >> +	error = ima_file_check(file, op->acc_mode, *opened);
> >>  	if (error)
> >>  		goto exit_fput;
> >>
> >> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> >> index 140c496..d49c778 100644
> >> --- a/fs/nfsd/vfs.c
> >> +++ b/fs/nfsd/vfs.c
> >> @@ -709,7 +709,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
> >>  		host_err = PTR_ERR(*filp);
> >>  		*filp = NULL;
> >>  	} else {
> >> -		host_err = ima_file_check(*filp, may_flags);
> >> +		host_err = ima_file_check(*filp, may_flags, 0);
> >>
> >>  		if (may_flags & NFSD_MAY_64BIT_COOKIE)
> >>  			(*filp)->f_mode |= FMODE_64BITHASH;
> >> diff --git a/include/linux/ima.h b/include/linux/ima.h
> >> index 1b7f268..23a87a4 100644
> >> --- a/include/linux/ima.h
> >> +++ b/include/linux/ima.h
> >> @@ -15,7 +15,7 @@ struct linux_binprm;
> >>
> >>  #ifdef CONFIG_IMA
> >>  extern int ima_bprm_check(struct linux_binprm *bprm);
> >> -extern int ima_file_check(struct file *file, int mask);
> >> +extern int ima_file_check(struct file *file, int mask, int opened);
> >>  extern void ima_file_free(struct file *file);
> >>  extern int ima_file_mmap(struct file *file, unsigned long prot);
> >>  extern int ima_module_check(struct file *file);
> >> @@ -26,7 +26,7 @@ static inline int ima_bprm_check(struct linux_binprm *bprm)
> >>  	return 0;
> >>  }
> >>
> >> -static inline int ima_file_check(struct file *file, int mask)
> >> +static inline int ima_file_check(struct file *file, int mask, int opened)
> >>  {
> >>  	return 0;
> >>  }
> >> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> >> index 3e9be3d..9337aa9 100644
> >> --- a/security/integrity/ima/ima.h
> >> +++ b/security/integrity/ima/ima.h
> >> @@ -175,7 +175,7 @@ void ima_delete_rules(void);
> >>  int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> >>  			     struct file *file, const unsigned char *filename,
> >>  			     struct evm_ima_xattr_data *xattr_value,
> >> -			     int xattr_len);
> >> +			     int xattr_len, int opened);
> >>  int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
> >>  void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
> >>  enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
> >> @@ -191,7 +191,7 @@ static inline int ima_appraise_measurement(int func,
> >>  					   struct file *file,
> >>  					   const unsigned char *filename,
> >>  					   struct evm_ima_xattr_data *xattr_value,
> >> -					   int xattr_len)
> >> +					   int xattr_len, int opened)
> >>  {
> >>  	return INTEGRITY_UNKNOWN;
> >>  }
> >> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> >> index 3a4beb3..10679c8 100644
> >> --- a/security/integrity/ima/ima_appraise.c
> >> +++ b/security/integrity/ima/ima_appraise.c
> >> @@ -175,7 +175,7 @@ int ima_read_xattr(struct dentry *dentry,
> >>  int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> >>  			     struct file *file, const unsigned char *filename,
> >>  			     struct evm_ima_xattr_data *xattr_value,
> >> -			     int xattr_len)
> >> +			     int xattr_len, int opened)
> >>  {
> >>  	static const char op[] = "appraise_data";
> >>  	char *cause = "unknown";
> >> @@ -195,7 +195,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> >>
> >>  		cause = "missing-hash";
> >>  		status = INTEGRITY_NOLABEL;
> >> -		if (inode->i_size == 0) {
> >> +		if (opened & FILE_CREATED) {
> >>  			iint->flags |= IMA_NEW_FILE;
> >>  			status = INTEGRITY_PASS;
> >>  		}
> >> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> >> index 5a870e7..3384036 100644
> >> --- a/security/integrity/ima/ima_main.c
> >> +++ b/security/integrity/ima/ima_main.c
> >> @@ -157,7 +157,7 @@ void ima_file_free(struct file *file)
> >>  }
> >>
> >>  static int process_measurement(struct file *file, const char *filename,
> >> -			       int mask, int function)
> >> +			       int mask, int function, int opened)
> >>  {
> >>  	struct inode *inode = file_inode(file);
> >>  	struct integrity_iint_cache *iint;
> >> @@ -238,7 +238,7 @@ static int process_measurement(struct file *file, const char *filename,
> >>  	if (action & IMA_APPRAISE_SUBMASK) {
> >>  		mutex_lock(&inode->i_mutex);
> >>  		rc = ima_appraise_measurement(_func, iint, file, pathname,
> >> -					      xattr_value, xattr_len);
> >> +					      xattr_value, xattr_len, opened);
> >>  		mutex_unlock(&inode->i_mutex);
> >>  	}
> >>  	if (action & IMA_AUDIT)
> >> @@ -269,7 +269,7 @@ out_unlocked:
> >>  int ima_file_mmap(struct file *file, unsigned long prot)
> >>  {
> >>  	if (file && (prot & PROT_EXEC))
> >> -		return process_measurement(file, NULL, MAY_EXEC, MMAP_CHECK);
> >> +		return process_measurement(file, NULL, MAY_EXEC, MMAP_CHECK, 0);
> >>  	return 0;
> >>  }
> >>
> >> @@ -291,7 +291,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
> >>  	return process_measurement(bprm->file,
> >>  				   (strcmp(bprm->filename, bprm->interp) == 0) ?
> >>  				   bprm->filename : bprm->interp,
> >> -				   MAY_EXEC, BPRM_CHECK);
> >> +				   MAY_EXEC, BPRM_CHECK, 0);
> >>  }
> >>
> >>  /**
> >> @@ -304,12 +304,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
> >>   * On success return 0.  On integrity appraisal error, assuming the file
> >>   * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
> >>   */
> >> -int ima_file_check(struct file *file, int mask)
> >> +int ima_file_check(struct file *file, int mask, int opened)
> >>  {
> >>  	ima_rdwr_violation_check(file);
> >>  	return process_measurement(file, NULL,
> >>  				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
> >> -				   FILE_CHECK);
> >> +				   FILE_CHECK, opened);
> >>  }
> >>  EXPORT_SYMBOL_GPL(ima_file_check);
> >>
> >> @@ -332,7 +332,7 @@ int ima_module_check(struct file *file)
> >>  #endif
> >>  		return 0;	/* We rely on module signature checking */
> >>  	}
> >> -	return process_measurement(file, NULL, MAY_EXEC, MODULE_CHECK);
> >> +	return process_measurement(file, NULL, MAY_EXEC, MODULE_CHECK, 0);
> >>  }
> >>
> >>  static int __init init_ima(void)
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


