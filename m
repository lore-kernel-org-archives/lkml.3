Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaAQDwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:52:55 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:58771 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAQDwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:52:53 -0500
Message-ID: <52D8A8DB.4080809@huawei.com>
Date: Fri, 17 Jan 2014 11:51:55 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: <linux-acpi@vger.kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v2] ACPI: Fix acpi_evaluate_object() return value check
References: <1389922191-28664-1-git-send-email-wangyijing@huawei.com> <52D8A672.8070808@linaro.org>
In-Reply-To: <52D8A672.8070808@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
>> index dfff090..7ea00e5 100644
>> --- a/drivers/gpu/drm/i915/intel_acpi.c
>> +++ b/drivers/gpu/drm/i915/intel_acpi.c
>> @@ -35,7 +35,7 @@ static int intel_dsm(acpi_handle handle, int func)
>>  	union acpi_object params[4];
>>  	union acpi_object *obj;
>>  	u32 result;
>> -	int ret = 0;
> 
> The 'ret' is removed, but

Ah, it's my mistake, will updata it right now, thanks!

> 
>> +	acpi_status status;
>>  
>>  	input.count = 4;
>>  	input.pointer = params;
>> @@ -50,8 +50,8 @@ static int intel_dsm(acpi_handle handle, int func)
>>  	params[3].package.count = 0;
>>  	params[3].package.elements = NULL;
>>  
>> -	ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> -	if (ret) {
>> +	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> +	if (ACPI_FAILURE(status)) {
>>  		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
>>  		return ret;
> 
> you still use it here, so you should -EINVAL or something else here.

OK

> 
>>  	}
>> @@ -141,7 +141,8 @@ static void intel_dsm_platform_mux_info(void)
>>  	struct acpi_object_list input;
>>  	union acpi_object params[4];
>>  	union acpi_object *pkg;
>> -	int i, ret;
>> +	acpi_status status;
>>  
>> -	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> -	if (err) {
>> +	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> +	if (ACPI_FAILURE(status)) {
>>  		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
>>  		return err;
> 
> here too.

OK, thanks.

> 
>>  	}
>> @@ -134,7 +135,7 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
>>  	struct acpi_object_list input;
>>  	union acpi_object params[4];
>>  	union acpi_object *obj;
>> -	int err;
>> +	acpi_status status;
>>  
>>  	input.count = 4;
>>  	input.pointer = params;
>> @@ -148,8 +149,8 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
>>  	params[3].type = ACPI_TYPE_INTEGER;
>>  	params[3].integer.value = arg;
>>  
>> -	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> -	if (err) {
>> +	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> +	if (ACPI_FAILURE(status)) {
>>  		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
>>  		return err;
> 
> and here.

thanks.

> 
>>  	}
>> diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
>> index d51f45a..3c21f1b 100644
>> --- a/drivers/pci/pci-label.c
>> +++ b/drivers/pci/pci-label.c
>> @@ -213,7 +213,7 @@ dsm_get_label(acpi_handle handle, int func,
>>  	union acpi_object *obj;
>>  	int len = 0;
>>  
>> -	int err;
>> +	acpi_status status;
>>  
>>  	input.count = 4;
>>  	input.pointer = params;
>> @@ -228,8 +228,8 @@ dsm_get_label(acpi_handle handle, int func,
>>  	params[3].package.count = 0;
>>  	params[3].package.elements = NULL;
>>  
>> -	err = acpi_evaluate_object(handle, "_DSM", &input, output);
>> -	if (err)
>> +	status = acpi_evaluate_object(handle, "_DSM", &input, output);
>> +	if (ACPI_FAILURE(status))
>>  		return -1;
> 
> can we return specific error such as -EINVAL instead of hard code?

I will try to add some more useful debug info here. thanks!

> 
> Thanks
> Hanjun
> 
> .
> 


-- 
Thanks!
Yijing

