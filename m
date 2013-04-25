Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3DYOeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:34:19 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56620 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3DYOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:34:17 -0400
Message-ID: <51793ECE.2080506@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 20:03:50 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 22/28] ppc: Clean up rtas_flash driver somewhat [RFC]
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182716.27773.74530.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182716.27773.74530.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042514-8256-0000-0000-0000073800E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 11:57 PM, David Howells wrote:
> Clean up some of the problems with the rtas_flash driver:
>
>   (1) It shouldn't fiddle with the internals of the procfs filesystem (altering
>       pde->count).
>
>   (2) If pid namespaces are in effect, then you can get multiple inodes
>       connected to a single pde, thereby rendering the pde->count>  2 test
>       useless.
>
>   (3) The pde->count fudging doesn't work for forked, dup'd or cloned file
>       descriptors, so add static mutexes and use them to wrap access to the
>       driver through read, write and release methods.
>
>   (4) The driver can only handle one device, so allocate most of the data
>       previously attached to the pde->data as static variables instead (though
>       allocate the validation data buffer with kmalloc).
>
>   (5) We don't need to save the pde pointers as long as we have the filenames
>       available for removal.
>
>   (6) Don't try to multiplex what the update file read method does based on the
>       filename.  Instead provide separate file ops and split the function.
>
> Whilst we're at it, tabulate the procfile information and loop through it when
> creating or destroying them rather than manually coding each one.
>
> Signed-off-by: David Howells<dhowells@redhat.com>
> cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> cc: Paul Mackerras<paulus@samba.org>
> cc: Anton Blanchard<anton@samba.org>
> cc: linuxppc-dev@lists.ozlabs.org
> ---
>
>   arch/powerpc/kernel/rtas_flash.c |  446 +++++++++++++++++---------------------
>   1 file changed, 200 insertions(+), 246 deletions(-)
>
> diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
> index c642f01..8196bfb 100644
> --- a/arch/powerpc/kernel/rtas_flash.c
> +++ b/arch/powerpc/kernel/rtas_flash.c
> @@ -102,9 +102,10 @@ static struct kmem_cache *flash_block_cache = NULL;
>
>   #define FLASH_BLOCK_LIST_VERSION (1UL)
>
> -/* Local copy of the flash block list.
> - * We only allow one open of the flash proc file and create this
> - * list as we go.  The rtas_firmware_flash_list varable will be
> +/*
> + * Local copy of the flash block list.
> + *
> + * The rtas_firmware_flash_list varable will be

s/varable/variable/

>    * set once the data is fully read.
>    *
>    * For convenience as we build the list we use virtual addrs,
> @@ -125,23 +126,23 @@ struct rtas_update_flash_t
>   struct rtas_manage_flash_t
>   {
>   	int status;			/* Returned status */
> -	unsigned int op;		/* Reject or commit image */
>   };
>
>   /* Status int must be first member of struct */
>   struct rtas_validate_flash_t
>   {
>   	int status;		 	/* Returned status */	
> -	char buf[VALIDATE_BUF_SIZE]; 	/* Candidate image buffer */
> +	char *buf;			/* Candidate image buffer */
>   	unsigned int buf_size;		/* Size of image buf */
>   	unsigned int update_results;	/* Update results token */
>   };
>
> -static DEFINE_SPINLOCK(flash_file_open_lock);
> -static struct proc_dir_entry *firmware_flash_pde;
> -static struct proc_dir_entry *firmware_update_pde;
> -static struct proc_dir_entry *validate_pde;
> -static struct proc_dir_entry *manage_pde;
> +static struct rtas_update_flash_t rtas_update_flash_data;
> +static struct rtas_manage_flash_t rtas_manage_flash_data;
> +static struct rtas_validate_flash_t rtas_validate_flash_data;
> +static DEFINE_MUTEX(rtas_update_flash_mutex);
> +static DEFINE_MUTEX(rtas_manage_flash_mutex);
> +static DEFINE_MUTEX(rtas_validate_flash_mutex);
>
>   /* Do simple sanity checks on the flash image. */
>   static int flash_list_valid(struct flash_block_list *flist)
> @@ -191,10 +192,10 @@ static void free_flash_list(struct flash_block_list *f)
>
>   static int rtas_flash_release(struct inode *inode, struct file *file)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_update_flash_t *uf;
> -	
> -	uf = (struct rtas_update_flash_t *) dp->data;
> +	struct rtas_update_flash_t *const uf =&rtas_update_flash_data;
> +
> +	mutex_lock(&rtas_update_flash_mutex);
> +
>   	if (uf->flist) {
>   		/* File was opened in write mode for a new flash attempt */
>   		/* Clear saved list */
> @@ -214,13 +215,14 @@ static int rtas_flash_release(struct inode *inode, struct file *file)
>   		uf->flist = NULL;
>   	}
>
> -	atomic_dec(&dp->count);
> +	mutex_unlock(&rtas_update_flash_mutex);
>   	return 0;
>   }
>
> -static void get_flash_status_msg(int status, char *buf)
> +static size_t get_flash_status_msg(int status, char *buf)
>   {
> -	char *msg;
> +	const char *msg;
> +	size_t len;
>
>   	switch (status) {
>   	case FLASH_AUTH:
> @@ -242,34 +244,51 @@ static void get_flash_status_msg(int status, char *buf)
>   		msg = "ready: firmware image ready for flash on reboot\n";
>   		break;
>   	default:
> -		sprintf(buf, "error: unexpected status value %d\n", status);
> -		return;
> +		return sprintf(buf, "error: unexpected status value %d\n",
> +			       status);
>   	}
>
> -	strcpy(buf, msg);	
> +	len = strlen(msg);
> +	memcpy(buf, msg, len + 1);
> +	return len;
>   }
>
>   /* Reading the proc file will show status (not the firmware contents) */
> -static ssize_t rtas_flash_read(struct file *file, char __user *buf,
> -			       size_t count, loff_t *ppos)
> +static ssize_t rtas_flash_read_msg(struct file *file, char __user *buf,
> +				   size_t count, loff_t *ppos)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_update_flash_t *uf;
> +	struct rtas_update_flash_t *const uf =&rtas_update_flash_data;
>   	char msg[RTAS_MSG_MAXLEN];
> +	size_t len;
> +	int status;
>
> -	uf = dp->data;
> +	mutex_lock(&rtas_update_flash_mutex);
> +	status = uf->status;
> +	mutex_unlock(&rtas_update_flash_mutex);
>
> -	if (!strcmp(dp->name, FIRMWARE_FLASH_NAME)) {
> -		get_flash_status_msg(uf->status, msg);
> -	} else {	   /* FIRMWARE_UPDATE_NAME */
> -		sprintf(msg, "%d\n", uf->status);
> -	}
> +	/* Read as text message */
> +	len = get_flash_status_msg(uf->status, msg);

