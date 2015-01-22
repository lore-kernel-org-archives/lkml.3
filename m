Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbbAVAnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:43:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11395 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAVAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:42:56 -0500
Message-ID: <54C04775.1070908@huawei.com>
Date: Thu, 22 Jan 2015 08:42:29 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, <live-patching@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <guohanjun@huawei.com>, <zhangdianfang@huawei.com>,
        <xiexiuqi@huawei.com>
Subject: Re: [PATCH 2/2] livepatch: disable/enable_patch manners for interdependent
 patches
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com> <1421831262-27869-3-git-send-email-huawei.libin@huawei.com> <alpine.LNX.2.00.1501211506420.10817@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1501211506420.10817@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 22:08, Jiri Kosina wrote:
> On Wed, 21 Jan 2015, Li Bin wrote:
> 
>> for disable_patch:
>> The patch is unallowed to be disabled if one patch after has
>> dependencies with it and has been enabled.
>>
>> for enable_patch:
>> The patch is unallowed to be enabled if one patch before has
>> dependencies with it and has been disabled.
>>
>> Signed-off-by: Li Bin <huawei.libin@huawei.com>
>> ---
>>  kernel/livepatch/core.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 60 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 7861ed2..a12a31c 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -114,6 +114,21 @@ static bool klp_is_patch_registered(struct klp_patch *patch)
>>  	return false;
>>  }
>>  
>> +static bool klp_func_in_patch(struct klp_func *kfunc, struct klp_patch *patch)
>> +{
>> +	struct klp_object *obj;
>> +	struct klp_func *func;
>> +
>> +	for (obj = patch->objs; obj->funcs; obj++) {
>> +		for (func = obj->funcs; func->old_name; func++) {
>> +			if (kfunc->old_addr == func->old_addr) {
>> +				return true;
>> +			}
>> +		}
>> +	}
>> +	return false;
>> +}
>> +
>>  static bool klp_initialized(void)
>>  {
>>  	return klp_root_kobj;
>> @@ -466,8 +481,31 @@ unregister:
>>  static int __klp_disable_patch(struct klp_patch *patch)
>>  {
>>  	struct klp_object *obj;
>> +	struct klp_patch *temp;
>> +	struct klp_func *func;
>>  	int ret;
>>  
>> +	/*
>> +	 * the patch is unallowed to be disabled if one patch
>> +	 * after has dependencies with it and has been enabled.
>> +	 */
>> +	for (temp = list_next_entry(patch, list);
>> +			&temp->list != &klp_patches;
>> +			temp = list_next_entry(temp, list)) {
>> +		if (temp->state != KLP_ENABLED)
>> +			continue;
>> +
>> +		for (obj = patch->objs; obj->funcs; obj++) {
>> +			for (func = obj->funcs; func->old_name; func++) {
>> +				if (klp_func_in_patch(func, temp)) {
>> +					pr_err("this patch depends on '%s', please disable it firstly\n",
>> +						   temp->mod->name);
>> +					return -EBUSY;
>> +				}
>> +			}
>> +		}
>> +	}
>> +
>>  	pr_notice("disabling patch '%s'\n", patch->mod->name);
>>  
>>  	for (obj = patch->objs; obj->funcs; obj++) {
>> @@ -519,11 +557,33 @@ EXPORT_SYMBOL_GPL(klp_disable_patch);
>>  static int __klp_enable_patch(struct klp_patch *patch)
>>  {
>>  	struct klp_object *obj;
>> +	struct klp_patch *temp;
>> +	struct klp_func *func;
>>  	int ret;
>>  
>>  	if (WARN_ON(patch->state != KLP_DISABLED))
>>  		return -EINVAL;
>>  
>> +	/*
>> +	 * the patch is unallowed to be enabled if one patch
>> +	 * before has dependencies with it and has been disabled.
>> +	 */
>> +	for (temp = list_first_entry(&klp_patches, struct klp_patch, list);
>> +			temp != patch; temp = list_next_entry(temp, list)) {
>> +		if (temp->state != KLP_DISABLED)
>> +			continue;
>> +
>> +		for (obj = patch->objs; obj->funcs; obj++) {
>> +			for (func = obj->funcs; func->old_name; func++) {
>> +				if (klp_func_in_patch(func, temp)) {
>> +					pr_err("this patch depends on '%s', please enable it firstly\n",
>> +						   temp->mod->name);
>> +					return -EBUSY;
> 
> By this you limit the definition of the patch inter-dependency to just 
> symbols. But that's not the only way how patches can depend on it other -- 
> the dependency can be semantical.

Yes, I agree with you. But I think the other dependencies such as semantical
dependency should be judged by the user, like reverting a patch from git repository.
Right?

Thanks,
	Li Bin

> 


