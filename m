Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab3DOIBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:01:07 -0400
Received: from ozlabs.org ([203.10.76.45]:37812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab3DOIBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:01:04 -0400
Date: Mon, 15 Apr 2013 18:01:02 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 5/8] Read rtas partition via pstore
Message-ID: <20130415080101.GF30156@concordia>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
 <20130410072327.20150.42189.stgit@aruna-ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410072327.20150.42189.stgit@aruna-ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:53:27PM +0530, Aruna Balakrishnaiah wrote:
> This patch exploits pstore infrastructure to read the details
> from NVRAM's rtas partition.

Does that mean it's exposed in the pstore filesystem?

> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/nvram.c |   33 +++++++++++++++++++++++++-------
>  fs/pstore/inode.c                      |    3 +++
>  include/linux/pstore.h                 |    2 ++
>  3 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
> index 82d32a2..d420b1d 100644
> --- a/arch/powerpc/platforms/pseries/nvram.c
> +++ b/arch/powerpc/platforms/pseries/nvram.c
> @@ -144,9 +144,11 @@ static size_t oops_data_sz;
>  #ifdef CONFIG_PSTORE
>  static enum pstore_type_id nvram_type_ids[] = {
>  	PSTORE_TYPE_DMESG,
> +	PSTORE_TYPE_RTAS,
>  	-1
>  };
>  static int read_type;
> +static unsigned long last_rtas_event;
>  #endif
>  /* Compression parameters */
>  #define COMPR_LEVEL 6
> @@ -315,8 +317,13 @@ int nvram_write_error_log(char * buff, int length,
>  {
>  	int rc = nvram_write_os_partition(&rtas_log_partition, buff, length,
>  						err_type, error_log_cnt);
> -	if (!rc)
> +	if (!rc) {
>  		last_unread_rtas_event = get_seconds();
> +#ifdef CONFIG_PSTORE
> +		last_rtas_event = get_seconds();
> +#endif
> +	}
> +
>  	return rc;
>  }
>  
> @@ -745,7 +752,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
>  }
>  
>  /*
> - * Reads the oops/panic report.
> + * Reads the oops/panic report and ibm,rtas-log partition.
>   * Returns the length of the data we read from each partition.
>   * Returns 0 if we've been called before.
>   */
> @@ -765,6 +772,12 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
>  		part = &oops_log_partition;
>  		*type = PSTORE_TYPE_DMESG;
>  		break;
> +	case PSTORE_TYPE_RTAS:
> +		part = &rtas_log_partition;
> +		*type = PSTORE_TYPE_RTAS;
> +		time->tv_sec = last_rtas_event;
> +		time->tv_nsec = 0;
> +		break;
>  	default:
>  		return 0;
>  	}
> @@ -781,11 +794,17 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
>  
>  	*count = 0;
>  	*id = id_no;
> -	oops_hdr = (struct oops_log_info *)buff;
> -	*buf = buff + sizeof(*oops_hdr);
> -	time->tv_sec = oops_hdr->timestamp;
> -	time->tv_nsec = 0;
> -	return oops_hdr->report_length;
> +
> +	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
> +		oops_hdr = (struct oops_log_info *)buff;
> +		*buf = buff + sizeof(*oops_hdr);
> +		time->tv_sec = oops_hdr->timestamp;
> +		time->tv_nsec = 0;
> +		return oops_hdr->report_length;
> +	}
> +
> +	*buf = buff;
> +	return part->size;
>  }
>  #else
>  static int nvram_pstore_open(struct pstore_info *psi)
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index e4bcb2c..59b1454 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -324,6 +324,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>  	case PSTORE_TYPE_MCE:
>  		sprintf(name, "mce-%s-%lld", psname, id);
>  		break;
> +	case PSTORE_TYPE_RTAS:
> +		sprintf(name, "rtas-%s-%lld", psname, id);
> +		break;
>  	case PSTORE_TYPE_UNKNOWN:
>  		sprintf(name, "unknown-%s-%lld", psname, id);
>  		break;
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index 75d0176..4eb94c9 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -35,6 +35,8 @@ enum pstore_type_id {
>  	PSTORE_TYPE_MCE		= 1,
>  	PSTORE_TYPE_CONSOLE	= 2,
>  	PSTORE_TYPE_FTRACE	= 3,
> +	/* PPC64 partition types */
> +	PSTORE_TYPE_RTAS	= 10,
>  	PSTORE_TYPE_UNKNOWN	= 255

I think you should probably just continue at 4, and call it
PSTORE_TYPE_PPC_RTAS. But you must get an ACK from the pstore
maintainers for this and the previous hunk, and I don't see them on CC.

cheers
