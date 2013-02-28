Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917Ab3B1WRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:17:31 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53441 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3B1WR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:17:29 -0500
Message-ID: <512FD775.40206@suse.cz>
Date: Thu, 28 Feb 2013 23:17:25 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Gaohuai Han <hangaohuai@huawei.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [ 47/53] dca: check against empty dca_domains list before unregister
 provider
References: <20130226235619.844721947@linuxfoundation.org> <20130226235624.751198592@linuxfoundation.org> <512FD486.6030804@suse.cz>
In-Reply-To: <512FD486.6030804@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/mixed;
 boundary="------------090908020203060800000408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090908020203060800000408
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

On 02/28/2013 11:04 PM, Jiri Slaby wrote:
> On 02/27/2013 12:58 AM, Greg Kroah-Hartman wrote:
>> 3.0-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Maciej Sosnowski <maciej.sosnowski@intel.com>
>>
>> commit c419fcfd071cf34ba00f9f65282583772d2655e7 upstream.
>>
>> When providers get blocked unregister_dca_providers() is called ending up
>> with dca_providers and dca_domain lists emptied. Dca should be prevented from
>> trying to unregister any provider if dca_domain list is found empty.
>>
>> Reported-by: Jiang Liu <jiang.liu@huawei.com>
>> Tested-by: Gaohuai Han <hangaohuai@huawei.com>
>> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
>> Signed-off-by: Dan Williams <djbw@fb.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> ---
>>  drivers/dca/dca-core.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> --- a/drivers/dca/dca-core.c
>> +++ b/drivers/dca/dca-core.c
>> @@ -409,6 +409,11 @@ void unregister_dca_provider(struct dca_
>>  
>>  	spin_lock_irqsave(&dca_lock, flags);
>>  
>> +	if (list_empty(&dca_domains)) {
>> +		raw_spin_unlock_irqrestore(&dca_lock, flags);
> 
> Hi, this is an incorrect backport. It should be spin_unlock_irqrestore
> obviously...

Fix attached.

-- 
js
suse labs

--------------090908020203060800000408
Content-Type: text/x-patch;
 name="dca-check-against-empty-dca_domains-list-before-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="dca-check-against-empty-dca_domains-list-before-fix.patch"

From: Jiri Slaby <jslaby@suse.cz>
Subject: dca: check against empty dca_domains list before unregister provider fix
Patch-mainline: no, submitted on 28th Feb 2013

In 3.0.67, commit 7a9a20ea77e7508c795dead9ab2f6c98a617762d (dca: check
against empty dca_domains list before unregister provider), upstream
commit c419fcfd071cf34ba00f9f65282583772d2655e7, added a fail path to
unregister_dca_provider. It added there also a call to
raw_spin_unlock_irqrestore. But in 3.0, the lock is not raw, so this
results in:
drivers/dca/dca-core.c: In function 'unregister_dca_provider':
drivers/dca/dca-core.c:413: warning: passing argument 1 of '_raw_spin_unlock_irqrestore' from incompatible pointer type

Fix it by calling spin_unlock_irqrestore properly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/dca/dca-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -410,7 +410,7 @@ void unregister_dca_provider(struct dca_
 	spin_lock_irqsave(&dca_lock, flags);
 
 	if (list_empty(&dca_domains)) {
-		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return;
 	}
 

--------------090908020203060800000408--
