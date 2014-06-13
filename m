Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaFMCZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:25:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:41752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaFMCZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,468,1400050800"; 
   d="scan'208";a="527732909"
Message-ID: <539A60FC.1050301@intel.com>
Date: Fri, 13 Jun 2014 10:25:00 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com> <53996152.2000407@intel.com> <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月13日 05:17, David Rientjes wrote:
> On Thu, 12 Jun 2014, Lan Tianyu wrote:
> 
>> The retry time is set by randomly and not accurate because don't know
>> when EC will work normally. Set the retry time to 5 just in order to
>> make sure battery driver probing sucessfully every time,
>>
> 
> Ok, I was hoping to avoid the excessive wait if it will never actually 
> succeed

Ok. The battery driver has used async init and so this will not affect
the speed of boot up.

> but I assume there's some evidence that it can succeed after 40ms, 
> 60ms, etc.  Please consider the following instead:
> 
> 	for (i = 0; i < 5; i++) {
> 		/* Comment on why we need a delay in between retries */
> 		if (i)
> 			msleep(20);
> 		result = acpi_battery_update(battery, false);
> 		if (!result)
> 			break;
> 	}
> 

How about this?

-       result = acpi_battery_update(battery, false);
-       if (result)
+
+       /*
+        * Some machines'(E,G Lenovo Z480) ECs are not stable
+        * during boot up and this causes battery driver fails to be
+        * probed due to failure of getting battery information
+        * from EC sometimes. After several retries, the operation
+        * may work. So add retry code here and 20ms sleep between
+        * every retries.
+        */
+       while (acpi_battery_update(battery, false) && retry--)
+               msleep(20);
+       if (!retry) {
+               result = -ENODEV;
                goto fail;
+       }
+




-- 
Best regards
Tianyu Lan
