Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3GRE3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 00:29:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36813 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3GRE3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 00:29:07 -0400
X-Spam-Score: -100.8
Message-ID: <51E76ED7.303@asianux.com>
Date: Thu, 18 Jul 2013 12:28:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: check/extend buffer length for printing functions
References: <51E65A68.8070009@asianux.com>
In-Reply-To: <51E65A68.8070009@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have given a simple test for it.

for current REISERFS_MAX_ERROR_BUF (error_buffer[4096]), it will report
the full message warnings.

[root@dhcp122 ~]# mount /dev/sda11 /mnt/sda11
[root@dhcp122 ~]# dmesg | grep reiser
[  423.421532] REISERFS warning (device sda11):  reiserfs_fill_super: CONFIG_REISERFS_CHECK is set ON
[  423.421537] REISERFS warning (device sda11):  reiserfs_fill_super: - it is slow mode for debugging.


decreasing REISERFS_MAX_ERROR_BUF to 11 (error_buffer[11]), it will
report the truncated message warnings (the tail 10 chars)

[root@dhcp122 ~]# mount /dev/sda11 /mnt/sda11
[root@dhcp122 ~]# dmesg | grep reiser
[   44.236875] REISERFS warning (device sda11):  reiserfs_fill_super: CONFIG_REI
[   44.236882] REISERFS warning (device sda11):  reiserfs_fill_super: - it is sl


If request the additional test, please let me know, I should perform
(better to provide the related test plan)

Thanks.

