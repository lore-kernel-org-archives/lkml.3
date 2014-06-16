Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaFPIpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:45:04 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:49789 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbaFPIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:45:00 -0400
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 04:44:59 EDT
X-LISTENER: [mailrelay1.bredband.net]
X-SENDER-IP: [92.33.28.242]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQBAC6pnlNcIRzy/2dsb2JhbAANTcQ/gxIBgSWEeAEBAQEDOEABEAsOCgkWDwkDAgECARsqBg0BBwEBiEOwGZ5wF452B4RDAQOlc4tq
X-IPAS-Result: ApQBAC6pnlNcIRzy/2dsb2JhbAANTcQ/gxIBgSWEeAEBAQEDOEABEAsOCgkWDwkDAgECARsqBg0BBwEBiEOwGZ5wF452B4RDAQOlc4tq
X-IronPort-AV: E=Sophos;i="5.01,485,1400018400"; 
   d="scan'208";a="680886977"
Message-ID: <539EA986.1090501@gaisler.com>
Date: Mon, 16 Jun 2014 10:23:34 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
CC: lugovskoy@dev.rtsoft.ru, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH 00/21] add and use devm_irq_of_parse_and_map()
References: <53997AF6.1040003@gaisler.com> <5399AE1B.1080301@gaisler.com> <5399F92B.50406@dev.rtsoft.ru>
In-Reply-To: <5399F92B.50406@dev.rtsoft.ru>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-12 21:02, Nikita Yushchenko wrote:
>>> Currently many device tree aware drivers use irq_of_parse_and_map() to
>>> get
>>> IRQ number and then devm_request_irq() to set up IRQ handler.
>>>
>>> This causes a problem for exit path and for error paths: undo action for
>>> irq_of_parse_and_map() is irq_dispose_mapping() that must not be called
>>> while IRQ handler is defined, but devres moves free_irq() out of driver
>>> so driver does not have safe place to call irq_dispose_mapping().
>>>
>>> So many drivers do not call irq_dispose_mapping() at all, others call it
>>> while IRQ handler is defined (which is incorrect and causes error
>>> messages
>>> in logs), even others refuse to use devres for managing IRQ handlers.
>>>
>>> This patchset adds devres version of irq_of_parse_and_map(), and updates
>>> in-tree users of both devres and irq_of_parse_and_map() to use
>>> devm_irq_of_parse_and_map() instead.
>>
>>
>> SPARC does not use OF_IRQ and has a different implementation of
>> irq_of_parse_and_map than the one in drivers/of/irq.c. All code
>> converted from irq_of_parse_and_map to devm_irq_of_parse_and_map in this
>> patch set will be unlinkable for SPARC. This includes SPI in general and
>> many drivers that are used for SPARC (of which several are currently
>> only used on SPARC platforms).
>
> Can this be fixed by adding a copy of devm_irq_of_parse_and_map() to
> arch/sparc/kernel/of_device_common.c ?

Not a copy of the version in irq.c no. On SPARC, IRQ_DOMAIN is not 
selected in general.

However, there is no technical problem that I can see with having a 
SPARC version of devm_irq_of_parse_and_map that just calls 
irq_of_parse_and_map as there are no mappings that needs to be disposed 
of. (The empty dummy for irq_dispose_mapping is used if any 
irq_dispose_mapping calls are made from drivers).

Best regards,
Andreas Larsson
