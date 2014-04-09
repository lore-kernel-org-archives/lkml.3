Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbaDISuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:50:06 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:54277 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454AbaDISuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:50:03 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 14:50:03 EDT
Message-ID: <53459481.9020908@akamai.com>
Date: Wed, 09 Apr 2014 14:42:09 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "tony.luck@intel.com" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140409113552.GJ6529@pd.tnic>
In-Reply-To: <20140409113552.GJ6529@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 07:35 AM, Borislav Petkov wrote:
> On Fri, Apr 04, 2014 at 09:14:04PM +0000, Jason Baron wrote:
>> Add 'ie31200_edac' driver for the E3-1200 series of Intel processors. Driver
>> is based on the following E3-1200 specs:
>>
>> http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html
>> http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200v3-vol-2-datasheet.html
>>
>> I've tested this on bad memory hardware, and observed correlating bad reads
>> and uncorrected memory errors as reported by the driver.
>>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>  drivers/edac/Kconfig        |   7 +
>>  drivers/edac/Makefile       |   1 +
>>  drivers/edac/ie31200_edac.c | 540 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 548 insertions(+)
>>  create mode 100644 drivers/edac/ie31200_edac.c
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 878f090..27f44a1 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -186,6 +186,13 @@ config EDAC_I3200
>>  	  Support for error detection and correction on the Intel
>>  	  3200 and 3210 server chipsets.
>>  
>> +config EDAC_IE31200
>> +	tristate "Intel e312xx"
>> +	depends on EDAC_MM_EDAC && PCI && X86
>> +	help
>> +	  Support for error detection and correction on the Intel
>> +	  E3-1200 processor.
>> +
>>  config EDAC_X38
>>  	tristate "Intel X38"
>>  	depends on EDAC_MM_EDAC && PCI && X86
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index 4154ed6..c479a24 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -37,6 +37,7 @@ obj-$(CONFIG_EDAC_I82875P)		+= i82875p_edac.o
>>  obj-$(CONFIG_EDAC_I82975X)		+= i82975x_edac.o
>>  obj-$(CONFIG_EDAC_I3000)		+= i3000_edac.o
>>  obj-$(CONFIG_EDAC_I3200)		+= i3200_edac.o
>> +obj-$(CONFIG_EDAC_IE31200)		+= ie31200_edac.o
>>  obj-$(CONFIG_EDAC_X38)			+= x38_edac.o
>>  obj-$(CONFIG_EDAC_I82860)		+= i82860_edac.o
>>  obj-$(CONFIG_EDAC_R82600)		+= r82600_edac.o
>> diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
>> new file mode 100644
>> index 0000000..ae03d21
>> --- /dev/null
>> +++ b/drivers/edac/ie31200_edac.c
>> @@ -0,0 +1,540 @@
>> +/*
>> + * Intel E3-1200
>> + * Copyright (C) 2014 Jason Baron <jbaron@akamai.com>
>> + *
>> + * Support for the E3-1200 processor family. Heavily based on previous
>> + * Intel EDAC drivers.
> 
> Btw, remind me again why this isn't part of the sb_edac? AFAICT, the
> e3-12xx thing is a Sandybridge, right?
> 

So, I *think* that the E3-12xx processors cross microarchitectures.
So while E3-1270 is sandy bridge, the E3-1270 v3 is Haswell, and
the E3-1270 v2 is Ivy Bridge.

> Why not put it into sb_edac - it is small enough and if you're lucky,
> you might even share functionality?
> 

As far as I understand the sb_edac driver is decoding MCEs via a registration
function with the core MCE code.

However, we have a number of E3-12xx boxes, and we have not seen a MCE
generated on ue or ce errors.

Thanks,

-Jason




