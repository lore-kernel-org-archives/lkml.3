Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3BSCwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:52:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab3BSCwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:52:08 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MFl-PuF5JLYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=3xO-tVoUQDAA:10 a=hD80L64hAAAA:8 a=nJy3uJ-UIIgZrwBub-MA:9 a=PUjeQqilurYA:10 a=v3rLFGiuRE8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361242326.23152.189.camel@gandalf.local.home>
Subject: Re: [PATCH 2/8] f2fs: add tracepoints for inode operations
From: Steven Rostedt <rostedt@goodmis.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Mon, 18 Feb 2013 21:52:06 -0500
In-Reply-To: <1361241190-18073-1-git-send-email-linkinjeon@gmail.com>
References: <1361241190-18073-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 11:33 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>

> +TRACE_EVENT(f2fs_unlink_exit,
> +	TP_PROTO(struct dentry *dentry, int ret),
> +
> +	TP_ARGS(dentry, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(ino_t,	ino)
> +		__field(dev_t,	dev)
> +		__field(int,	ret)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ino		= dentry->d_inode->i_ino;
> +		__entry->dev		= dentry->d_inode->i_sb->s_dev;
> +		__entry->ret		= ret;
> +	),
> +
> +	TP_printk("dev %d,%d ino %lu ret %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  (unsigned long) __entry->ino,
> +		  __entry->ret)
> +);
> +
>  #endif /* _TRACE_F2FS_H */
>  
>   /* This part must be outside protection */

If at all possible, try to combine as many tracepoints as possible by a
class. A TRACE_EVENT() is really a DECLARE_EVENT_CLASS();
DEFINE_EVENT(); pair that totals about 5k per TRACE_EVENT(). The
DECLARE_EVENT_CLASS() being the majority of that. A DEFINE_EVENT() adds
approximately 250 bytes each. Thus, combining the above with the
TRACE_EVENT() from the previous patch:

+TRACE_EVENT(f2fs_sync_file_exit,
+       TP_PROTO(struct inode *inode, int ret),
+
+       TP_ARGS(inode, ret),
+
+       TP_STRUCT__entry(
+               __field(int,    ret)
+               __field(ino_t,  ino)
+               __field(dev_t,  dev)
+       ),
+
+       TP_fast_assign(
+               __entry->ret            = ret;
+               __entry->ino            = inode->i_ino;
+               __entry->dev            = inode->i_sb->s_dev;
+       ),
+
+       TP_printk("dev %d,%d ino %lu ret %d",
+                 MAJOR(__entry->dev), MINOR(__entry->dev),
+                 (unsigned long) __entry->ino,
+                 __entry->ret)
+);

into:

DECLARE_EVENT_CLASS(f2fs_dev_inode_ret,
       TP_PROTO(struct inode *inode, int ret),

       TP_ARGS(inode, ret),

       TP_STRUCT__entry(
               __field(int,    ret)
               __field(ino_t,  ino)
               __field(dev_t,  dev)
       ),

       TP_fast_assign(
               __entry->ret            = ret;
               __entry->ino            = inode->i_ino;
               __entry->dev            = inode->i_sb->s_dev;
       ),

       TP_printk("dev %d,%d ino %lu ret %d",
                 MAJOR(__entry->dev), MINOR(__entry->dev),
                 (unsigned long) __entry->ino,
                 __entry->ret)
);

DEFINE_EVENT(f2fs_sync_file_exit,
       TP_PROTO(struct inode *inode, int ret),
       TP_ARGS(inode, ret));

DEFINE_EVENT(f2fs_unlink_exit,
       TP_PROTO(struct inode *inode, int ret),
       TP_ARGS(inode, ret));

You can save ~4750 bytes. Note, you will need to pass the inode instead
of the dentry into f2fs_unlink_exit(), but you don't use the dentry
anyway.

-- Steve


