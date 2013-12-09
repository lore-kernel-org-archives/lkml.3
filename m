Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab3LILAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:00:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab3LILA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:00:27 -0500
Date: Mon, 9 Dec 2013 06:00:10 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tim Gardner <timg@tpi.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        Dean Gehnert <deang@tpi.com>
Subject: Re: [PATCH 3/5 linux-next V2] cifs: Introduce
 cifs_legacy_set_file_size()
Message-ID: <20131209060010.0af3b4ae@tlielax.poochiereds.net>
In-Reply-To: <1386536924-51726-3-git-send-email-timg@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
	<1386536924-51726-3-git-send-email-timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Dec 2013 14:08:42 -0700
Tim Gardner <timg@tpi.com> wrote:

> Consolidates some duplicate code.
> 
> Cc: Steve French <sfrench@samba.org>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Dean Gehnert <deang@tpi.com>
> Signed-off-by: Tim Gardner <timg@tpi.com>
> ---
> 
> V2 - this is a new patch in the V2 series.
> 
>  fs/cifs/inode.c |   54 +++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 7181516..3f710c6 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1899,6 +1899,30 @@ static void cifs_setsize(struct inode *inode, loff_t offset)
>  	truncate_pagecache(inode, offset);
>  }
>  
> +/*
> + * Legacy hack to set file length.
> + */
> +static int
> +cifs_legacy_set_file_size(unsigned int xid, __u16 netfid, __u32 pid,
> +			  unsigned int length, struct cifs_tcon *tcon,
> +			  char *full_path)
> +{
> +	int rc;
> +	unsigned int bytes_written;
> +	struct cifs_io_parms io_parms;
> +
> +	io_parms.netfid = netfid;
> +	io_parms.pid = pid;
> +	io_parms.tcon = tcon;
> +	io_parms.offset = 0;
> +	io_parms.length = length;
> +	rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
> +			  NULL, NULL, 1);
> +	cifs_dbg(FYI, "%s len %d rc %d on %s\n", __func__, length, rc,
> +		 full_path);
> +	return rc;
> +}
> +
>  static int
>  cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>  		   unsigned int xid, char *full_path)
> @@ -1910,7 +1934,6 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>  	struct tcon_link *tlink = NULL;
>  	struct cifs_tcon *tcon = NULL;
>  	struct TCP_Server_Info *server;
> -	struct cifs_io_parms io_parms;
>  
>  	/*
>  	 * To avoid spurious oplock breaks from server, in the case of
> @@ -1935,16 +1958,11 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>  		cifsFileInfo_put(open_file);
>  		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
>  		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
> -			unsigned int bytes_written;
> -
> -			io_parms.netfid = open_file->fid.netfid;
> -			io_parms.pid = open_file->pid;
> -			io_parms.tcon = tcon;
> -			io_parms.offset = 0;
> -			io_parms.length = attrs->ia_size;
> -			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
> -					  NULL, NULL, 1);
> -			cifs_dbg(FYI, "Wrt seteof rc %d\n", rc);
> +			rc = cifs_legacy_set_file_size(xid,
> +						       open_file->fid.netfid,
> +						       open_file->pid,
> +						       attrs->ia_size,
> +						       tcon, full_path);
>  		}
>  	} else
>  		rc = -EINVAL;
> @@ -1982,16 +2000,10 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>  				   cifs_sb->mnt_cifs_flags &
>  						CIFS_MOUNT_MAP_SPECIAL_CHR);
>  		if (rc == 0) {
> -			unsigned int bytes_written;
> -
> -			io_parms.netfid = netfid;
> -			io_parms.pid = current->tgid;
> -			io_parms.tcon = tcon;
> -			io_parms.offset = 0;
> -			io_parms.length = attrs->ia_size;
> -			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, NULL,
> -					  NULL,  1);
> -			cifs_dbg(FYI, "wrt seteof rc %d\n", rc);
> +			rc = cifs_legacy_set_file_size(xid, netfid,
> +						       current->tgid,
> +						       attrs->ia_size, tcon,
> +						       full_path);
>  			CIFSSMBClose(xid, tcon, netfid);
>  		}
>  	}

Reviewed-by: Jeff Layton <jlayton@redhat.com>
