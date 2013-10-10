Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab3JJAw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:52:26 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:51400 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3JJAwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:52:23 -0400
X-ASG-Debug-ID: 1381366342-03d6a50f5e1e1190001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Wed, 9 Oct 2013 20:52:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
CC: <chris.mason@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-br@googlegroups.com>
Subject: Re: [PATCH v3] btrfs: Fix memory leakage in the tree-log.c
Message-ID: <20131010005220.GI16461@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH v3] btrfs: Fix memory leakage in the tree-log.c
References: <1381362030-29595-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381362030-29595-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1381366342
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141335
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:40:30PM -0300, Geyslan G. Bem wrote:
> In some cases, add_inode_ref() is returning without freeing
> the 'name' pointer.
> 
> Added bail out to explicitly call kfree when necessary.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/btrfs/tree-log.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 79f057c..ad7cc5f 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1170,13 +1170,16 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  			if (!dir)
>  				dir = read_one_inode(root, parent_objectid);
>  			if (!dir)
> -				return -ENOENT;
> +			{
> +				ret = -ENOENT;
> +				goto bail;
> +			}

Code formatting is

if () {
}

not

if ()
{
}


>  		} else {
>  			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>  					     &ref_index);
>  		}
>  		if (ret)
> -			return ret;
> +			goto bail;
>  
>  		/* if we already have a perfect match, we're done */
>  		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
> @@ -1227,6 +1230,9 @@ out:
>  	btrfs_release_path(path);
>  	iput(dir);
>  	iput(inode);
> +bail:
> +	if (name)
> +		kfree(name);

kfree already does the if (name) part of this so this is redundant.  Also if you
are going to do this you need to set name = NULL; after the kfree above it
otherwise we have a double free.  Thanks,

Josef
