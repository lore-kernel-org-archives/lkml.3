Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaJTXAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:00:04 -0400
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:58142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753858AbaJTXAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:00:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3867:3868:3872:3873:4321:4385:5007:6119:6261:8603:10004:10400:10482:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12740:13972:14096:14097:19901:19997:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mouth16_9139433c32b47
X-Filterd-Recvd-Size: 3652
Message-ID: <1413845996.5407.2.camel@perches.com>
Subject: Re: [PATCH 1/2 v2] binfmt_misc: add comments & debug logs
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Date: Mon, 20 Oct 2014 15:59:56 -0700
In-Reply-To: <1413845160-22497-1-git-send-email-vapier@gentoo.org>
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
	 <1413845160-22497-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 18:45 -0400, Mike Frysinger wrote:

> let's deploy extensive pr_debug markers at
> logical parse points, and add comments to the dense parsing logic.  It
> let's you see exactly where the parsing aborts, the string the kernel
> received (useful when dealing with shell code), how it translated the
> buffers to binary data, and how it will apply the mask at runtime.

Mostly trivia:

> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
[]
> @@ -323,46 +343,113 @@ static Node *create_entry(const char __user *buffer, size_t count)
[]
> +			if (e->mask) {
> +				int i;
> +				char *masked = kmalloc(e->size, GFP_USER);

Why GFP_USER?  Does it need it?

> +				print_hex_dump_bytes(
> +					KBUILD_MODNAME ": register:  mask[decoded]: ",
> +					DUMP_PREFIX_NONE, e->mask, e->size);
> +
> +				if (masked) {
> +					for (i = 0; i < e->size; ++i)
> +						masked[i] = e->magic[i] & e->mask[i];
> +					print_hex_dump_bytes(
> +						KBUILD_MODNAME ": register:  magic[masked]: ",
> +						DUMP_PREFIX_NONE, masked, e->size);
> +
> +					kfree(masked);

[]

> @@ -553,11 +645,17 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  	int res = parse_command(buffer, count);
>  
>  	switch (res) {
> -		case 1: clear_bit(Enabled, &e->flags);
> +		case 1:
> +			/* Disable this handler. */
> +			clear_bit(Enabled, &e->flags);
>  			break;
> -		case 2: set_bit(Enabled, &e->flags);
> +		case 2:
> +			/* Enable this handler. */
> +			set_bit(Enabled, &e->flags);
>  			break;
> -		case 3: root = dget(file->f_path.dentry->d_sb->s_root);
> +		case 3:
> +			/* Delete this handler. */
> +			root = dget(file->f_path.dentry->d_sb->s_root);
>  			mutex_lock(&root->d_inode->i_mutex);
>  
>  			kill_node(e);

Maybe move the case indents one tab position left

	switch (res) {
	case 1:			/* Disable handler */
		clear_bit(Enabled, ...);
		break;
	case 2:			/* Enable handler */
		set_bit(...);
		break;
	case 3:			/* Delete handler */
		etc...
	}

> @@ -661,9 +759,17 @@ static ssize_t bm_status_write(struct file * file, const char __user * buffer,
>  	struct dentry *root;
>  
>  	switch (res) {
> -		case 1: enabled = 0; break;
> -		case 2: enabled = 1; break;
> -		case 3: root = dget(file->f_path.dentry->d_sb->s_root);
> +		case 1:
> +			/* Disable all handlers. */
> +			enabled = 0;
> +			break;
> +		case 2:
> +			/* Enable all handlers. */
> +			enabled = 1;
> +			break;
> +		case 3:
> +			/* Delete all handlers. */
> +			root = dget(file->f_path.dentry->d_sb->s_root);
>  			mutex_lock(&root->d_inode->i_mutex);
>  
>  			while (!list_empty(&entries))

here too.


