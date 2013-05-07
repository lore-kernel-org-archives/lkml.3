Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3EGTDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:03:52 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:41961 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755138Ab3EGTDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:03:50 -0400
Subject: Re: [PATCH 07/15] hfs: avoid crash in hfs_bnode_create
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <1367936303-13386-7-git-send-email-jslaby@suse.cz>
Date: Tue, 7 May 2013 23:05:26 +0400
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D666C431-DAD2-4189-9716-564602705D82@dubeyko.com>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <1367936303-13386-7-git-send-email-jslaby@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 7, 2013, at 6:18 PM, Jiri Slaby wrote:

> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 634725a92938b0f282b17cec0b007dca77adebd2 removed the BUG_ON in
> hfs_bnode_create in hfsplus. This patch removes it from the hfs
> version and avoids an fsfuzzer crash.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Acked-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> fs/hfs/bnode.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
> index f3b1a15..6d435c2 100644
> --- a/fs/hfs/bnode.c
> +++ b/fs/hfs/bnode.c
> @@ -415,7 +415,11 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
> 	spin_lock(&tree->hash_lock);
> 	node = hfs_bnode_findhash(tree, num);
> 	spin_unlock(&tree->hash_lock);
> -	BUG_ON(node);
> +	if (node) {
> +		printk(KERN_CRIT "new node %u already hashed?\n", num);

The error/debug subsystem of HFS/HFS+ was reworked by Joe Perches, recently. Please, change printk() on pr_crit().

Thanks,
Vyacheslav Dubeyko.

> +		WARN_ON(1);
> +		return node;
> +	}
> 	node = __hfs_bnode_create(tree, num);
> 	if (!node)
> 		return ERR_PTR(-ENOMEM);
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

