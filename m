Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3FCNuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:50:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20802 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:50:03 -0400
X-Authority-Analysis: v=2.0 cv=H9pZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=o_R7o4KmPt4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=IOTlXhXV0CIA:10 a=QyXUC8HyAAAA:8 a=GNRNoj2Bx3dmwz6ldzwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=2fxHo_BMmwuT8xSo:21 a=ni5HbFgQNZT3HRBU:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370267400.26799.90.camel@gandalf.local.home>
Subject: Re: [RFC 5/5] f2fs: add tracepoints to debug inline data operations
From: Steven Rostedt <rostedt@goodmis.org>
To: Huajun Li <huajun.li@intel.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com, namjae.jeon@samsung.com,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Haicheng Li <haicheng.li@linux.intel.com>
Date: Mon, 03 Jun 2013 09:50:00 -0400
In-Reply-To: <1370253854-15084-6-git-send-email-huajun.li@intel.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
	 <1370253854-15084-6-git-send-email-huajun.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 18:04 +0800, Huajun Li wrote:
> From: Haicheng Li <haicheng.li@linux.intel.com>
> 
> Add tracepoints for: f2fs_read_inline_data(), f2fs_convert_inline_data(),
> f2fs_write_inline_data().
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> Signed-off-by: Huajun Li <huajun.li@intel.com>
> ---
>  fs/f2fs/inline.c            |    4 +++
>  include/trace/events/f2fs.h |   69 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index a2aa056..9ec66e5 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -14,6 +14,7 @@
>  #include <linux/f2fs_fs.h>
>  
>  #include "f2fs.h"
> +#include <trace/events/f2fs.h>
>  
>  void f2fs_clear_inode_inline_flag(struct f2fs_inode *raw_inode)
>  {
> @@ -44,6 +45,7 @@ static int f2fs_read_inline_data(struct inode *inode, struct page *page)
>  	if (IS_ERR(ipage))
>  		return PTR_ERR(ipage);
>  
> +	trace_f2fs_read_inline_data(inode, page);
>  	src_addr = page_address(ipage);
>  	dst_addr = page_address(page);
>  
> @@ -107,6 +109,7 @@ int f2fs_convert_inline_data(struct page *p,
>  	set_page_dirty(ipage);
>  	f2fs_put_page(ipage, 1);
>  
> +	trace_f2fs_convert_inline_data(inode, page);
>  	if (!p->index) {
>  		SetPageUptodate(page);
>  	} else {
> @@ -138,6 +141,7 @@ int f2fs_write_inline_data(struct inode *inode,
>  	if (IS_ERR(ipage))
>  		return PTR_ERR(ipage);
>  
> +	trace_f2fs_write_inline_data(inode, page);
>  	src_addr = page_address(page);
>  	dst_addr = page_address(ipage);
>  
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index 52ae548..bc7a84e 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -676,6 +676,75 @@ TRACE_EVENT(f2fs_write_checkpoint,
>  		__entry->msg)
>  );
>  
> +TRACE_EVENT(f2fs_read_inline_data,
> +
> +	TP_PROTO(struct inode *inode, struct page *page),
> +
> +	TP_ARGS(inode, page),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t,	dev)
> +		__field(ino_t,	ino)
> +		__field(pgoff_t, index)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->index	= page->index;
> +	),
> +
> +	TP_printk("dev = (%d,%d), ino = %lu, index = %lu",
> +		show_dev_ino(__entry),
> +		(unsigned long)__entry->index)
> +);
> +
> +TRACE_EVENT(f2fs_convert_inline_data,
> +
> +	TP_PROTO(struct inode *inode, struct page *page),
> +
> +	TP_ARGS(inode, page),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t,	dev)
> +		__field(ino_t,	ino)
> +		__field(pgoff_t, index)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->index	= page->index;
> +	),
> +
> +	TP_printk("dev = (%d,%d), ino = %lu, index = %lu",
> +		show_dev_ino(__entry),
> +		(unsigned long)__entry->index)
> +);
> +
> +TRACE_EVENT(f2fs_write_inline_data,
> +
> +	TP_PROTO(struct inode *inode, struct page *page),
> +
> +	TP_ARGS(inode, page),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t,	dev)
> +		__field(ino_t,	ino)
> +		__field(pgoff_t, index)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->index	= page->index;
> +	),
> +
> +	TP_printk("dev = (%d,%d), ino = %lu, index = %lu",
> +		show_dev_ino(__entry),
> +		(unsigned long)__entry->index)
> +);

Can you convert the above to use DECLARE_EVENT_CLASS() and
DEFINE_EVENT(), as the above three are basically the same. You'll save a
few K in text by doing so.

Thanks,

-- Steve



> +
>  #endif /* _TRACE_F2FS_H */
>  
>   /* This part must be outside protection */


