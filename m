Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3KNQXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:23:10 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35777 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3KNQWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:22:38 -0500
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com> <1384445622-12346-13-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1384445622-12346-13-git-send-email-bergwolf@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <048D09EB-A44F-422F-A88C-D26E93C9225C@xyratex.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Farrell <paf@cray.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
X-Mailer: iPad Mail (11B511)
From: Cheng Shao <cheng_shao@xyratex.com>
Subject: Re: [PATCH 12/40] staging/lustre/nfs: writing to new files will return ENOENT
Date: Thu, 14 Nov 2013 08:22:34 -0800
To: Peng Tao <bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peng,

This patch was eventually reverted as it was causing interoperability issues with 2.1 Lustre server. We are working on the new patch, so please don't include this one.

Thanks,
- Cheng

> On Nov 14, 2013, at 8:13 AM, Peng Tao <bergwolf@gmail.com> wrote:
> 
> From: Patrick Farrell <paf@cray.com>
> 
> This happend with SLES11SP2 Lustre client, which in turn acts as an
> NFS server, exporting a subtree of an Lustre fs through NFS.
> 
> We detected that whenever we are writing to a new file using, fx,
> 'echo blah > newfile', it will return ENOENT error. We found
> out that this was caused by the anonymous dentry. In SLESS11SP2,
> anonymous dentries are assigned '/' as the name, instead of an
> empty string. When MDT handles the intent_open call, it will look
> up the obj by the name if it is not an empty string, and thus
> couldn't find it.
> 
> As MDS_OPEN_BY_FID is always set on this request, we never need
> to send the name in this request.  The fid is already available
> and should be used in case the file has been renamed.
> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3544
> Lustre-change: http://review.whamcloud.com/6920
> Signed-off-by: Cheng Shao <cheng_shao@xyratex.com>
> Signed-off-by: Patrick Farrell <paf@cray.com>
> Reviewed-by: Bob Glossman <bob.glossman@intel.com>
> Reviewed-by: Alexey Shvetsov <alexxy@gentoo.org>
> Reviewed-by: Lai Siyao <lai.siyao@intel.com>
> Reviewed-by: James Simmons <uja.ornl@gmail.com>
> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
> drivers/staging/lustre/lustre/llite/file.c |    5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
> index f97c600..efc614b 100644
> --- a/drivers/staging/lustre/lustre/llite/file.c
> +++ b/drivers/staging/lustre/lustre/llite/file.c
> @@ -368,8 +368,6 @@ static int ll_intent_file_open(struct file *file, void *lmm,
> {
>    struct ll_sb_info *sbi = ll_i2sbi(file->f_dentry->d_inode);
>    struct dentry *parent = file->f_dentry->d_parent;
> -    const char *name = file->f_dentry->d_name.name;
> -    const int len = file->f_dentry->d_name.len;
>    struct md_op_data *op_data;
>    struct ptlrpc_request *req;
>    __u32 opc = LUSTRE_OPC_ANY;
> @@ -394,8 +392,9 @@ static int ll_intent_file_open(struct file *file, void *lmm,
>    }
> 
>    op_data  = ll_prep_md_op_data(NULL, parent->d_inode,
> -                      file->f_dentry->d_inode, name, len,
> +                      file->f_dentry->d_inode, NULL, 0,
>                      O_RDWR, opc, NULL);
> +
>    if (IS_ERR(op_data))
>        return PTR_ERR(op_data);
> 
> -- 
> 1.7.9.5
> 
