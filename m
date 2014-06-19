Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbaFSP2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:28:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18779 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbaFSP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:28:02 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-a6-53a3017e4f95
Message-id: <53A30158.5000406@samsung.com>
Date: Thu, 19 Jun 2014 18:27:20 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org,
        eparis@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCHv2 1/1] ima: re-introduce own integrity cache lock
References: <285e8886d5672c43037fe9ee3012559211df6818.1400241799.git.d.kasatkin@samsung.com>
In-reply-to: <285e8886d5672c43037fe9ee3012559211df6818.1400241799.git.d.kasatkin@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xq7p1jIuDDT5NVbf4srTOYuL2NhaL
	desXM1m8nDGP3eLyrjlsFh96HrFZnP97nNXi04pJzA4cHjtn3WX3eHBoM4vH7gWfmTx6vid7
	vN93lc3j8yY5j01P3jIFsEdx2aSk5mSWpRbp2yVwZcw/u5K54KBDxbQPj9kaGPeYdDFyckgI
	mEg8W/KXFcIWk7hwbz1bFyMXh5DAUkaJ33d3MEM4jUwSaxtmsUA4sxgldixewAbSwiugJTGp
	6SkjiM0ioCoxv+MwWJxNQE9iQ/MP9i5GDg5RgQiJxxeEIMoFJX5Mvgc2RwRkTue2fiaQBLOA
	n8TkBWsZQeqFBVwl3q5NBQkLCcRJ7D+/CGwkp0C8xJSmTWwQ5ToS+1unQdnyEpvXvGWGqFeV
	6F67lg3iG0WJ05PPMU9gFJ6FZPUsJO2zkLQvYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7
	iRESSV93MC49ZnWIUYCDUYmHt+HagmAh1sSy4srcQ4wSHMxKIrwa/xcFC/GmJFZWpRblxxeV
	5qQWH2Jk4uCUamAU7bKrqOH6qql0W2ft/NrdBteFr5f55to5L73YX/Swy3nD/N+5LaKLlfZY
	m4b+qOW1i7CMiWSLCrj5X83lw7bMuQV+L+bsf/5ZMCxf5NyZTUIPzkm3nhfe2s/6a+92uV+M
	X9pEmOQ9nr0OaQ3O+CL9TLLbmvPTPIEXL8Snlz/ffK5+k3/nV1UlluKMREMt5qLiRAAPGz6n
	ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mimi,

If there is no objections, should we queue this patch for next release?

- Dmitry

