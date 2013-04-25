Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3DYPBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:01:52 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41505 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab3DYPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:01:50 -0400
Message-ID: <51794543.8060005@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 20:31:23 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, viro@zeniv.linux.org.uk,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 23/28] ppc: Clean up scanlog [RFC]
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182722.27773.32105.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182722.27773.32105.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042514-6102-0000-0000-000003626BA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 11:57 PM, David Howells wrote:
> Clean up the pseries scanlog driver's use of procfs:
>
>   (1) Don't need to save the proc_dir_entry pointer as we have the filename to
>       remove with.
>
>   (2) Save the scan log buffer pointer in a static variable (there is only one
>       of it) and don't save it in the PDE (which doesn't have a destructor).

Changes looks good.

-Vasant

>
> Signed-off-by: David Howells<dhowells@redhat.com>
> cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> cc: Paul Mackerras<paulus@samba.org>
> cc: linuxppc-dev@lists.ozlabs.org
> ---
>
>   arch/powerpc/platforms/pseries/scanlog.c |   29 +++++++++++------------------
>   1 file changed, 11 insertions(+), 18 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/scanlog.c b/arch/powerpc/platforms/pseries/scanlog.c
> index cc220d2..b502ab6 100644
> --- a/arch/powerpc/platforms/pseries/scanlog.c
> +++ b/arch/powerpc/platforms/pseries/scanlog.c
> @@ -41,12 +41,12 @@
>
>
>   static unsigned int ibm_scan_log_dump;			/* RTAS token */
> -static struct proc_dir_entry *proc_ppc64_scan_log_dump;	/* The proc file */
> +static unsigned int *scanlog_buffer;			/* The data buffer */
>
>   static ssize_t scanlog_read(struct file *file, char __user *buf,
>   			    size_t count, loff_t *ppos)
>   {
> -	unsigned int *data = PDE_DATA(file_inode(file));
> +	unsigned int *data = scanlog_buffer;
>   	int status;
>   	unsigned long len, off;
>   	unsigned int wait_time;
> @@ -134,7 +134,7 @@ static ssize_t scanlog_write(struct file * file, const char __user * buf,
>
>   static int scanlog_open(struct inode * inode, struct file * file)
>   {
> -	unsigned int *data = PDE_DATA(file_inode(file));
> +	unsigned int *data = scanlog_buffer;
>
>   	if (data[0] != 0) {
>   		/* This imperfect test stops a second copy of the
> @@ -150,10 +150,9 @@ static int scanlog_open(struct inode * inode, struct file * file)
>
>   static int scanlog_release(struct inode * inode, struct file * file)
>   {
> -	unsigned int *data = PDE_DATA(file_inode(file));
> +	unsigned int *data = scanlog_buffer;
>
>   	data[0] = 0;
> -
>   	return 0;
>   }
>
> @@ -169,7 +168,6 @@ const struct file_operations scanlog_fops = {
>   static int __init scanlog_init(void)
>   {
>   	struct proc_dir_entry *ent;
> -	void *data;
>   	int err = -ENOMEM;
>
>   	ibm_scan_log_dump = rtas_token("ibm,scan-log-dump");
> @@ -177,29 +175,24 @@ static int __init scanlog_init(void)
>   		return -ENODEV;
>
>   	/* Ideally we could allocate a buffer<  4G */
> -	data = kzalloc(RTAS_DATA_BUF_SIZE, GFP_KERNEL);
> -	if (!data)
> +	scanlog_buffer = kzalloc(RTAS_DATA_BUF_SIZE, GFP_KERNEL);
> +	if (!scanlog_buffer)
>   		goto err;
>
> -	ent = proc_create_data("powerpc/rtas/scan-log-dump", S_IRUSR, NULL,
> -			&scanlog_fops, data);
> +	ent = proc_create("powerpc/rtas/scan-log-dump", S_IRUSR, NULL,
> +			&scanlog_fops);
>   	if (!ent)
>   		goto err;
> -
> -	proc_ppc64_scan_log_dump = ent;
> -
>   	return 0;
>   err:
> -	kfree(data);
> +	kfree(scanlog_buffer);
>   	return err;
>   }
>
>   static void __exit scanlog_cleanup(void)
>   {
> -	if (proc_ppc64_scan_log_dump) {
> -		kfree(proc_ppc64_scan_log_dump->data);
> -		remove_proc_entry("scan-log-dump", proc_ppc64_scan_log_dump->parent);
> -	}
> +	remove_proc_entry("powerpc/rtas/scan-log-dump", NULL);
> +	kfree(scanlog_buffer);
>   }
>
>   module_init(scanlog_init);
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

