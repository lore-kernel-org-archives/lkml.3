Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3GJMgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:36:16 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64769 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3GJMgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:36:15 -0400
Message-ID: <51DD553B.1080701@intel.com>
Date: Wed, 10 Jul 2013 13:36:11 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: uefi boot hang (bisected)
References: <51DD00DB.3010107@redhat.com>
In-Reply-To: <51DD00DB.3010107@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/13 07:36, Dave Young wrote:
> Another problem is: With this patch applied I tried noefi boot, but
> kernel paniced, looks like efivar_init depends on efi runtime. Below
> patches works for me about noefi boot though I'm not sure if it's a
> right fix, please review.

It makes more sense to check in efivars.c, since none of that file can
function without runtime serivces.

Could you try the following patch?

---

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 8bd1bb6..8a7432a 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -583,6 +583,9 @@ int efivars_sysfs_init(void)
 	struct kobject *parent_kobj = efivars_kobject();
 	int error = 0;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
 	/* No efivars has been registered yet */
 	if (!parent_kobj)
 		return 0;
