Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3ALDRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 22:17:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:49955 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab3ALDRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 22:17:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,455,1355126400"; 
   d="scan'208";a="272950051"
Date: Sat, 12 Jan 2013 11:17:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, chavey@google.com,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/5] writeback: add more tracepoints
Message-ID: <20130112031702.GA10024@localhost>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
 <1357938397-5413-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357938397-5413-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch looks good to me. But CC more people for review.

On Fri, Jan 11, 2013 at 01:06:37PM -0800, Tejun Heo wrote:
> Add tracepoints for page dirtying, writeback_single_inode start, inode
> dirtying and writeback.  For the latter two inode events, a pair of
> events are defined to denote start and end of the operations (the
> starting one has _start suffix and the one w/o suffix happens after
> the operation is complete).  These inode ops are FS specific and can
> be non-trivial and having enclosing tracepoints is useful for external
> tracers.
> 
> This is part of tracepoint additions to improve visiblity into
> dirtying / writeback operations for io tracer and userland.
> 
> v2: writeback_dirty_inode[_start] TPs may be called for files on
>     pseudo FSes w/ unregistered bdi.  Check whether bdi->dev is %NULL
>     before dereferencing.
> 
> v3: buffer dirtying moved to a block TP.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  fs/fs-writeback.c                |  16 +++++-
>  include/trace/events/writeback.h | 116 +++++++++++++++++++++++++++++++++++++++
>  mm/page-writeback.c              |   2 +
>  3 files changed, 132 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 310972b..359494e 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -318,8 +318,14 @@ static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
>  
>  static int write_inode(struct inode *inode, struct writeback_control *wbc)
>  {
> -	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode))
> -		return inode->i_sb->s_op->write_inode(inode, wbc);
> +	int ret;
> +
> +	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode)) {
> +		trace_writeback_write_inode_start(inode, wbc);
> +		ret = inode->i_sb->s_op->write_inode(inode, wbc);
> +		trace_writeback_write_inode(inode, wbc);
> +		return ret;
> +	}
>  	return 0;
>  }
>  
> @@ -450,6 +456,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  
>  	WARN_ON(!(inode->i_state & I_SYNC));
>  
> +	trace_writeback_single_inode_start(inode, wbc, nr_to_write);
> +
>  	ret = do_writepages(mapping, wbc);
>  
>  	/*
> @@ -1150,8 +1158,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  	 * dirty the inode itself
>  	 */
>  	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
> +		trace_writeback_dirty_inode_start(inode, flags);
> +
>  		if (sb->s_op->dirty_inode)
>  			sb->s_op->dirty_inode(inode, flags);
> +
> +		trace_writeback_dirty_inode(inode, flags);
>  	}
>  
>  	/*
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index b453d92..6a16fd2 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -32,6 +32,115 @@
>  
>  struct wb_writeback_work;
>  
> +TRACE_EVENT(writeback_dirty_page,
> +
> +	TP_PROTO(struct page *page, struct address_space *mapping),
> +
> +	TP_ARGS(page, mapping),
> +
> +	TP_STRUCT__entry (
> +		__array(char, name, 32)
> +		__field(unsigned long, ino)
> +		__field(pgoff_t, index)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name,
> +			mapping ? dev_name(mapping->backing_dev_info->dev) : "(unknown)", 32);
> +		__entry->ino = mapping ? mapping->host->i_ino : 0;
> +		__entry->index = page->index;
> +	),
> +
> +	TP_printk("bdi %s: ino=%lu index=%lu",
> +		__entry->name,
> +		__entry->ino,
> +		__entry->index
> +	)
> +);
> +
> +DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
> +
> +	TP_PROTO(struct inode *inode, int flags),
> +
> +	TP_ARGS(inode, flags),
> +
> +	TP_STRUCT__entry (
> +		__array(char, name, 32)
> +		__field(unsigned long, ino)
> +		__field(unsigned long, flags)
> +	),
> +
> +	TP_fast_assign(
> +		struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
> +
> +		/* may be called for files on pseudo FSes w/ unregistered bdi */
> +		strncpy(__entry->name,
> +			bdi->dev ? dev_name(bdi->dev) : "(unknown)", 32);
> +		__entry->ino		= inode->i_ino;
> +		__entry->flags		= flags;
> +	),
> +
> +	TP_printk("bdi %s: ino=%lu flags=%s",
> +		__entry->name,
> +		__entry->ino,
> +		show_inode_state(__entry->flags)
> +	)
> +);
> +
> +DEFINE_EVENT(writeback_dirty_inode_template, writeback_dirty_inode_start,
> +
> +	TP_PROTO(struct inode *inode, int flags),
> +
> +	TP_ARGS(inode, flags)
> +);
> +
> +DEFINE_EVENT(writeback_dirty_inode_template, writeback_dirty_inode,
> +
> +	TP_PROTO(struct inode *inode, int flags),
> +
> +	TP_ARGS(inode, flags)
> +);
> +
> +DECLARE_EVENT_CLASS(writeback_write_inode_template,
> +
> +	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
> +
> +	TP_ARGS(inode, wbc),
> +
> +	TP_STRUCT__entry (
> +		__array(char, name, 32)
> +		__field(unsigned long, ino)
> +		__field(int, sync_mode)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name,
> +			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
> +		__entry->ino		= inode->i_ino;
> +		__entry->sync_mode	= wbc->sync_mode;
> +	),
> +
> +	TP_printk("bdi %s: ino=%lu sync_mode=%d",
> +		__entry->name,
> +		__entry->ino,
> +		__entry->sync_mode
> +	)
> +);
> +
> +DEFINE_EVENT(writeback_write_inode_template, writeback_write_inode_start,
> +
> +	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
> +
> +	TP_ARGS(inode, wbc)
> +);
> +
> +DEFINE_EVENT(writeback_write_inode_template, writeback_write_inode,
> +
> +	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
> +
> +	TP_ARGS(inode, wbc)
> +);
> +
>  DECLARE_EVENT_CLASS(writeback_work_class,
>  	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_work *work),
>  	TP_ARGS(bdi, work),
> @@ -479,6 +588,13 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
>  	)
>  );
>  
> +DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_start,
> +	TP_PROTO(struct inode *inode,
> +		 struct writeback_control *wbc,
> +		 unsigned long nr_to_write),
> +	TP_ARGS(inode, wbc, nr_to_write)
> +);
> +
>  DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode,
>  	TP_PROTO(struct inode *inode,
>  		 struct writeback_control *wbc,
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0713bfb..3734cef 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1982,6 +1982,8 @@ int __set_page_dirty_no_writeback(struct page *page)
>   */
>  void account_page_dirtied(struct page *page, struct address_space *mapping)
>  {
> +	trace_writeback_dirty_page(page, mapping);
> +
>  	if (mapping_cap_account_dirty(mapping)) {
>  		__inc_zone_page_state(page, NR_FILE_DIRTY);
>  		__inc_zone_page_state(page, NR_DIRTIED);
> -- 
> 1.8.0.2
