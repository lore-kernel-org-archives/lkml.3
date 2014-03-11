Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaCKUh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:37:26 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50066 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaCKUhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140311061742.GB11552@lskakaxi-intel>
References: <20140311061519.GA11552@lskakaxi-intel>
	<20140311061742.GB11552@lskakaxi-intel>
Date: Tue, 11 Mar 2014 13:37:23 -0700
X-Google-Sender-Auth: 759ktS9x7xM9JDDx0bez39dKyE4
Message-ID: <CAGXu5jLkAdy7ctHRf8Yr36gvOBeJNuph5r7M9HNfH4DxTXpF0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] pstore: correct the max_dump_cnt clearing of ramoops
From: Kees Cook <keescook@chromium.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:17 PM, Liu ShuoX <shuox.liu@intel.com> wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> In case that ramoops_init_przs failed, max_dump_cnt won't be reset to
> zero in error handle path.
>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>  fs/pstore/ram.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 6f96d8c..522e530 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -326,6 +326,7 @@ static void ramoops_free_przs(struct ramoops_context
> *cxt)
>         for (i = 0; !IS_ERR_OR_NULL(cxt->przs[i]); i++)
>                 persistent_ram_free(cxt->przs[i]);
>         kfree(cxt->przs);
> +       cxt->max_dump_cnt = 0;
>  }
>   static int ramoops_init_przs(struct device *dev, struct ramoops_context
> *cxt,
> @@ -350,7 +351,7 @@ static int ramoops_init_przs(struct device *dev, struct
> ramoops_context *cxt,
>                              GFP_KERNEL);
>         if (!cxt->przs) {
>                 dev_err(dev, "failed to initialize a prz array for
> dumps\n");
> -               return -ENOMEM;
> +               goto fail_prz;

This will have no effect. If cxt->przs == NULL, ramoops_free_przs will
immediately exit too, not hitting your max_dump_cnt = 0 change.
Perhaps move the =0 in that function to the top before the check and
return?

>         }
>         for (i = 0; i < cxt->max_dump_cnt; i++) {
> @@ -508,7 +509,6 @@ fail_buf:
>         kfree(cxt->pstore.buf);
>  fail_clear:
>         cxt->pstore.bufsize = 0;
> -       cxt->max_dump_cnt = 0;
>  fail_cnt:
>         kfree(cxt->fprz);
>  fail_init_fprz:
> --
> 1.8.3.2
>

Otherwise,  yes, once fixed, this clean-up looks good -- it keeps the
variable initialization and cleanup all in ramoops_init_przs() which
is how it should be.

Thanks!

-Kees


-- 
Kees Cook
Chrome OS Security
