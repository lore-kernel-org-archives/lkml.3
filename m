Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab3DINH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:07:59 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37347 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab3DINH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <1365509231.4353.100.camel@kjgkr>
References: <1365227126-15355-1-git-send-email-linkinjeon@gmail.com>
	<1365467115.25498.35.camel@gandalf.local.home>
	<CAKYAXd-xpJW=W8UHA=3+Jm-x5y81e__QsLJ0pw4H80SuS+SYSg@mail.gmail.com>
	<1365509231.4353.100.camel@kjgkr>
Date: Tue, 9 Apr 2013 22:07:57 +0900
Message-ID: <CAKYAXd8+i1yuy0H=ArMq_taMfrRj++JYLWBoCv3B-UrDpsAKdQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] f2fs: add tracepoints support in f2fs filesystem
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-04-09 (화), 10:04 +0900, Namjae Jeon:
>> 2013/4/9, Steven Rostedt <rostedt@goodmis.org>:
>> > On Sat, 2013-04-06 at 14:45 +0900, Namjae Jeon wrote:
>> >> From: Namjae Jeon <namjae.jeon@samsung.com>
>> >>
>> >> Add tracepoints in f2fs filesystem for tracing the filesystem
>> >> operations for information/debugging purpose if needed. All the
>> >> tracepoints are clubbed with respect to functionalities.
>> >>
>> >> Change Log:
>> >> v3: Introduced TRACE_EVENT_CONDITION() macro for checking the
>> >> condition page->mapping inside the trace point function call as
>> >> per Steve's review comment for the patch
>> >>
>> >> v2: Added DECLARE_EVENT_CLASS() macro for combining the similar
>> >> type of trace function calls which has same type of arguments.
>> >>
>> >> v1: Introduced the tracepoint functions in f2fs filesystem.
>> >>
>> >> Namjae Jeon (7):
>> >>   f2fs: add tracepoints for sync & Inode operations
>> >>   f2fs: add tracepoints for truncate operation
>> >>   f2fs: add tracepoint for tracing the page i/o operations
>> >>   f2fs: add tracepoints for GC threads
>> >>   f2fs: add tracepoints to debug the block allocation & fallocate
>> >>   f2fs: add tracepoints for write page operations
>> >>   f2fs: add tracepoints to debug checkpoint request
>> >>
>> >
>> Hi. Steve.
>> > I have nothing more to add about the tracepoint processing. Looks good.
>> > Now if the tracepoints give you sufficient data? That's up to the
>> > maintainers to decide.
>> Until now, yes. but I will continously try to update trace point more
>> if finding additional  needed points after.
>> Thanks for review and your ack.
>
> Thank you, Steve. :)
>
> To Namjae,
> I've reviewed the patch-set in terms of more informative tracepoints,
> and summarized what I'd like to suggest.
> Could you examine the following tracepoints?
Sure, I'll check it with coffee in tomorrow morning.
Thanks :)
> I really appreciate your job.
> Thanks,
>
> *format*
> tracepoint [its location] (information)
>
> 1. patch 1/7:
>
> f2fs_sync_file_enter [enter]
> (dev,ino,parent,i_mode,i_nlink,i_blocks,fi->i_advise,fi->i_pino,datasync)
> f2fs_sync_file_exit [exit] (dev,ino,need_cp,ret)
> f2fs_sync_fs [enter] (dev,sbi->s_dirty,wait)
> f2fs_iget_enter [enter] (dev,ino)
> f2fs_iget_exit [exit] (dev,ino,ret)
> f2fs_evict_inode [enter] (dev,ino,i_nlink,i_blocks)
> f2fs_unlink_enter [enter]
> (dev,ino,i_blocks,dentry->d_name,parent->i_ino)
> f2fs_unlink_exit [exit] (dev,ino,ret)
>
> 2. patch 2/7:
> truncate_blocks_enter [enter] (dev,ino,from)
> truncate_blocks_exit [exit] (dev,ino, err)
> truncate_inode_blocks_enter [enter] (dev,ino,from)
> truncate_inode_blocks_exit [exit] (dev,ino,err)
> truncate_partial_nodes [exit] (dev,ino,nid[0],nid[1],nid[2],depth,err)
> truncate_data_blocks_range [exit]
> (dev,ino,dn->nid,dn->ofs_in_node,nr_free)
> truncate_node [exit] (dev,ino,dn->nid,ni.blk_addr)
>
> 3. patch 3/7:
> get_data_block_ro [all_exits]
> (dev,ino,iblock,bh_result->b_blocknr,bh_result->b_size,err)
> f2fs_readpage [enter] (dev,ino,index,blk_addr,type)
>
> 4. patch 4/7:
> get_victim_by_default [exit]
> (dev,gc_type,type,p.alloc_mode,p.gc_mode,p.ofs_unit,p.min_segno,sbi->cur_victim_sec)
>
> 5. patch 5/7:
> f2fs_fallocate [exit] (dev,ino,offset,len,mode,i_blocks,i_size,ret)
> f2fs_reserve_new_block [ext] (dev,ino,dn->nid,dn->ofs_in_node)
>
> 6. patch 6/7:
> submit_write_page [exit] (dev,ino,index,blk_addr,type)
> do_submit_bio [if(sbi->bio[btype]]
> (dev,btype,sync,bio->bi_sector,bio->bi_size)
> f2fs_write_begin [enter] (dev,ino,pos,len,flags)
>
> 7. patch 7/7:
> write_checkpoint_before_blockop [before block_operations()]
> (dev,is_mount,"try to block operations")
> write_checkpoint_after_blockop [after block_operations()]
> (dev,is_mount,"done block operations")
> write_checkpoint_exit [exit] (dev,is_mount,"done checkpoint")
>
>>
>> >
>> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
>> >
>> > -- Steve
>> >
>> >
>> >
>
> --
> Jaegeuk Kim
> Samsung
