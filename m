Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3FLRlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:41:18 -0400
Received: from smtp5.ono.com ([62.42.230.183]:38261 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752711Ab3FLRlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:41:17 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 13:41:16 EDT
Message-ID: <51B8B153.40100@ono.com>
Date: Wed, 12 Jun 2013 19:35:15 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Thunderbird/22.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Accessing more than 2GB of memory with a 32 bit kernel
References: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com>
In-Reply-To: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 06:54 PM, Simon Brown wrote:
> Hello,
>
> For the sake of an old prototype peripheral I'm using a non PAE 32 bit
> x86 kernel and I'm having trouble accessing memory above 2 GB. The
> system has 4GB installed and all is well with a PAE kernel.
>

I have also 3 or 4 32-bit boxes running with more than 2Gb, I will try to
give you some ideas...

> I'm obviously expecting to lose some memory due to memory mapped devices
> but I wasn't expecting to lose 2GB. Instead I'm suspecting a BIOS bug.
> The system reports:
> free -m
>               total       used       free     shared    buffers
>               cached
> Mem:          2012        491       1521          0         40
> 277
>
> The mtrr table looked odd so I enabled sanitisation:
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 2GB, range: 2GB, type UC
> [    0.000000] reg 1, base: 0GB, range: 4GB, type WB
> [    0.000000] reg 2, base: 4GB, range: 2GB, type WB
> [    0.000000] total RAM covered: 4096M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 2
> lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 1, base: 4GB, range: 2GB, type WB
>
> I don't understand the gap in the new table.
>

MTRR is set initially like:
- 4GB at address 0x, from which the last 2GB are unusable = 2GB cacheable
- 2GB more starting at address 4GB, normally cacheable

After the cleanup, the 4-2 part is cleaned and left as just 2:
- 2GB at 0
- a hole from 2GB to 4GB
- 2GB at 4Gb

It looks like your mobo BIOS maps the second GB pair up from address 4GB,
so you can not use them without PAE. If you find an option
in your BIOS to force it to map them under 4GB, the a normal kernel
with CONFIG_HIGHMEM4G=y will see it.
Look in BIOS for something like 'endable/disable continous/discrete mtrr'
or 'harware memory hole' or something like that.

> The motherboard is an Asus P5K with an Intel® P35 chipset. I'm using the
> ubuntu lucid kernel (2.6.32) but the problem is also present with the
> ubuntu precise kernel.
> I'm at the limit of my understanding, can anyone advise how to debug
> further?
>
-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
