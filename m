Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3KPJmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 04:42:19 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:61534 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3KPJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 04:42:12 -0500
Message-ID: <52873DE0.2090903@synopsys.com>
Date: Sat, 16 Nov 2013 15:11:52 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Pavel Roskin <proski@gnu.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: [PATCH 1/2] init/Kconfig: add option to disable kernel compression
References: <20131114083247.GB9687@ab42.lan> <1384418296-10374-1-git-send-email-christian.ruppert@abilis.com> <5284A422.7000208@synopsys.com> <20131115165750.GA14807@ab42.lan>
In-Reply-To: <20131115165750.GA14807@ab42.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 10:27 PM, Christian Ruppert wrote:
> On Thu, Nov 14, 2013 at 03:51:22PM +0530, Vineet Gupta wrote:
>> +CC Sam for Kconfig wisdom
>>
>> On 11/14/2013 02:08 PM, Christian Ruppert wrote:
>>> Some ARC users say they can boot faster with without kernel compression.
>>> This probably depends on things like the FLASH chip they use etc.
>>>
>>> Until now, kernel compression can only be disabled by removing "select
>>> HAVE_<compression>" lines from the architecture Kconfig.  So add the
>>> Kconfig logic to permit disabling of kernel compression.
>>>
>>> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
>>> ---
>>>  arch/arc/Kconfig |  2 ++
>>>  init/Kconfig     | 12 +++++++++++-
>>>  2 files changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
>>> index 91dbb27..3991f03 100644
>>> --- a/arch/arc/Kconfig
>>> +++ b/arch/arc/Kconfig
>>> @@ -21,6 +21,8 @@ config ARC
>>>  	select HAVE_ARCH_KGDB
>>>  	select HAVE_ARCH_TRACEHOOK
>>>  	select HAVE_IOREMAP_PROT
>>> +	select HAVE_KERNEL_UNCOMPRESSED
>>> +	select HAVE_KERNEL_GZIP
>>
>> Fine.
>>
>>>  	select HAVE_KPROBES
>>>  	select HAVE_KRETPROBES
>>>  	select HAVE_MEMBLOCK
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index 3ecd8a1..b1a6f92 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -97,6 +97,9 @@ config LOCALVERSION_AUTO
>>>  
>>>  	  which is done within the script "scripts/setlocalversion".)
>>>  
>>> +config HAVE_KERNEL_UNCOMPRESSED
>>> +        bool
>>> +
>>
>> This is good to avoid perturbing other arches.
>>
>>>  config HAVE_KERNEL_GZIP
>>>  	bool
>>>  
>>> @@ -118,7 +121,6 @@ config HAVE_KERNEL_LZ4
>>>  choice
>>>  	prompt "Kernel compression mode"
>>>  	default KERNEL_GZIP
>>> -	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
>>>  	help
>>>  	  The linux kernel is a kind of self-extracting executable.
>>>  	  Several compression algorithms are available, which differ
>>> @@ -137,6 +139,14 @@ choice
>>>  
>>>  	  If in doubt, select 'gzip'
>>>  
>>> +config KERNEL_UNCOMPRESSED
>>> +	bool "No compression"
>>> +	depends on HAVE_KERNEL_UNCOMPRESSED || ! ( HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4 )
>>> +	help
>>> +	  No compression at all. The kernel is huge but the compression and
>>> +	  decompression times are zero.
>>> +	  This is usually not what you want.
>>> +
>>>  config KERNEL_GZIP
>>>  	bool "Gzip"
>>>  	depends on HAVE_KERNEL_GZIP
>>>
>>
>> How about doing this part slightly differently (simpler IMO).
>> We add uncompressed as just another category rather than being a special case.
>>
>> Indicative diff against current mainline code
>>
>>  choice
>>         prompt "Kernel compression mode"
>>         default KERNEL_GZIP
>> -       depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA ||
>> HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
>> +       depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA ||
>> HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4 || HAVE_KERNEL_UNCOMPRESSED
>>
>>
>> +config KERNEL_UNCOMPRESSED
>> +       bool "No compression"
>> +       depends on HAVE_KERNEL_UNCOMPRESSED
>> +
> 
> Good Idea. I fixed this and sent the updated patch directly in reply to
> H. Peter's revert patch to avoid too much patch ping-pong:
> http://www.spinics.net/lists/kernel/msg1636397.html

I didn't see that patch in my mailbox. It needs an ACK from me anyways.

-Vineet

