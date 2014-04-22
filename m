Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaDVMqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:46:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:9748 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbaDVMqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:46:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,904,1389772800"; 
   d="scan'208";a="517220207"
Message-ID: <53566488.9030301@linux.intel.com>
Date: Tue, 22 Apr 2014 20:46:00 +0800
From: "Jin, Yao" <yao.jin@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linus.walleij@linaro.org, alan@linux.intel.com, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com> <20140422115123.GO30677@intel.com>
In-Reply-To: <20140422115123.GO30677@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mika, I will fix this warning.

On 2014/4/22 19:51, Mika Westerberg wrote:
> On Wed, Apr 16, 2014 at 08:05:59PM +0800, Jin Yao wrote:
>> A crash is triggered on the ASUS T100TA Baytrail-T because of a irq 
>> descriptor conflict. There are two gpio triggered acpi events in this
>> device, GPIO 6 and 18. These gpios are translated to irqs by calling
>> gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
>> irq_create_mapping will take care of allocating the irq descriptor, taking
>> the first available number starting from the given value (6 in our case).
>> The 0-15 are already reserved by legacy ISA code, so it gets the first
>> free irq descriptor which is number 16. The i915 driver also uses irq 16,
>> it loads later than gpio and crashes in probe.
>>
>> The bug is reported here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=68291
>>
>> The rootcause we know now is a low level irq issue. It needs a long term
>> solution to fix the issue in irq system.
>>
>> This patch changes the Baytrail GPIO driver to avoid the irq descriptor
>> conflict. It still uses the irq domain to allocate irq descriptor but start
>> from a predefined irq base number (256) to avoid the conflict.
>>
>> Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
> 
> I'm getting following warnings when compiling this:
> 
> drivers/pinctrl/pinctrl-baytrail.c: In function ‘byt_gpio_probe’:
> drivers/pinctrl/pinctrl-baytrail.c:512:4: warning: passing argument 3 of
> ‘kstrtol’ from incompatible pointer type [enabled by default]
>     ret = kstrtol(range->name, 10, &i);
>     ^
> In file included from drivers/pinctrl/pinctrl-baytrail.c:22:0:
> include/linux/kernel.h:301:32: note: expected ‘long int *’ but argument is
> of type ‘int *’
>  static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
> 
