Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab3BTF6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:58:07 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39142 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3BTF6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:58:05 -0500
MIME-Version: 1.0
In-Reply-To: <1361242326.23152.189.camel@gandalf.local.home>
References: <1361241190-18073-1-git-send-email-linkinjeon@gmail.com>
	<1361242326.23152.189.camel@gandalf.local.home>
Date: Wed, 20 Feb 2013 14:58:04 +0900
Message-ID: <CAKYAXd94oHDZUfV1MaS7eoSRKUbOXMid8rFjdxWWuwLa3Cdv=g@mail.gmail.com>
Subject: Re: [PATCH 2/8] f2fs: add tracepoints for inode operations
From: Namjae Jeon <linkinjeon@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/19 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2013-02-19 at 11:33 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>
>> +TRACE_EVENT(f2fs_unlink_exit,
>> +     TP_PROTO(struct dentry *dentry, int ret),
>> +
>> +     TP_ARGS(dentry, ret),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(ino_t,  ino)
>> +             __field(dev_t,  dev)
>> +             __field(int,    ret)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->ino            = dentry->d_inode->i_ino;
>> +             __entry->dev            = dentry->d_inode->i_sb->s_dev;
>> +             __entry->ret            = ret;
>> +     ),
>> +
>> +     TP_printk("dev %d,%d ino %lu ret %d",
>> +               MAJOR(__entry->dev), MINOR(__entry->dev),
>> +               (unsigned long) __entry->ino,
>> +               __entry->ret)
>> +);
>> +
>>  #endif /* _TRACE_F2FS_H */
>>
>>   /* This part must be outside protection */
>
> If at all possible, try to combine as many tracepoints as possible by a
> class. A TRACE_EVENT() is really a DECLARE_EVENT_CLASS();
> DEFINE_EVENT(); pair that totals about 5k per TRACE_EVENT(). The
> DECLARE_EVENT_CLASS() being the majority of that. A DEFINE_EVENT() adds
> approximately 250 bytes each. Thus, combining the above with the
> TRACE_EVENT() from the previous patch:
>
> +TRACE_EVENT(f2fs_sync_file_exit,
> +       TP_PROTO(struct inode *inode, int ret),
> +
> +       TP_ARGS(inode, ret),
> +
> +       TP_STRUCT__entry(
> +               __field(int,    ret)
> +               __field(ino_t,  ino)
> +               __field(dev_t,  dev)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->ret            = ret;
> +               __entry->ino            = inode->i_ino;
> +               __entry->dev            = inode->i_sb->s_dev;
> +       ),
> +
> +       TP_printk("dev %d,%d ino %lu ret %d",
> +                 MAJOR(__entry->dev), MINOR(__entry->dev),
> +                 (unsigned long) __entry->ino,
> +                 __entry->ret)
> +);
>
> into:
>
> DECLARE_EVENT_CLASS(f2fs_dev_inode_ret,
>        TP_PROTO(struct inode *inode, int ret),
>
>        TP_ARGS(inode, ret),
>
>        TP_STRUCT__entry(
>                __field(int,    ret)
>                __field(ino_t,  ino)
>                __field(dev_t,  dev)
>        ),
>
>        TP_fast_assign(
>                __entry->ret            = ret;
>                __entry->ino            = inode->i_ino;
>                __entry->dev            = inode->i_sb->s_dev;
>        ),
>
>        TP_printk("dev %d,%d ino %lu ret %d",
>                  MAJOR(__entry->dev), MINOR(__entry->dev),
>                  (unsigned long) __entry->ino,
>                  __entry->ret)
> );
>
> DEFINE_EVENT(f2fs_sync_file_exit,
>        TP_PROTO(struct inode *inode, int ret),
>        TP_ARGS(inode, ret));
>
> DEFINE_EVENT(f2fs_unlink_exit,
>        TP_PROTO(struct inode *inode, int ret),
>        TP_ARGS(inode, ret));
>
> You can save ~4750 bytes. Note, you will need to pass the inode instead
> of the dentry into f2fs_unlink_exit(), but you don't use the dentry
> anyway.
Hi Steven.
Thanks for review :). I will update patches as your advice.


> -- Steve
>
>
