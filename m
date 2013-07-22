Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab3GVTZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:25:11 -0400
Received: from etezian.org ([198.101.225.253]:57539 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912Ab3GVTZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:25:08 -0400
Date: Mon, 22 Jul 2013 21:26:32 +0200
From: Andi Shyti <andi@etezian.org>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: file: initialize oparms.reconnect before using
 it
Message-ID: <20130722192632.GA4258@jack.whiskey>
References: <1374521040-5461-1-git-send-email-andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374521040-5461-1-git-send-email-andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 1/1, not 2/2... messed up with git.

Andi

On Mon, Jul 22, 2013 at 09:24:00PM +0200, Andi Shyti wrote:
> In the cifs_reopen_file function, if the following statement is
> asserted:
> 
> (tcon->unix_ext && cap_unix(tcon->ses) &&
> 		(CIFS_UNIX_POSIX_PATH_OPS_CAP &
> 		(tcon->fsUnixInfo.Capability)))
> 
> and we succeed to open with cifs_posix_open, the function jumps
> to the label reopen_success and checks for oparms.reconnect
> which is not initialized.
> 
> To avoid this the oparms structure initialization is anticipated
> before the if statement.
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  fs/cifs/file.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 1e57f36..fbeaf45 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -632,6 +632,15 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  	else
>  		oplock = 0;
>  
> +	oparms.tcon = tcon;
> +	oparms.cifs_sb = cifs_sb;
> +	oparms.desired_access = desired_access;
> +	oparms.create_options = create_options;
> +	oparms.disposition = disposition;
> +	oparms.path = full_path;
> +	oparms.fid = &cfile->fid;
> +	oparms.reconnect = true;
> +
>  	if (tcon->unix_ext && cap_unix(tcon->ses) &&
>  	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>  				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
> @@ -663,15 +672,6 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  	if (server->ops->get_lease_key)
>  		server->ops->get_lease_key(inode, &cfile->fid);
>  
> -	oparms.tcon = tcon;
> -	oparms.cifs_sb = cifs_sb;
> -	oparms.desired_access = desired_access;
> -	oparms.create_options = create_options;
> -	oparms.disposition = disposition;
> -	oparms.path = full_path;
> -	oparms.fid = &cfile->fid;
> -	oparms.reconnect = true;
> -
>  	/*
>  	 * Can not refresh inode by passing in file_info buf to be returned by
>  	 * CIFSSMBOpen and then calling get_inode_info with returned buf since
> -- 
> 1.8.3.2
