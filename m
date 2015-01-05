Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbbAEJUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:20:19 -0500
Received: from out4133-34.mail.aliyun.com ([42.120.133.34]:36494 "EHLO
	out4133-34.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbbAEJUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:20:17 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 04:20:17 EST
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03008;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=6;RT=6;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'xiaomin1'" <xiaoming.wang@intel.com>
Cc: "'Zhang Dongxing'" <dongxing.zhang@intel.com>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        "Chuansheng Liu" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] move file->f_op->open out of mutex (misc_mtx) in misc_open
Date: Mon, 05 Jan 2015 17:14:05 +0800
Message-ID: <023c01d028c7$f4838f90$dd8aaeb0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAox9xkNeS60RlmQVScv5N6FHcwtA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> misc_mtx was used to mutex misc_list.
> But file->f_op->open may be blocked by downloading
> firmware in some devices' open.
> So move file->f_op->open out of mutex (misc_mtx)
> in misc_open to avoid this block.
> It also make code more efficiency.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> ---
>  drivers/char/misc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index ffa97d2..289c59e 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -144,7 +144,8 @@ static int misc_open(struct inode * inode, struct file * file)
>  	replace_fops(file, new_fops);
>  	if (file->f_op->open) {
>  		file->private_data = c;
> -		err = file->f_op->open(inode,file);
> +		mutex_unlock(&misc_mtx);
> +		return file->f_op->open(inode,file);
>  	}
What if unregister breaks in while opening?

>  fail:
>  	mutex_unlock(&misc_mtx);
> --
> 1.7.9.5

