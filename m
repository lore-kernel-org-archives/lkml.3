Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaAQAAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:00:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:42787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaAQAAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:00:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="440116221"
Date: Thu, 16 Jan 2014 17:00:12 -0700 (MST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
X-X-Sender: rzwisler@scrumpy
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 19/22] ext4: Add XIP functionality
In-Reply-To: <CEFDA737.22F87%matthew.r.wilcox@intel.com>
Message-ID: <alpine.OSX.2.00.1401161653120.41367@scrumpy>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com> <CEFDA737.22F87%matthew.r.wilcox@intel.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014, Matthew Wilcox wrote:

> +#ifdef CONFIG_FS_XIP
> +const struct file_operations ext4_xip_file_operations = {
> +	.llseek		= ext4_llseek,
> +	.read		= do_sync_read,
> +	.write		= do_sync_write,

I think we may always need to define ext2_xip_file_operations and
ext4_xip_file_operations, even if we have XIP compiled out.  We make the
decision on which file operations table to use at runtime:

from ext4_iget:
		if (test_opt(inode->i_sb, XIP))
                        inode->i_fop = &ext4_xip_file_operations;
                else    
                        inode->i_fop = &ext4_file_operations;

With CONFIG_FS_XIP undefined, we get a compile error:
	ERROR: "ext4_xip_file_operations" [fs/ext4/ext4.ko] undefined!
	ERROR: "ext2_xip_file_operations" [fs/ext2/ext2.ko] undefined!

My guess is that with the old ext2 XIP code and with the first pass of the ext4
XIP code, we weren't seeing this because the uses of the xip file operations
table were optimized out, removing the undefined symbol?

- Ross
