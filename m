Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LASO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 13:14:59 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36425 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3LASO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 13:14:56 -0500
Message-ID: <529B7C8D.7060101@gmail.com>
Date: Sun, 01 Dec 2013 20:14:37 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, Pavel Machek <pavel@ucw.cz>
CC: =?UTF-8?B?UGFsaSBSb2jDoQ==?= <pali.rohar@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?0JjQstCw0LnQu9C+INCU?= <freemangordon@abv.bg>, sre@ring0.de,
        omar.ramirez@copitl.com, tony@atomide.com, felipe.contreras@gmail.com,
        s-anna@ti.com, nm@ti.com, ohad@wizery.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not
 a security problem
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl> <20131130220553.GA1901@kroah.com> <20131130225822.GA26031@amd.pavel.ucw.cz> <201312011041.40071@pali> <1385891913.11457.2.camel@Nokia-N900> <20131201121006.GA26072@amd.pavel.ucw.cz> <20131201122756.GH5443@mwanda>
In-Reply-To: <20131201122756.GH5443@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01.12.2013 14:27, Dan Carpenter wrote:
> On Sun, Dec 01, 2013 at 01:10:06PM +0100, Pavel Machek wrote:
>> diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
>> index 1aa4a3f..a8e86cf 100644
>> --- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
>> +++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
>> @@ -258,7 +258,17 @@ err:
>>   /* This function maps kernel space memory to user space memory. */
>>   static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
>>   {
>> -	u32 status;
>> +	int status;
>> +	struct omap_dsp_platform_data *pdata =
>> +	    omap_dspbridge_dev->dev.platform_data;
>> +	unsigned long start = vma->vm_pgoff << PAGE_SHIFT;
>> +		
>> +	if (start < pdata->phys_mempool_base)
>> +		return -EINVAL;
>> +
>> +	if (vma->vm_end - vma->vm_start + (start - pdata->phys_mempool_base)
>> +	    > pdata->phys_mempool_size)
> This test is vulnerable to integer overflows if you pick a very high
> value for start.  Consider using the vm_iomap_memory() helper function
> instead of calling remap_pfn_range() directly.  Commit 7314e613d5ff
> ('Fix a few incorrectly checked [io_]remap_pfn_range() calls') has an
> example of how the conversion works.
>
> regards,
> dan carpenter
>
Dan,

If that one looks fine, I'll send a correctly formatted patch.

Pavel - feel free you to do it, I don't want to "steal" your bug :) .

Patch tested with Maemo5 on n900:

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c 
b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 1aa4a3f..2d500ea 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -258,8 +258,9 @@ err:
  /* This function maps kernel space memory to user space memory. */
  static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
  {
-    u32 status;
-
+    struct omap_dsp_platform_data *pdata =
+        omap_dspbridge_dev->dev.platform_data;
+
      /* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
      vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

@@ -268,13 +269,9 @@ static int bridge_mmap(struct file *filp, struct 
vm_area_struct *vma)
          vma->vm_start, vma->vm_end, vma->vm_page_prot,
          vma->vm_flags);

-    status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-                 vma->vm_end - vma->vm_start,
-                 vma->vm_page_prot);
-    if (status != 0)
-        status = -EAGAIN;
-
-    return status;
+    return vm_iomap_memory(vma,
+                   pdata->phys_mempool_base,
+                   pdata->phys_mempool_size);
  }

  static const struct file_operations bridge_fops = {





