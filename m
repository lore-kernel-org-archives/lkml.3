Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab3J1PMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:12:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab3J1PMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:12:22 -0400
Message-ID: <526E7EC2.4070008@redhat.com>
Date: Mon, 28 Oct 2013 11:12:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk, x86@kernel.org,
        hmh@hmh.eng.br, andi@firstfloor.org
Subject: Re: [PATCH] x86, microcode, Fix long microcode load time when firmware
 file is missing [v2]
References: <1382961968-20067-1-git-send-email-prarit@redhat.com> <s5heh75wi4h.wl%tiwai@suse.de>
In-Reply-To: <s5heh75wi4h.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/2013 11:05 AM, Takashi Iwai wrote:
> At Mon, 28 Oct 2013 08:06:08 -0400,
> Prarit Bhargava wrote:
>>
>> If no firmware is found on the system that matches the processor, the
>> microcode module can take hours to load.  For example on recent kernels
>> when loading the microcode module on an Intel system:
>>
>> [  239.532116] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x413
>> [  299.693447] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x413
>> [  359.821972] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x413
>> [  419.960263] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x413
>> [  480.090024] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x413
>> ...
>> [ 2825.151364] microcode: CPU43 sig=0x306e4, pf=0x1, revision=0x413
>> [ 2885.280863] microcode: CPU44 sig=0x306e4, pf=0x1, revision=0x413
>> [ 2945.410719] microcode: CPU45 sig=0x306e4, pf=0x1, revision=0x413
>> [ 3005.540541] microcode: CPU46 sig=0x306e4, pf=0x1, revision=0x413
>> [ 3065.670405] microcode: CPU47 sig=0x306e4, pf=0x1, revision=0x413
>> ...
>> etc.
>>
>> Similarly there is a 60 second "hang" when loading the AMD module, which
>> isn't as bad as the Intel situation.  This is because the AMD microcode
>> loader only attempts to look for the firmware on the boot_cpu and, if
>> found, loads the microcode on each cpu.  This patch does the same for the
>> Intel microcode, and it obviously peeds up the module load if there is no
>> microcode update available.
>>
>> After making this change, the old microcode loading code and the new
>> loading code can be cleaned up and unified in the core code.
>>
>> This patch was tested on several systems (both AMD and Intel) with the
>> microcode in place and without, as well as on several different OSes.
> 
> Does simply disabling CONFIG_FW_LOADER_USER_HELPER work without your
> patch?
> 
> If yes, it's an infamous udev issue.  An easier solution would be to
> create a function that does only the direct f/w loading without
> usermode helper, and call it in the microcode driver.

Thanks Takashi, I thought about doing something similar but didn't know if
!waiting was a good idea here.  I'll give this a shot.

P.

> 
> An untested quick fix patch is attached below.
> 
> 
> Takashi
> 
> ---
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index af99f71..539a01a 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -430,7 +430,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
>  	if (c->x86 >= 0x15)
>  		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
>  
> -	if (request_firmware(&fw, (const char *)fw_name, device)) {
> +	if (request_firmware_direct(&fw, (const char *)fw_name, device)) {
>  		pr_err("failed to load file %s\n", fw_name);
>  		goto out;
>  	}
> diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
> index 5fb2ceb..a276fa7 100644
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -278,7 +278,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device,
>  	sprintf(name, "intel-ucode/%02x-%02x-%02x",
>  		c->x86, c->x86_model, c->x86_mask);
>  
> -	if (request_firmware(&firmware, name, device)) {
> +	if (request_firmware_direct(&firmware, name, device)) {
>  		pr_debug("data file %s load failed\n", name);
>  		return UCODE_NFOUND;
>  	}
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 10a4467..f30f381 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1054,7 +1054,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
>  /* called from request_firmware() and request_firmware_work_func() */
>  static int
>  _request_firmware(const struct firmware **firmware_p, const char *name,
> -		  struct device *device, bool uevent, bool nowait)
> +		  struct device *device, bool uevent, bool nowait, bool fallback)
>  {
>  	struct firmware *fw;
>  	long timeout;
> @@ -1086,7 +1086,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  		}
>  	}
>  
> -	if (!fw_get_filesystem_firmware(device, fw->priv))
> +	if (!fw_get_filesystem_firmware(device, fw->priv) && fallback)
>  		ret = fw_load_from_user_helper(fw, name, device,
>  					       uevent, nowait, timeout);
>  
> @@ -1134,12 +1134,25 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>  
>  	/* Need to pin this module until return */
>  	__module_get(THIS_MODULE);
> -	ret = _request_firmware(firmware_p, name, device, true, false);
> +	ret = _request_firmware(firmware_p, name, device, true, false, true);
>  	module_put(THIS_MODULE);
>  	return ret;
>  }
>  EXPORT_SYMBOL(request_firmware);
>  
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
> +int request_firmware_direct(const struct firmware **firmware_p,
> +			    const char *name, struct device *device)
> +{
> +	int ret;
> +	__module_get(THIS_MODULE);
> +	ret = _request_firmware(firmware_p, name, device, true, false, false);
> +	module_put(THIS_MODULE);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(request_firmware_direct);
> +#endif
> +
>  /**
>   * release_firmware: - release the resource associated with a firmware image
>   * @fw: firmware resource to release
> @@ -1173,7 +1186,7 @@ static void request_firmware_work_func(struct work_struct *work)
>  	fw_work = container_of(work, struct firmware_work, work);
>  
>  	_request_firmware(&fw, fw_work->name, fw_work->device,
> -			  fw_work->uevent, true);
> +			  fw_work->uevent, true, true);
>  	fw_work->cont(fw, fw_work->context);
>  	put_device(fw_work->device); /* taken in request_firmware_nowait() */
>  
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index e154c10..5952933 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -68,4 +68,11 @@ static inline void release_firmware(const struct firmware *fw)
>  
>  #endif
>  
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
> +int request_firmware_direct(const struct firmware **fw, const char *name,
> +			    struct device *device);
> +#else
> +#define request_firmware_direct	request_firmware
> +#endif
> +
>  #endif
