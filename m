Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaDDNAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:00:55 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:35835 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaDDNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <533EA2B0.7080703@monstr.eu>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
	<1396563423-30893-10-git-send-email-robherring2@gmail.com>
	<533EA2B0.7080703@monstr.eu>
Date: Fri, 4 Apr 2014 08:00:38 -0500
Message-ID: <CAL_JsqKFK8YDoODYKg5b8SmDzqdNSS6UvYr3_atzhcL2uR-=rA@mail.gmail.com>
Subject: Re: [PATCH 09/20] of/fdt: create common debugfs
From: Rob Herring <robherring2@gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 7:16 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 04/04/2014 12:16 AM, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Both powerpc and microblaze have the same FDT blob in debugfs feature.
>> Move this to common location and remove the powerpc and microblaze
>> implementations. This feature could become more useful when FDT
>> overlay support is added.
>>
>> This changes the path of the blob from "$arch/flat-device-tree" to
>> "device-tree/flat-device-tree".

[snip]

>> -#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
>> -static struct debugfs_blob_wrapper flat_dt_blob;
>> -
>> -static int __init export_flat_device_tree(void)
>> -{
>> -     struct dentry *d;
>> -
>> -     flat_dt_blob.data = initial_boot_params;
>> -     flat_dt_blob.size = initial_boot_params->totalsize;
>
> As I see even microblaze version was buggy.

How so?

> ...
>
>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index fa16a91..2085d47 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/string.h>
>>  #include <linux/errno.h>
>>  #include <linux/slab.h>
>> +#include <linux/debugfs.h>
>>
>>  #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
>>  #ifdef CONFIG_PPC
>> @@ -1084,4 +1085,27 @@ void __init unflatten_and_copy_device_tree(void)
>>       unflatten_device_tree();
>>  }
>>
>> +#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
>> +static struct debugfs_blob_wrapper flat_dt_blob;
>> +
>> +static int __init of_flat_dt_debugfs_export_fdt(void)
>> +{
>> +     struct dentry *d = debugfs_create_dir("device-tree", NULL);
>> +
>> +     if (!d)
>> +             return -ENOENT;
>> +
>> +     flat_dt_blob.data = initial_boot_params;
>> +     flat_dt_blob.size = fdt_totalsize(initial_boot_params);
>
> Have you tried to compile this?
>
> From my tests fdt_totalsize is not available for target just for host
> from libfdt.h
>
> drivers/of/fdt.c: In function 'of_flat_dt_debugfs_export_fdt':
> drivers/of/fdt.c:957:2: error: implicit declaration of function 'fdt_totalsize' [-Werror=implicit-function-declaration]

Ah, it needs to be re-ordered after the libfdt conversion when
libfdt.h gets added.

Rob
