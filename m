Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3JYNYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:24:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58924 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3JYNX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:23:57 -0400
Message-ID: <526A70E5.1000909@gmail.com>
Date: Fri, 25 Oct 2013 21:23:49 +0800
From: Jiaxing Wang <hello.wjx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>, Al Viro <viro@zeniv.linux.org.uk>
CC: fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] seq_file: always update file->f_pos in seq_lseek()
References: <526A44AA.8050804@cn.fujitsu.com>
In-Reply-To: <526A44AA.8050804@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 06:15 PM, Gu Zheng wrote:
> This issue was first pointed out by Jiaxing Wang several months ago, but no
> further comments:
> https://lkml.org/lkml/2013/6/29/41
> 
> As we know pread() does not change f_pos, so after pread(), file->f_pos
> and m->read_pos become different. And seq_lseek() does not update file->f_pos
> if offset equals to m->read_pos, so after pread() and seq_lseek()(lseek to
> m->read_pos), then a subsequent read may read from a wrong position, the
> following program produces the problem:
> 
>     char str1[32] = { 0 };
>     char str2[32] = { 0 };
>     int poffset = 10;
>     int count = 20;
> 
>     /*open any seq file*/
>     int fd = open("/proc/modules", O_RDONLY);
> 
>     pread(fd, str1, count, poffset);
>     printf("pread:%s\n", str1);
> 
>     /*seek to where m->read_pos is*/
>     lseek(fd, poffset+count, SEEK_SET);
> 
>     /*supposed to read from poffset+count, but this read from position 0*/
>     read(fd, str2, count);
>     printf("read:%s\n", str2);
> 
> out put:
> pread:
>  ck_netbios_ns 12665
> read:
>  nf_conntrack_netbios
> 
> /proc/modules:
> nf_conntrack_netbios_ns 12665 0 - Live 0xffffffffa038b000
> nf_conntrack_broadcast 12589 1 nf_conntrack_netbios_ns, Live 0xffffffffa0386000
> 
> So we always update file->f_pos to offset in seq_lseek() to fix this issue.
> 
> Signed-off-by: Jiaxing Wang <hello.wjx@gmail.com>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/seq_file.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3135c25..a290157 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -328,6 +328,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int whence)
>  				m->read_pos = offset;
>  				retval = file->f_pos = offset;
>  			}
> +		} else {
> +			file->f_pos = offset;
>  		}
>  	}
>  	file->f_version = m->version;
> 

Thanks Gu, I should have post this patch again.
And Viro, please take a few minutes to review this, thanks.
