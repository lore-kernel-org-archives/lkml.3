Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaENRVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:21:15 -0400
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:55835 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbaENRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:21:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3873:4321:5007:7558:7652:7903:8603:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fold36_a2e6de9be949
X-Filterd-Recvd-Size: 3184
Message-ID: <1400088068.30384.5.camel@joe-AO725>
Subject: Re: [PATCH 3/3] FS/EFS: convert printk(KERN_DEBUG to pr_debug
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Wed, 14 May 2014 10:21:08 -0700
In-Reply-To: <20140514191531.3dddab6232af1d0b53e25b90@skynet.be>
References: <20140514191531.3dddab6232af1d0b53e25b90@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 19:15 +0200, Fabian Frederick wrote:
> All KERN_DEBUG callsites being under #ifdef DEBUG
> we can safely convert everything to pr_debug without changing
> current behaviour.

You could also remove most of the #ifdef DEBUG/#endif blocks

> diff --git a/fs/efs/dir.c b/fs/efs/dir.c
[]
> @@ -73,7 +73,9 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
>  			nameptr  = dirslot->name;
>  
>  #ifdef DEBUG
> -			printk(KERN_DEBUG "EFS: readdir(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n", block, slot, dirblock->slots-1, inodenum, nameptr, namelen);
> +			pr_debug("%s(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n",
> +				 __func__, block, slot, dirblock->slots-1,
> +				 inodenum, nameptr, namelen);
>  #endif

Like this one

> diff --git a/fs/efs/inode.c b/fs/efs/inode.c
[]
> @@ -140,8 +140,8 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
>  	brelse(bh);
>     
>  #ifdef DEBUG
> -	printk(KERN_DEBUG "EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
> -		inode->i_ino, in->numextents, inode->i_mode);
> +	pr_debug("efs_iget(): inode %lu, extents %d, mode %o\n",
> +		 inode->i_ino, in->numextents, inode->i_mode);
>  #endif

and this, etc...

> diff --git a/fs/efs/super.c b/fs/efs/super.c
[]
> @@ -184,7 +184,7 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
>  	}
>  
>  #ifdef DEBUG
> -	printk(KERN_DEBUG "EFS: bf: \"%16s\"\n", vh->vh_bootfile);
> +	pr_debug("bf: \"%16s\"\n", vh->vh_bootfile);
>  
>  	for(i = 0; i < NVDIR; i++) {
>  		int	j;

but not this.

> @@ -211,12 +211,11 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
>  		}
>  #ifdef DEBUG
>  		if (be32_to_cpu(vh->vh_pt[i].pt_nblks)) {
> -			printk(KERN_DEBUG "EFS: pt %2d: start: %08d size: %08d type: 0x%02x (%s)\n",
> -				i,
> -				(int) be32_to_cpu(vh->vh_pt[i].pt_firstlbn),
> -				(int) be32_to_cpu(vh->vh_pt[i].pt_nblks),
> -				pt_type,
> -				(pt_entry->pt_name) ? pt_entry->pt_name : "unknown");
> +			pr_debug("pt %2d: start: %08d size: %08d type: 0x%02x (%s)\n",
> +				 i, (int)be32_to_cpu(vh->vh_pt[i].pt_firstlbn),
> +				 (int)be32_to_cpu(vh->vh_pt[i].pt_nblks),
> +				 pt_type, (pt_entry->pt_name) ?
> +				 pt_entry->pt_name : "unknown");
>  		}
>  #endif

or this


