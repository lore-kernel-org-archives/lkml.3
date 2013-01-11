Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3AKHVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:21:03 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:44575 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3AKHVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:21:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130110004831.GV20089@twin.jikos.cz>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
	<1356014615-15073-3-git-send-email-zwu.kernel@gmail.com>
	<20130110004831.GV20089@twin.jikos.cz>
Date: Fri, 11 Jan 2013 15:21:00 +0800
Message-ID: <CAEH94LgwHCXSOLQ9E6iSCEHL2_CsQYFD2ok80-W8wkQswtLjvw@mail.gmail.com>
Subject: Re: [PATCH RESEND v1 02/16] vfs: add init and cleanup functions
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: dsterba@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 8:48 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Dec 20, 2012 at 10:43:21PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> --- a/fs/hot_tracking.c
>> +++ b/fs/hot_tracking.c
>> @@ -107,3 +189,38 @@ err:
>>       kmem_cache_destroy(hot_inode_item_cachep);
>>  }
>>  EXPORT_SYMBOL_GPL(hot_cache_init);
>> +
>> +/*
>> + * Initialize the data structures for hot data tracking.
>> + */
>> +int hot_track_init(struct super_block *sb)
>> +{
>> +     struct hot_info *root;
>> +     int ret = -ENOMEM;
>> +
>> +     root = kzalloc(sizeof(struct hot_info), GFP_NOFS);
>> +     if (!root) {
>> +             printk(KERN_ERR "%s: Failed to malloc memory for "
>> +                             "hot_info\n", __func__);
>> +             return ret;
>> +     }
>> +
>> +     hot_inode_tree_init(root);
>
> This function is supposed to be called from the filesystem init, please
> add a sanity check that would catch multiple initialization attempts.
Good catch, thanks. Done.

>
>> +
>> +     sb->s_hot_root = root;
>> +
>> +     printk(KERN_INFO "VFS: Turning on hot data tracking\n");
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(hot_track_init);
>> +
>> +void hot_track_exit(struct super_block *sb)
>> +{
>> +     struct hot_info *root = sb->s_hot_root;
>
> another sanity check to catch the opposite.
ditto.
>
> Why? The option is parsed and enabled from the filesystems, due to
> unexpected bugs eg with remounting or incorrectly handled error paths,
> vfs layer should IMHO rather warn than crash.
thanks for your expalaination.
>
>> +
>> +     hot_inode_tree_exit(root);
>> +     sb->s_hot_root = NULL;
>> +     kfree(root);
>> +}
>> +EXPORT_SYMBOL_GPL(hot_track_exit);
>
>
> david



-- 
Regards,

Zhi Yong Wu
