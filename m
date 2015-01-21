Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbbAUOII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:08:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbbAUOIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:08:02 -0500
Date: Wed, 21 Jan 2015 15:08:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Bin <huawei.libin@huawei.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, xiexiuqi@huawei.com
Subject: Re: [PATCH 2/2] livepatch: disable/enable_patch manners for
 interdependent patches
In-Reply-To: <1421831262-27869-3-git-send-email-huawei.libin@huawei.com>
Message-ID: <alpine.LNX.2.00.1501211506420.10817@pobox.suse.cz>
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com> <1421831262-27869-3-git-send-email-huawei.libin@huawei.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Li Bin wrote:

> for disable_patch:
> The patch is unallowed to be disabled if one patch after has
> dependencies with it and has been enabled.
> 
> for enable_patch:
> The patch is unallowed to be enabled if one patch before has
> dependencies with it and has been disabled.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>  kernel/livepatch/core.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 7861ed2..a12a31c 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -114,6 +114,21 @@ static bool klp_is_patch_registered(struct klp_patch *patch)
>  	return false;
>  }
>  
> +static bool klp_func_in_patch(struct klp_func *kfunc, struct klp_patch *patch)
> +{
> +	struct klp_object *obj;
> +	struct klp_func *func;
> +
> +	for (obj = patch->objs; obj->funcs; obj++) {
> +		for (func = obj->funcs; func->old_name; func++) {
> +			if (kfunc->old_addr == func->old_addr) {
> +				return true;
> +			}
> +		}
> +	}
> +	return false;
> +}
> +
>  static bool klp_initialized(void)
>  {
>  	return klp_root_kobj;
> @@ -466,8 +481,31 @@ unregister:
>  static int __klp_disable_patch(struct klp_patch *patch)
>  {
>  	struct klp_object *obj;
> +	struct klp_patch *temp;
> +	struct klp_func *func;
>  	int ret;
>  
> +	/*
> +	 * the patch is unallowed to be disabled if one patch
> +	 * after has dependencies with it and has been enabled.
> +	 */
> +	for (temp = list_next_entry(patch, list);
> +			&temp->list != &klp_patches;
> +			temp = list_next_entry(temp, list)) {
> +		if (temp->state != KLP_ENABLED)
> +			continue;
> +
> +		for (obj = patch->objs; obj->funcs; obj++) {
> +			for (func = obj->funcs; func->old_name; func++) {
> +				if (klp_func_in_patch(func, temp)) {
> +					pr_err("this patch depends on '%s', please disable it firstly\n",
> +						   temp->mod->name);
> +					return -EBUSY;
> +				}
> +			}
> +		}
> +	}
> +
>  	pr_notice("disabling patch '%s'\n", patch->mod->name);
>  
>  	for (obj = patch->objs; obj->funcs; obj++) {
> @@ -519,11 +557,33 @@ EXPORT_SYMBOL_GPL(klp_disable_patch);
>  static int __klp_enable_patch(struct klp_patch *patch)
>  {
>  	struct klp_object *obj;
> +	struct klp_patch *temp;
> +	struct klp_func *func;
>  	int ret;
>  
>  	if (WARN_ON(patch->state != KLP_DISABLED))
>  		return -EINVAL;
>  
> +	/*
> +	 * the patch is unallowed to be enabled if one patch
> +	 * before has dependencies with it and has been disabled.
> +	 */
> +	for (temp = list_first_entry(&klp_patches, struct klp_patch, list);
> +			temp != patch; temp = list_next_entry(temp, list)) {
> +		if (temp->state != KLP_DISABLED)
> +			continue;
> +
> +		for (obj = patch->objs; obj->funcs; obj++) {
> +			for (func = obj->funcs; func->old_name; func++) {
> +				if (klp_func_in_patch(func, temp)) {
> +					pr_err("this patch depends on '%s', please enable it firstly\n",
> +						   temp->mod->name);
> +					return -EBUSY;

By this you limit the definition of the patch inter-dependency to just 
symbols. But that's not the only way how patches can depend on it other -- 
the dependency can be semantical.

-- 
Jiri Kosina
SUSE Labs