On 07/17/2013 04:48 PM, Chen Gang wrote:
> If format string and/or error string are larger than 1024, it will
> cause memory overflow.
> 
> So need check the format string buffer length before process it.
> 
> Also need use (v)snprintf() instread of (v)sprintf() for error buffer
> to be sure of maximize length limitation.
> 
> Normally, the error buffer length need be much larger than format
> buffer length, so extend the error buffer length to 4096.
> 
> When adding new code, also need let them within 80 column.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  fs/reiserfs/prints.c |   90 ++++++++++++++++++++++++++++++-------------------
>  1 files changed, 55 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
> index c0b1112..6b7581e 100644
> --- a/fs/reiserfs/prints.c
> +++ b/fs/reiserfs/prints.c
> @@ -10,8 +10,13 @@
>  
>  #include <stdarg.h>
>  
> -static char error_buf[1024];
> -static char fmt_buf[1024];
> +#define REISERFS_MAX_FMT_BUF		1024
> +#define REISERFS_MAX_ERROR_BUF		4096
> +#define REISERFS_ERR_BUF_LEFT(pos, base)	\
> +				(REISERFS_MAX_ERROR_BUF - ((pos) - (base)))
> +
> +static char error_buf[REISERFS_MAX_FMT_BUF];
> +static char fmt_buf[REISERFS_MAX_ERROR_BUF];
>  static char off_buf[80];
>  
>  static char *reiserfs_cpu_offset(struct cpu_key *key)
> @@ -76,72 +81,74 @@ static char *le_type(struct reiserfs_key *key)
>  }
>  
>  /* %k */
> -static void sprintf_le_key(char *buf, struct reiserfs_key *key)
> +static void sprintf_le_key(char *buf, int left, struct reiserfs_key *key)
>  {
>  	if (key)
> -		sprintf(buf, "[%d %d %s %s]", le32_to_cpu(key->k_dir_id),
> +		snprintf(buf, left, "[%d %d %s %s]", le32_to_cpu(key->k_dir_id),
>  			le32_to_cpu(key->k_objectid), le_offset(key),
>  			le_type(key));
>  	else
> -		sprintf(buf, "[NULL]");
> +		snprintf(buf, left, "[NULL]");
>  }
>  
>  /* %K */
> -static void sprintf_cpu_key(char *buf, struct cpu_key *key)
> +static void sprintf_cpu_key(char *buf, int left, struct cpu_key *key)
>  {
>  	if (key)
> -		sprintf(buf, "[%d %d %s %s]", key->on_disk_key.k_dir_id,
> +		snprintf(buf, left, "[%d %d %s %s]", key->on_disk_key.k_dir_id,
>  			key->on_disk_key.k_objectid, reiserfs_cpu_offset(key),
>  			cpu_type(key));
>  	else
> -		sprintf(buf, "[NULL]");
> +		snprintf(buf, left, "[NULL]");
>  }
>  
> -static void sprintf_de_head(char *buf, struct reiserfs_de_head *deh)
> +static void sprintf_de_head(char *buf, int left, struct reiserfs_de_head *deh)
>  {
>  	if (deh)
> -		sprintf(buf,
> +		snprintf(buf, left,
>  			"[offset=%d dir_id=%d objectid=%d location=%d state=%04x]",
>  			deh_offset(deh), deh_dir_id(deh), deh_objectid(deh),
>  			deh_location(deh), deh_state(deh));
>  	else
> -		sprintf(buf, "[NULL]");
> +		snprintf(buf, left, "[NULL]");
>  
>  }
>  
> -static void sprintf_item_head(char *buf, struct item_head *ih)
> +static void sprintf_item_head(char *buf, int left, struct item_head *ih)
>  {
>  	if (ih) {
> -		strcpy(buf,
> +		snprintf(buf, left, "%s",
>  		       (ih_version(ih) == KEY_FORMAT_3_6) ? "*3.6* " : "*3.5*");
> -		sprintf_le_key(buf + strlen(buf), &(ih->ih_key));
> -		sprintf(buf + strlen(buf), ", item_len %d, item_location %d, "
> -			"free_space(entry_count) %d",
> +		sprintf_le_key(buf + strlen(buf), left - strlen(buf),
> +			       &(ih->ih_key));
> +		snprintf(buf + strlen(buf), left - strlen(buf),
> +			 ", item_len %d, item_location %d, free_space(entry_count) %d",
>  			ih_item_len(ih), ih_location(ih), ih_free_space(ih));
>  	} else
> -		sprintf(buf, "[NULL]");
> +		snprintf(buf, left, "[NULL]");
>  }
>  
> -static void sprintf_direntry(char *buf, struct reiserfs_dir_entry *de)
> +static void sprintf_direntry(char *buf, int left, struct reiserfs_dir_entry *de)
>  {
>  	char name[20];
>  
>  	memcpy(name, de->de_name, de->de_namelen > 19 ? 19 : de->de_namelen);
>  	name[de->de_namelen > 19 ? 19 : de->de_namelen] = 0;
> -	sprintf(buf, "\"%s\"==>[%d %d]", name, de->de_dir_id, de->de_objectid);
> +	snprintf(buf, left, "\"%s\"==>[%d %d]",
> +		 name, de->de_dir_id, de->de_objectid);
>  }
>  
> -static void sprintf_block_head(char *buf, struct buffer_head *bh)
> +static void sprintf_block_head(char *buf, int left, struct buffer_head *bh)
>  {
> -	sprintf(buf, "level=%d, nr_items=%d, free_space=%d rdkey ",
> +	snprintf(buf, left, "level=%d, nr_items=%d, free_space=%d rdkey ",
>  		B_LEVEL(bh), B_NR_ITEMS(bh), B_FREE_SPACE(bh));
>  }
>  
> -static void sprintf_buffer_head(char *buf, struct buffer_head *bh)
> +static void sprintf_buffer_head(char *buf, int left, struct buffer_head *bh)
>  {
>  	char b[BDEVNAME_SIZE];
>  
> -	sprintf(buf,
> +	snprintf(buf, left,
>  		"dev %s, size %zd, blocknr %llu, count %d, state 0x%lx, page %p, (%s, %s, %s)",
>  		bdevname(bh->b_bdev, b), bh->b_size,
>  		(unsigned long long)bh->b_blocknr, atomic_read(&(bh->b_count)),
> @@ -151,9 +158,9 @@ static void sprintf_buffer_head(char *buf, struct buffer_head *bh)
>  		buffer_locked(bh) ? "LOCKED" : "UNLOCKED");
>  }
>  
> -static void sprintf_disk_child(char *buf, struct disk_child *dc)
> +static void sprintf_disk_child(char *buf, int left, struct disk_child *dc)
>  {
> -	sprintf(buf, "[dc_number=%d, dc_size=%u]", dc_block_number(dc),
> +	snprintf(buf, left, "[dc_number=%d, dc_size=%u]", dc_block_number(dc),
>  		dc_size(dc));
>  }
>  
> @@ -190,8 +197,16 @@ static void prepare_error_buf(const char *fmt, va_list args)
>  	char *fmt1 = fmt_buf;
>  	char *k;
>  	char *p = error_buf;
> +	int left = REISERFS_ERR_BUF_LEFT(p, error_buf);
>  	int what;
>  
> +	if (strlen(fmt) >= REISERFS_MAX_FMT_BUF) {
> +		printk(KERN_CRIT
> +			"REISERFS error (format buffer too long, more than %d): %s\n",
> +			REISERFS_MAX_FMT_BUF, fmt);
> +		return;
> +	}
> +
>  	spin_lock(&error_lock);
>  
>  	strcpy(fmt1, fmt);
> @@ -199,46 +214,51 @@ static void prepare_error_buf(const char *fmt, va_list args)
>  	while ((k = is_there_reiserfs_struct(fmt1, &what)) != NULL) {
>  		*k = 0;
>  
> -		p += vsprintf(p, fmt1, args);
> +		p += vsnprintf(p, left, fmt1, args);
> +		left = REISERFS_ERR_BUF_LEFT(p, error_buf);
>  
>  		switch (what) {
>  		case 'k':
> -			sprintf_le_key(p, va_arg(args, struct reiserfs_key *));
> +			sprintf_le_key(p, left,
> +				       va_arg(args, struct reiserfs_key *));
>  			break;
>  		case 'K':
> -			sprintf_cpu_key(p, va_arg(args, struct cpu_key *));
> +			sprintf_cpu_key(p, left,
> +					va_arg(args, struct cpu_key *));
>  			break;
>  		case 'h':
> -			sprintf_item_head(p, va_arg(args, struct item_head *));
> +			sprintf_item_head(p, left,
> +					  va_arg(args, struct item_head *));
>  			break;
>  		case 't':
> -			sprintf_direntry(p,
> +			sprintf_direntry(p, left,
>  					 va_arg(args,
>  						struct reiserfs_dir_entry *));
>  			break;
>  		case 'y':
> -			sprintf_disk_child(p,
> +			sprintf_disk_child(p, left,
>  					   va_arg(args, struct disk_child *));
>  			break;
>  		case 'z':
> -			sprintf_block_head(p,
> +			sprintf_block_head(p, left,
>  					   va_arg(args, struct buffer_head *));
>  			break;
>  		case 'b':
> -			sprintf_buffer_head(p,
> +			sprintf_buffer_head(p, left,
>  					    va_arg(args, struct buffer_head *));
>  			break;
>  		case 'a':
> -			sprintf_de_head(p,
> +			sprintf_de_head(p, left,
>  					va_arg(args,
>  					       struct reiserfs_de_head *));
>  			break;
>  		}
>  
>  		p += strlen(p);
> +		left = REISERFS_ERR_BUF_LEFT(p, error_buf);
>  		fmt1 = k + 2;
>  	}
> -	vsprintf(p, fmt1, args);
> +	vsnprintf(p, left, fmt1, args);
>  	spin_unlock(&error_lock);
>  
>  }
> 


-- 
Chen Gang
