Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3KUNeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:34:02 -0500
Received: from multi.imgtec.com ([194.200.65.239]:30113 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3KUNd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:33:59 -0500
Message-ID: <528E0BBA.6050002@imgtec.com>
Date: Thu, 21 Nov 2013 13:33:46 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: unflatten_and_copy: handle NULL initial_boot_params
References: <1384865892-28659-1-git-send-email-james.hogan@imgtec.com> <20131121123927.34EAEC40A2C@trevor.secretlab.ca>
In-Reply-To: <20131121123927.34EAEC40A2C@trevor.secretlab.ca>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_21_13_33_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/13 12:39, Grant Likely wrote:
> On Tue, 19 Nov 2013 12:58:12 +0000, James Hogan <james.hogan@imgtec.com> wrote:
>> Check whether initial_boot_params is NULL before dereferencing it in
>> unflatten_and_copy_device_tree() for the case where no device tree is
>> available but the arch can still boot to a minimal usable system without
>> it.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-arch@vger.kernel.org
>> ---
>>  drivers/of/fdt.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index 2fa024b97c43..ac4983955e6d 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -922,8 +922,14 @@ void __init unflatten_device_tree(void)
>>   */
>>  void __init unflatten_and_copy_device_tree(void)
>>  {
>> -	int size = __be32_to_cpu(initial_boot_params->totalsize);
>> -	void *dt = early_init_dt_alloc_memory_arch(size,
>> +	int size;
>> +	void *dt;
>> +
>> +	if (!initial_boot_params)
>> +		return;
> 
> Worth logging a message for those who can obtain the kernel log
> buffer?

Yes, sounds reasonable (especially since for Meta the platform name detected from DT doesn't get logged in this case and I still get the console out via JTAG probe).
I'll post a v2 adding this:

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ac4983955e6d..758b4f8b30b7 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -925,8 +925,10 @@ void __init unflatten_and_copy_device_tree(void)
 	int size;
 	void *dt;
 
-	if (!initial_boot_params)
+	if (!initial_boot_params) {
+		pr_warn("No valid device tree found, continuing without\n");
 		return;
+	}
 
 	size = __be32_to_cpu(initial_boot_params->totalsize);
 	dt = early_init_dt_alloc_memory_arch(size,

> Otherwise:
> 
> Acked-by: Grant Likely <grant.likely@linaro.org>

Thanks
James