On 16/05/14 15:03, Dmitry Kasatkin wrote:
> Before IMA appraisal was introduced, IMA was using own integrity cache
> lock along with i_mutex. process_measurement and ima_file_free took
> the iint->mutex first and then the i_mutex, while setxattr, chmod and
> chown took the locks in reverse order. To resolve the potential deadlock,
> i_mutex was moved to protect entire IMA functionality and the redundant
> iint->mutex was eliminated.
>
> Solution was based on the assumption that filesystem code does not take
> i_mutex further. But when file is opened with O_DIRECT flag, direct-io
> implementation takes i_mutex and produces deadlock. Furthermore, certain
> other filesystem operations, such as llseek, also take i_mutex.
>
> To resolve O_DIRECT related deadlock problem, this patch re-introduces
> iint->mutex. But to eliminate the original chmod() related deadlock
> problem, this patch eliminates the requirement for chmod hooks to take
> the iint->mutex by introducing additional atomic iint->attr_flags to
> indicate calling of the hooks. The allowed locking order is to take
> the iint->mutex first and then the i_mutex.
>
> Changes to v1:
> * revert taking the i_mutex in integrity_inode_get() so that iint allocation
>   could be done with i_mutex taken
> * move taking the i_mutex from appraisal code to the process_measurement()
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/iint.c             |  2 ++
>  security/integrity/ima/ima_appraise.c | 20 ++++++--------------
>  security/integrity/ima/ima_main.c     | 32 +++++++++++++++++++++-----------
>  security/integrity/integrity.h        |  5 +++++
>  4 files changed, 34 insertions(+), 25 deletions(-)
>
> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> index a521edf..d293207 100644
> --- a/security/integrity/iint.c
> +++ b/security/integrity/iint.c
> @@ -154,11 +154,13 @@ static void init_once(void *foo)
>  	memset(iint, 0, sizeof(*iint));
>  	iint->version = 0;
>  	iint->flags = 0UL;
> +	iint->attr_flags = 0;
>  	iint->ima_file_status = INTEGRITY_UNKNOWN;
>  	iint->ima_mmap_status = INTEGRITY_UNKNOWN;
>  	iint->ima_bprm_status = INTEGRITY_UNKNOWN;
>  	iint->ima_module_status = INTEGRITY_UNKNOWN;
>  	iint->evm_status = INTEGRITY_UNKNOWN;
> +	mutex_init(&iint->mutex);
>  }
>  
>  static int __init integrity_iintcache_init(void)
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index d3113d4..c49f8c3 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -289,7 +289,9 @@ void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
>  	if (rc < 0)
>  		return;
>  
> +	mutex_lock(&file_inode(file)->i_mutex);
>  	ima_fix_xattr(dentry, iint);
> +	mutex_unlock(&file_inode(file)->i_mutex);
>  }
>  
>  /**
> @@ -313,13 +315,8 @@ void ima_inode_post_setattr(struct dentry *dentry)
>  
>  	must_appraise = ima_must_appraise(inode, MAY_ACCESS, POST_SETATTR);
>  	iint = integrity_iint_find(inode);
> -	if (iint) {
> -		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
> -				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK |
> -				 IMA_ACTION_FLAGS);
> -		if (must_appraise)
> -			iint->flags |= IMA_APPRAISE;
> -	}
> +	if (iint)
> +		set_bit(IMA_CHANGE_ATTR, &iint->attr_flags);
>  	if (!must_appraise)
>  		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
>  	return;
> @@ -349,13 +346,8 @@ static void ima_reset_appraise_flags(struct inode *inode, int digsig)
>  		return;
>  
>  	iint = integrity_iint_find(inode);
> -	if (!iint)
> -		return;
> -
> -	iint->flags &= ~IMA_DONE_MASK;
> -	if (digsig)
> -		iint->flags |= IMA_DIGSIG;
> -	return;
> +	if (iint)
> +		set_bit(IMA_CHANGE_XATTR, &iint->attr_flags);
>  }
>  
>  int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index bd7b4cb..fdd5320 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -88,8 +88,6 @@ static void ima_rdwr_violation_check(struct file *file)
>  	if (!S_ISREG(inode->i_mode) || !ima_initialized)
>  		return;
>  
> -	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
> -
>  	if (mode & FMODE_WRITE) {
>  		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
>  			struct integrity_iint_cache *iint;
> @@ -104,8 +102,6 @@ static void ima_rdwr_violation_check(struct file *file)
>  			send_writers = true;
>  	}
>  
> -	mutex_unlock(&inode->i_mutex);
> -
>  	if (!send_tomtou && !send_writers)
>  		return;
>  
> @@ -127,14 +123,14 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
>  	if (!(mode & FMODE_WRITE))
>  		return;
>  
> -	mutex_lock(&inode->i_mutex);
> +	mutex_lock(&iint->mutex);
>  	if (atomic_read(&inode->i_writecount) == 1 &&
>  	    iint->version != inode->i_version) {
>  		iint->flags &= ~IMA_DONE_MASK;
>  		if (iint->flags & IMA_APPRAISE)
>  			ima_update_xattr(iint, file);
>  	}
> -	mutex_unlock(&inode->i_mutex);
> +	mutex_unlock(&iint->mutex);
>  }
>  
>  /**
> @@ -187,10 +183,21 @@ static int process_measurement(struct file *file, const char *filename,
>  	_func = (action & IMA_FILE_APPRAISE) ? FILE_CHECK : function;
>  
>  	mutex_lock(&inode->i_mutex);
> -
>  	iint = integrity_inode_get(inode);
> +	mutex_unlock(&inode->i_mutex);
>  	if (!iint)
> -		goto out;
> +		goto out_unlocked;
> +
> +	mutex_lock(&iint->mutex);
> +
> +	if (test_and_clear_bit(IMA_CHANGE_ATTR, &iint->attr_flags))
> +		/* reset appraisal flags if ima_inode_post_setattr was called */
> +		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
> +				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK);
> +
> +	if (test_and_clear_bit(IMA_CHANGE_XATTR, &iint->attr_flags))
> +		/* reset all flags if ima_inode_setxattr was called */
> +		iint->flags &= ~IMA_DONE_MASK;
>  
>  	/* Determine if already appraised/measured based on bitmask
>  	 * (IMA_MEASURE, IMA_MEASURED, IMA_XXXX_APPRAISE, IMA_XXXX_APPRAISED,
> @@ -225,18 +232,21 @@ static int process_measurement(struct file *file, const char *filename,
>  	if (action & IMA_MEASURE)
>  		ima_store_measurement(iint, file, pathname,
>  				      xattr_value, xattr_len);
> -	if (action & IMA_APPRAISE_SUBMASK)
> +	if (action & IMA_APPRAISE_SUBMASK) {
> +		mutex_lock(&inode->i_mutex);
>  		rc = ima_appraise_measurement(_func, iint, file, pathname,
>  					      xattr_value, xattr_len);
> +		mutex_unlock(&inode->i_mutex);
> +	}
>  	if (action & IMA_AUDIT)
>  		ima_audit_measurement(iint, pathname);
>  	kfree(pathbuf);
>  out_digsig:
>  	if ((mask & MAY_WRITE) && (iint->flags & IMA_DIGSIG))
>  		rc = -EACCES;
> -out:
> -	mutex_unlock(&inode->i_mutex);
> +	mutex_unlock(&iint->mutex);
>  	kfree(xattr_value);
> +out_unlocked:
>  	if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
>  		return -EACCES;
>  	return 0;
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 2fb5e53..f73cd06 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -50,6 +50,9 @@
>  #define IMA_APPRAISED_SUBMASK	(IMA_FILE_APPRAISED | IMA_MMAP_APPRAISED | \
>  				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED)
>  
> +#define IMA_CHANGE_XATTR	0
> +#define IMA_CHANGE_ATTR		1
> +
>  enum evm_ima_xattr_type {
>  	IMA_XATTR_DIGEST = 0x01,
>  	EVM_XATTR_HMAC,
> @@ -96,9 +99,11 @@ struct signature_v2_hdr {
>  /* integrity data associated with an inode */
>  struct integrity_iint_cache {
>  	struct rb_node rb_node;	/* rooted in integrity_iint_tree */
> +	struct mutex mutex;	/* protects: version, flags, digest */
>  	struct inode *inode;	/* back pointer to inode in question */
>  	u64 version;		/* track inode changes */
>  	unsigned long flags;
> +	unsigned long attr_flags;
>  	enum integrity_status ima_file_status:4;
>  	enum integrity_status ima_mmap_status:4;
>  	enum integrity_status ima_bprm_status:4;