Above line should be
	len = get_flash_status_msg(status, msg);

> +	return simple_read_from_buffer(buf, count, ppos, msg, len);
> +}
> +
> +static ssize_t rtas_flash_read_num(struct file *file, char __user *buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct rtas_update_flash_t *const uf =&rtas_update_flash_data;
> +	char msg[RTAS_MSG_MAXLEN];
> +	int status;
>
> +	mutex_lock(&rtas_update_flash_mutex);
> +	status = uf->status;
> +	mutex_unlock(&rtas_update_flash_mutex);
> +
> +	/* Read as number */
> +	sprintf(msg, "%d\n", status);
>   	return simple_read_from_buffer(buf, count, ppos, msg, strlen(msg));
>   }
>
>   /* constructor for flash_block_cache */
> -void rtas_block_ctor(void *ptr)
> +static void rtas_block_ctor(void *ptr)
>   {
>   	memset(ptr, 0, RTAS_BLK_SIZE);
>   }
> @@ -282,16 +301,15 @@ void rtas_block_ctor(void *ptr)
>   static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
>   				size_t count, loff_t *off)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_update_flash_t *uf;
> +	struct rtas_update_flash_t *const uf =&rtas_update_flash_data;
>   	char *p;
> -	int next_free;
> +	int next_free, rc;
>   	struct flash_block_list *fl;
>
> -	uf = (struct rtas_update_flash_t *) dp->data;
> +	mutex_lock(&rtas_update_flash_mutex);
>
>   	if (uf->status == FLASH_AUTH || count == 0)
> -		return count;	/* discard data */
> +		goto out;	/* discard data */
>
>   	/* In the case that the image is not ready for flashing, the memory
>   	 * allocated for the block list will be freed upon the release of the
> @@ -300,7 +318,7 @@ static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
>   	if (uf->flist == NULL) {
>   		uf->flist = kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
>   		if (!uf->flist)
> -			return -ENOMEM;
> +			goto nomem;
>   	}
>
>   	fl = uf->flist;
> @@ -311,7 +329,7 @@ static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
>   		/* Need to allocate another block_list */
>   		fl->next = kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
>   		if (!fl->next)
> -			return -ENOMEM;
> +			goto nomem;
>   		fl = fl->next;
>   		next_free = 0;
>   	}
> @@ -320,52 +338,37 @@ static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
>   		count = RTAS_BLK_SIZE;
>   	p = kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
>   	if (!p)
> -		return -ENOMEM;
> +		goto nomem;
>   	
>   	if(copy_from_user(p, buffer, count)) {
>   		kmem_cache_free(flash_block_cache, p);
> -		return -EFAULT;
> +		rc = -EFAULT;
> +		goto error;
>   	}
>   	fl->blocks[next_free].data = p;
>   	fl->blocks[next_free].length = count;
>   	fl->num_blocks++;
> -
> +out:
> +	mutex_lock(&rtas_update_flash_mutex);

