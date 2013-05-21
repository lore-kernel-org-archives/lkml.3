Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3EUDQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:16:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14414 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3EUDQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:16:27 -0400
X-Spam-Score: -100.8
Message-ID: <519AE6D7.1090401@asianux.com>
Date: Tue, 21 May 2013 11:15:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
References: <5199B7D6.40907@asianux.com> <20130520091008.GB31359@mudshark.cambridge.arm.com>
In-Reply-To: <20130520091008.GB31359@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 05:10 PM, Will Deacon wrote:
> Hi Chen,
> 
> On Mon, May 20, 2013 at 06:42:46AM +0100, Chen Gang wrote:
>>
>> Add the extern variable 'screen_info' according to arm32 has done.
>>
>> The related error:
>>   drivers/video/console/vgacon.c:1305: undefined reference to `screen_info'
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/arm64/kernel/setup.c |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index add6ea6..1055992 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -374,3 +374,14 @@ const struct seq_operations cpuinfo_op = {
>>  	.stop	= c_stop,
>>  	.show	= c_show
>>  };
>> +
>> +#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
>> +struct screen_info screen_info = {
>> +	.orig_video_lines	= 30,
>> +	.orig_video_cols	= 80,
>> +	.orig_video_mode	= 0,
>> +	.orig_video_ega_bx	= 0,
>> +	.orig_video_isVGA	= 1,
>> +	.orig_video_points	= 8
>> +};
>> +#endif
> 
> I think it would be better if we added a something like
> CONFIG_HAVE_VGA_CONSOLE, which VGA_CONSOLE can then depend on. Architectures
> like x86 can then select the former, and we can remove the long list of
> architectures from the current option.
> 

I guess your meaning is:

  under arm64, actually, need not support 'VGA_CONSOLE', and 'screen_info' is useless.
  So better to define 'CONFIG_HAVE_VGA_CONSOLE' which 'VGA_CONSOLE' can depend on it, and in arm64, we do not define CONFIG_HAVE_VGA_CONSOLE.

Is it correct ?

If so, I recommend to add depend item for VGA_CONSOLE directly:

-------------------diff begin----------------------------------

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index bc922c4..b759157 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -6,7 +6,7 @@ menu "Console display driver support"
 
 config VGA_CONSOLE
 	bool "VGA text console" if EXPERT || !X86
-	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
+	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && !ARM64 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
 	default y
 	help
 	  Saying Y here will allow you to use Linux in text mode through a

-------------------diff end------------------------------------


Thanks.
-- 
Chen Gang

Asianux Corporation
