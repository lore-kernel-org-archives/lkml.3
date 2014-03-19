Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbaCSJKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:10:53 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37516 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802AbaCSJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:10:49 -0400
Message-ID: <53295ECE.5020303@gmail.com>
Date: Wed, 19 Mar 2014 10:09:34 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: mtk.manpages@gmail.com, Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: For review: open_by_name_at(2) man page
References: <53271B69.3000305@gmail.com>	<20140318090007.3adee3d0@notabene.brown>	<20140318094321.GA17024@infradead.org>	<53283DFB.6040105@gmail.com> <20140319092427.0812263c@notabene.brown>
In-Reply-To: <20140319092427.0812263c@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 03/18/2014 11:24 PM, NeilBrown wrote:
> On Tue, 18 Mar 2014 13:37:15 +0100 "Michael Kerrisk (man-pages)"
> <mtk.manpages@gmail.com> wrote:
> 
>> On 03/18/2014 10:43 AM, Christoph Hellwig wrote:
>>> On Tue, Mar 18, 2014 at 09:00:07AM +1100, NeilBrown wrote:
>>>> ESTALE is also returned if the filesystem does not support file-handle ->
>>>> file mappings.
>>>> On filesystems which don't provide export_operations (/sys /proc ubifs
>>>> romfs cramfs nfs coda ... several others) name_to_handle_at will produce a
>>>> generic handle using the 32 bit inode and 32 bit i_generation.
>>>
>>> Do we?  Seems like the code is erroring out early if there are no
>>> export_ops?
>>
>> It appears to me that Neil's statement isn't correct, at least for /proc
>> and /sys (see my other mail, to Neil). I'm unsure about whether it is true
>> for some of those other FSes thought.
> 
> 
> Indeed, I was wrong.
> 
> I was looking at
> 
> int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
> 			     int *max_len, struct inode *parent)
> {
> 	const struct export_operations *nop = inode->i_sb->s_export_op;
> 
> 	if (nop && nop->encode_fh)
> 		return nop->encode_fh(inode, fid->raw, max_len, parent);
> 
> 	return export_encode_fh(inode, fid, max_len, parent);
> }
> 
> 
> which uses a default if there is no 'nop'.
> 
> However do_sys_name_to_handle() contains
> 
> 	if (!path->dentry->d_sb->s_export_op ||
> 	    !path->dentry->d_sb->s_export_op->fh_to_dentry)
> 		return -EOPNOTSUPP;
> 
> long before export_encode_inode_fh() gets called.  So the default isn't used.

Okay.

> I would have thought that exportfs_encode_inode_fh would never get called if
> there were no s_export_op pointer - certainly name_to_handle_at and nfsd
> would never call it in that case.
> However it seems that
> 
>     This routine will be used to generate a file handle in fdinfo output for
>     inotify subsystem, where if no s_export_op present the general
>     export_encode_fh should be used.  Thus add a test if s_export_op present
>     inside exportfs_encode_fh itself.
> 
> according to
> 
> commit ab49bdecc3ebb46ab661f5f05d5c5ea9606406c6
> Author: Cyrill Gorcunov <gorcunov@openvz.org>
> Date:   Mon Dec 17 16:05:06 2012 -0800
> 
> 
> I guess that means that you can extract filehandles from /proc/self/fdinfo/$FD
> when $FD is an inotify fd which is watching the particular file.....  I
> wouldn't have expected that, but maybe it is a good idea.

Yes, it does--I tested it, and it works! I was unaware of this feature,
though I'm not sure that I'll add anything to a man page just yet.

> So yes: if the filesystem doesn't support filehandles you get EOPNOTSUPP.
> So if you get ESTALE from open_by_handle_at(), then it really is a stale
> handle.  Sorry for the confusion.

Yup, I've updated the page now.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