Above line should be "mutext_unlock(....)".


>   	return count;
> -}
> -
> -static int rtas_excl_open(struct inode *inode, struct file *file)
> -{
> -	struct proc_dir_entry *dp = PDE(inode);
> -
> -	/* Enforce exclusive open with use count of PDE */
> -	spin_lock(&flash_file_open_lock);
> -	if (atomic_read(&dp->count)>  2) {
> -		spin_unlock(&flash_file_open_lock);
> -		return -EBUSY;
> -	}
> -
> -	atomic_inc(&dp->count);
> -	spin_unlock(&flash_file_open_lock);
> -	
> -	return 0;
> -}
> -
> -static int rtas_excl_release(struct inode *inode, struct file *file)
> -{
> -	struct proc_dir_entry *dp = PDE(inode);
>
> -	atomic_dec(&dp->count);
> -
> -	return 0;
> +nomem:
> +	rc = -ENOMEM;
> +error:
> +	mutex_lock(&rtas_update_flash_mutex);

Again, above line should be "mutex_unlock".

> +	return rc;
>   }
>
> -static void manage_flash(struct rtas_manage_flash_t *args_buf)
> +/*
> + * Flash management routines.
> + */
> +static void manage_flash(struct rtas_manage_flash_t *args_buf, unsigned int op)
>   {
>   	s32 rc;
>
>   	do {
> -		rc = rtas_call(rtas_token("ibm,manage-flash-image"), 1,
> -			       1, NULL, args_buf->op);
> +		rc = rtas_call(rtas_token("ibm,manage-flash-image"), 1, 1,
> +			       NULL, op);
>   	} while (rtas_busy_delay(rc));
>
>   	args_buf->status = rc;
> @@ -374,40 +377,38 @@ static void manage_flash(struct rtas_manage_flash_t *args_buf)
>   static ssize_t manage_flash_read(struct file *file, char __user *buf,
>   			       size_t count, loff_t *ppos)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_manage_flash_t *args_buf;
> +	struct rtas_manage_flash_t *const args_buf =&rtas_manage_flash_data;
>   	char msg[RTAS_MSG_MAXLEN];
> -	int msglen;
> +	int msglen, status;
>
> -	args_buf = dp->data;
> -	if (args_buf == NULL)
> -		return 0;
> -
> -	msglen = sprintf(msg, "%d\n", args_buf->status);
> +	mutex_lock(&rtas_manage_flash_mutex);
> +	status = args_buf->status;
> +	mutex_unlock(&rtas_manage_flash_mutex);
>
> +	msglen = sprintf(msg, "%d\n", status);
>   	return simple_read_from_buffer(buf, count, ppos, msg, msglen);
>   }
>
>   static ssize_t manage_flash_write(struct file *file, const char __user *buf,
>   				size_t count, loff_t *off)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_manage_flash_t *args_buf;
> -	const char reject_str[] = "0";
> -	const char commit_str[] = "1";
> +	struct rtas_manage_flash_t *const args_buf =&rtas_manage_flash_data;
> +	static const char reject_str[] = "0";
> +	static const char commit_str[] = "1";
>   	char stkbuf[10];
> -	int op;
> +	int op, rc;
> +
> +	mutex_lock(&rtas_manage_flash_mutex);
>
> -	args_buf = (struct rtas_manage_flash_t *) dp->data;
>   	if ((args_buf->status == MANAGE_AUTH) || (count == 0))
> -		return count;
> +		goto out;
>   		
>   	op = -1;
>   	if (buf) {
>   		if (count>  9) count = 9;
> -		if (copy_from_user (stkbuf, buf, count)) {
> -			return -EFAULT;
> -		}
> +		rc = -EFAULT;
> +		if (copy_from_user (stkbuf, buf, count))
> +			goto error;
>   		if (strncmp(stkbuf, reject_str, strlen(reject_str)) == 0)
>   			op = RTAS_REJECT_TMP_IMG;
>   		else if (strncmp(stkbuf, commit_str, strlen(commit_str)) == 0)
> @@ -417,12 +418,19 @@ static ssize_t manage_flash_write(struct file *file, const char __user *buf,
>   	if (op == -1)   /* buf is empty, or contains invalid string */
>   		return -EINVAL;
>

We need to release mutex here.

+	if (op == -1) {   /* buf is empty, or contains invalid string */
+		rc = -EINVAL;
+		goto error;
+	}



> -	args_buf->op = op;
> -	manage_flash(args_buf);
> -
> +	manage_flash(args_buf, op);
> +out:
> +	mutex_unlock(&rtas_manage_flash_mutex);
>   	return count;
> +
> +error:
> +	mutex_unlock(&rtas_manage_flash_mutex);
> +	return rc;
>   }
>
> +/*
> + * Validation routines.
> + */
>   static void validate_flash(struct rtas_validate_flash_t *args_buf)
>   {
>   	int token = rtas_token("ibm,validate-flash-image");
> @@ -462,14 +470,14 @@ static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf,
>   static ssize_t validate_flash_read(struct file *file, char __user *buf,
>   			       size_t count, loff_t *ppos)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_validate_flash_t *args_buf;
> +	struct rtas_validate_flash_t *const args_buf =
> +		&rtas_validate_flash_data;
>   	char msg[RTAS_MSG_MAXLEN];
>   	int msglen;
>
> -	args_buf = dp->data;
> -
> +	mutex_lock(&rtas_validate_flash_mutex);
>   	msglen = get_validate_flash_msg(args_buf, msg);
> +	mutex_unlock(&rtas_validate_flash_mutex);
>
>   	return simple_read_from_buffer(buf, count, ppos, msg, msglen);
>   }
> @@ -477,24 +485,18 @@ static ssize_t validate_flash_read(struct file *file, char __user *buf,
>   static ssize_t validate_flash_write(struct file *file, const char __user *buf,
>   				    size_t count, loff_t *off)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_validate_flash_t *args_buf;
> +	struct rtas_validate_flash_t *const args_buf =
> +		&rtas_validate_flash_data;
>   	int rc;
>
> -	args_buf = (struct rtas_validate_flash_t *) dp->data;
> -
> -	if (dp->data == NULL) {
> -		dp->data = kmalloc(sizeof(struct rtas_validate_flash_t),
> -				GFP_KERNEL);
> -		if (dp->data == NULL)
> -			return -ENOMEM;
> -	}
> +	mutex_lock(&rtas_validate_flash_mutex);
>
>   	/* We are only interested in the first 4K of the
>   	 * candidate image */
>   	if ((*off>= VALIDATE_BUF_SIZE) ||
>   		(args_buf->status == VALIDATE_AUTH)) {
>   		*off += count;
> +		mutex_unlock(&rtas_validate_flash_mutex);
>   		return count;
>   	}
>
> @@ -517,31 +519,29 @@ static ssize_t validate_flash_write(struct file *file, const char __user *buf,
>   	*off += count;
>   	rc = count;
>   done:
> -	if (rc<  0) {
> -		kfree(dp->data);
> -		dp->data = NULL;
> -	}
> +	mutex_unlock(&rtas_validate_flash_mutex);
>   	return rc;
>   }
>
>   static int validate_flash_release(struct inode *inode, struct file *file)
>   {
> -	struct proc_dir_entry *dp = PDE(file_inode(file));
> -	struct rtas_validate_flash_t *args_buf;
> +	struct rtas_validate_flash_t *const args_buf =
> +		&rtas_validate_flash_data;
>
> -	args_buf = (struct rtas_validate_flash_t *) dp->data;
> +	mutex_lock(&rtas_validate_flash_mutex);
>
>   	if (args_buf->status == VALIDATE_READY) {
>   		args_buf->buf_size = VALIDATE_BUF_SIZE;
>   		validate_flash(args_buf);
>   	}
>
> -	/* The matching atomic_inc was in rtas_excl_open() */
> -	atomic_dec(&dp->count);
> -
> +	mutex_unlock(&rtas_validate_flash_mutex);
>   	return 0;
>   }
>
> +/*
> + * On-reboot flash update applicator.
> + */
>   static void rtas_flash_firmware(int reboot_type)
>   {
>   	unsigned long image_size;
> @@ -634,75 +634,57 @@ static void rtas_flash_firmware(int reboot_type)
>   	spin_unlock(&rtas_data_buf_lock);
>   }
>
> -static void remove_flash_pde(struct proc_dir_entry *dp)
> -{
> -	if (dp) {
> -		kfree(dp->data);
> -		remove_proc_entry(dp->name, dp->parent);
> -	}
> -}
> -
> -static int initialize_flash_pde_data(const char *rtas_call_name,
> -				     size_t buf_size,
> -				     struct proc_dir_entry *dp)
> -{
> +/*
> + * Manifest of proc files to create
> + */
> +struct rtas_flash_file {
> +	const char *filename;
> +	const char *rtas_call_name;
>   	int *status;
> -	int token;
> -
> -	dp->data = kzalloc(buf_size, GFP_KERNEL);
> -	if (dp->data == NULL)
> -		return -ENOMEM;
> -
> -	/*
> -	 * This code assumes that the status int is the first member of the
> -	 * struct
> -	 */
> -	status = (int *) dp->data;
> -	token = rtas_token(rtas_call_name);
> -	if (token == RTAS_UNKNOWN_SERVICE)
> -		*status = FLASH_AUTH;
> -	else
> -		*status = FLASH_NO_OP;
> -
> -	return 0;
> -}
> -
> -static struct proc_dir_entry *create_flash_pde(const char *filename,
> -					       const struct file_operations *fops)
> -{
> -	return proc_create(filename, S_IRUSR | S_IWUSR, NULL, fops);
> -}
> -
> -static const struct file_operations rtas_flash_operations = {
> -	.owner		= THIS_MODULE,
> -	.read		= rtas_flash_read,
> -	.write		= rtas_flash_write,
> -	.open		= rtas_excl_open,
> -	.release	= rtas_flash_release,
> -	.llseek		= default_llseek,
> +	const struct file_operations fops;
>   };
>
> -static const struct file_operations manage_flash_operations = {
> -	.owner		= THIS_MODULE,
> -	.read		= manage_flash_read,
> -	.write		= manage_flash_write,
> -	.open		= rtas_excl_open,
> -	.release	= rtas_excl_release,
> -	.llseek		= default_llseek,
> -};
> -
> -static const struct file_operations validate_flash_operations = {
> -	.owner		= THIS_MODULE,
> -	.read		= validate_flash_read,
> -	.write		= validate_flash_write,
> -	.open		= rtas_excl_open,
> -	.release	= validate_flash_release,
> -	.llseek		= default_llseek,
> +static const struct rtas_flash_file rtas_flash_files[] = {
> +	{
> +		.filename	= "powerpc/rtas/" FIRMWARE_FLASH_NAME,
> +		.rtas_call_name	= "ibm,update-flash-64-and-reboot",
> +		.status		=&rtas_update_flash_data.status,
> +		.fops.read	= rtas_flash_read_msg,
> +		.fops.write	= rtas_flash_write,
> +		.fops.release	= rtas_flash_release,
> +		.fops.llseek	= default_llseek,
> +	},
> +	{
> +		.filename	= "powerpc/rtas/" FIRMWARE_UPDATE_NAME,
> +		.rtas_call_name	= "ibm,update-flash-64-and-reboot",
> +		.status		=&rtas_update_flash_data.status,
> +		.fops.read	= rtas_flash_read_num,
> +		.fops.write	= rtas_flash_write,
> +		.fops.release	= rtas_flash_release,
> +		.fops.llseek	= default_llseek,
> +	},
> +	{
> +		.filename	= "powerpc/rtas/" VALIDATE_FLASH_NAME,
> +		.rtas_call_name	= "ibm,validate-flash-image",
> +		.status		=&rtas_validate_flash_data.status,
> +		.fops.read	= manage_flash_read,
> +		.fops.write	= manage_flash_write,


We have to validate FW here :-) Above two lines needs to be replaced like below.

+		.fops.read	= validate_flash_read,
+		.fops.write	= validate_flash_write,
+		.fops.release	= validate_flash_release,


> +		.fops.llseek	= default_llseek,
> +	},
> +	{
> +		.filename	= "powerpc/rtas/" MANAGE_FLASH_NAME,
> +		.rtas_call_name	= "ibm,manage-flash-image",
> +		.status		=&rtas_manage_flash_data.status,
> +		.fops.read	= validate_flash_read,
> +		.fops.write	= validate_flash_write,
> +		.fops.release	= validate_flash_release,

Here we need to manage FW :-) Above three lines needs to be replaced like below.
+		.fops.read	= manage_flash_read,
+		.fops.write	= manage_flash_write,


I wrote below patch on top of yours to test rtas_flash.

--- rtas_flash.c.org	2013-04-25 04:35:42.000000000 -0400
+++ rtas_flash.c	2013-04-25 05:53:35.000000000 -0400
@@ -267,7 +267,7 @@ static ssize_t rtas_flash_read_msg(struc
  	mutex_unlock(&rtas_update_flash_mutex);

  	/* Read as text message */
-	len = get_flash_status_msg(uf->status, msg);
+	len = get_flash_status_msg(status, msg);
  	return simple_read_from_buffer(buf, count, ppos, msg, len);
  }

@@ -349,13 +349,13 @@ static ssize_t rtas_flash_write(struct f
  	fl->blocks[next_free].length = count;
  	fl->num_blocks++;
  out:
-	mutex_lock(&rtas_update_flash_mutex);
+	mutex_unlock(&rtas_update_flash_mutex);
  	return count;

  nomem:
  	rc = -ENOMEM;
  error:
-	mutex_lock(&rtas_update_flash_mutex);
+	mutex_unlock(&rtas_update_flash_mutex);
  	return rc;
  }

@@ -415,8 +415,10 @@ static ssize_t manage_flash_write(struct
  			op = RTAS_COMMIT_TMP_IMG;
  	}
  	
-	if (op == -1)   /* buf is empty, or contains invalid string */
-		return -EINVAL;
+	if (op == -1) {   /* buf is empty, or contains invalid string */
+		rc = -EINVAL;
+		goto error;
+	}

  	manage_flash(args_buf, op);
  out:
@@ -668,17 +670,17 @@ static const struct rtas_flash_file rtas
  		.filename	= "powerpc/rtas/" VALIDATE_FLASH_NAME,
  		.rtas_call_name	= "ibm,validate-flash-image",
  		.status		= &rtas_validate_flash_data.status,
-		.fops.read	= manage_flash_read,
-		.fops.write	= manage_flash_write,
+		.fops.read	= validate_flash_read,
+		.fops.write	= validate_flash_write,
+		.fops.release	= validate_flash_release,
  		.fops.llseek	= default_llseek,
  	},
  	{
  		.filename	= "powerpc/rtas/" MANAGE_FLASH_NAME,
  		.rtas_call_name	= "ibm,manage-flash-image",
  		.status		= &rtas_manage_flash_data.status,
-		.fops.read	= validate_flash_read,
-		.fops.write	= validate_flash_write,
-		.fops.release	= validate_flash_release,
+		.fops.read	= manage_flash_read,
+		.fops.write	= manage_flash_write,
  		.fops.llseek	= default_llseek,
  	}
  };



-Vasant


> +		.fops.llseek	= default_llseek,
> +	}
>   };
>
>   static int __init rtas_flash_init(void)
>   {
> -	int rc;
> +	int i;
>
>   	if (rtas_token("ibm,update-flash-64-and-reboot") ==
>   		       RTAS_UNKNOWN_SERVICE) {
> @@ -710,93 +692,65 @@ static int __init rtas_flash_init(void)
>   		return 1;
>   	}
>
> -	firmware_flash_pde = create_flash_pde("powerpc/rtas/"
> -					      FIRMWARE_FLASH_NAME,
> -					&rtas_flash_operations);
> -	if (firmware_flash_pde == NULL) {
> -		rc = -ENOMEM;
> -		goto cleanup;
> -	}
> +	rtas_validate_flash_data.buf = kzalloc(VALIDATE_BUF_SIZE, GFP_KERNEL);
> +	if (!rtas_validate_flash_data.buf)
> +		return -ENOMEM;
>
> -	rc = initialize_flash_pde_data("ibm,update-flash-64-and-reboot",
> -			 	       sizeof(struct rtas_update_flash_t),
> -				       firmware_flash_pde);
> -	if (rc != 0)
> -		goto cleanup;
> -
> -	firmware_update_pde = create_flash_pde("powerpc/rtas/"
> -					       FIRMWARE_UPDATE_NAME,
> -					&rtas_flash_operations);
> -	if (firmware_update_pde == NULL) {
> -		rc = -ENOMEM;
> -		goto cleanup;
> +	flash_block_cache = kmem_cache_create("rtas_flash_cache",
> +					      RTAS_BLK_SIZE, RTAS_BLK_SIZE, 0,
> +					      rtas_block_ctor);
> +	if (!flash_block_cache) {
> +		printk(KERN_ERR "%s: failed to create block cache\n",
> +				__func__);
> +		goto enomem_buf;
>   	}
>
> -	rc = initialize_flash_pde_data("ibm,update-flash-64-and-reboot",
> -			 	       sizeof(struct rtas_update_flash_t),
> -				       firmware_update_pde);
> -	if (rc != 0)
> -		goto cleanup;
> -
> -	validate_pde = create_flash_pde("powerpc/rtas/" VALIDATE_FLASH_NAME,
> -			      		&validate_flash_operations);
> -	if (validate_pde == NULL) {
> -		rc = -ENOMEM;
> -		goto cleanup;
> -	}
> +	for (i = 0; i<  ARRAY_SIZE(rtas_flash_files); i++) {
> +		const struct rtas_flash_file *f =&rtas_flash_files[i];
> +		int token;
>
> -	rc = initialize_flash_pde_data("ibm,validate-flash-image",
> -		                       sizeof(struct rtas_validate_flash_t),
> -				       validate_pde);
> -	if (rc != 0)
> -		goto cleanup;
> -
> -	manage_pde = create_flash_pde("powerpc/rtas/" MANAGE_FLASH_NAME,
> -				&manage_flash_operations);
> -	if (manage_pde == NULL) {
> -		rc = -ENOMEM;
> -		goto cleanup;
> -	}
> +		if (!proc_create(f->filename, S_IRUSR | S_IWUSR, NULL,&f->fops))
> +			goto enomem;
>
> -	rc = initialize_flash_pde_data("ibm,manage-flash-image",
> -			               sizeof(struct rtas_manage_flash_t),
> -				       manage_pde);
> -	if (rc != 0)
> -		goto cleanup;
> +		/*
> +		 * This code assumes that the status int is the first member of the
> +		 * struct
> +		 */
> +		token = rtas_token(f->rtas_call_name);
> +		if (token == RTAS_UNKNOWN_SERVICE)
> +			*f->status = FLASH_AUTH;
> +		else
> +			*f->status = FLASH_NO_OP;
> +	}
>
>   	rtas_flash_term_hook = rtas_flash_firmware;
> -
> -	flash_block_cache = kmem_cache_create("rtas_flash_cache",
> -				RTAS_BLK_SIZE, RTAS_BLK_SIZE, 0,
> -				rtas_block_ctor);
> -	if (!flash_block_cache) {
> -		printk(KERN_ERR "%s: failed to create block cache\n",
> -				__func__);
> -		rc = -ENOMEM;
> -		goto cleanup;
> -	}
>   	return 0;
>
> -cleanup:
> -	remove_flash_pde(firmware_flash_pde);
> -	remove_flash_pde(firmware_update_pde);
> -	remove_flash_pde(validate_pde);
> -	remove_flash_pde(manage_pde);
> +enomem:
> +	while (--i>= 0) {
> +		const struct rtas_flash_file *f =&rtas_flash_files[i];
> +		remove_proc_entry(f->filename, NULL);
> +	}
>
> -	return rc;
> +	kmem_cache_destroy(flash_block_cache);
> +enomem_buf:
> +	kfree(rtas_validate_flash_data.buf);
> +	return -ENOMEM;
>   }
>
>   static void __exit rtas_flash_cleanup(void)
>   {
> +	int i;
> +
>   	rtas_flash_term_hook = NULL;
>
> -	if (flash_block_cache)
> -		kmem_cache_destroy(flash_block_cache);
> +	for (i = 0; i<  ARRAY_SIZE(rtas_flash_files); i++) {
> +		const struct rtas_flash_file *f =&rtas_flash_files[i];
> +		remove_proc_entry(f->filename, NULL);
> +	}
>
> -	remove_flash_pde(firmware_flash_pde);
> -	remove_flash_pde(firmware_update_pde);
> -	remove_flash_pde(validate_pde);
> -	remove_flash_pde(manage_pde);
> +	kmem_cache_destroy(flash_block_cache);
> +	kfree(rtas_validate_flash_data.buf);
>   }
>
>   module_init(rtas_flash_init);
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

