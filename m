Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab3GDGgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:36:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36883 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3GDGgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:36:13 -0400
X-Spam-Score: -100.8
Message-ID: <51D517A7.6030908@asianux.com>
Date: Thu, 04 Jul 2013 14:35:19 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <20130704011221.GA11230@kroah.com> <51D4D4A0.6080401@asianux.com> <1372903390.22688.139.camel@gandalf.local.home> <51D4D9A4.3020402@gmail.com> <1372904975.22688.142.camel@gandalf.local.home> <51D4E133.2010201@gmail.com> <1372907201.22688.147.camel@gandalf.local.home> <51D4EB7D.2020809@gmail.com> <20130704040859.GA2869@kroah.com> <51D4FF17.4040503@asianux.com> <20130704061204.GA12148@kroah.com>
In-Reply-To: <20130704061204.GA12148@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 02:12 PM, Greg KH wrote:
> On Thu, Jul 04, 2013 at 12:50:31PM +0800, Chen Gang wrote:
>> On 07/04/2013 12:08 PM, Greg KH wrote:
>>>>> config COMPILE_TEST
>>>>>        bool "Compile also drivers which will not load"
>>>>>        default n
>>> This has _nothing_ to do with asm-generic, sorry.  Please don't confuse
>>> the issue.
>>
>> But when I choose allmodconfig, then "COMPILE_TEST=y". this may allow a
>> module to compile under the architectures which no related HW support.
>>
>> When cause compiling issue (HW not support), it is not module's issue,
>> we can not 'fix' module by force, and it is not architecture's issue,
>> either.
>>
>> So we have to look for who has duty for this issue. At least now, it
>> seems only 'asm-generic' can be qualified to play this unlucky role.
> 
> You seem to not understand what asm-generic is, or does, or I still do
> not understand what you are proposing.
> 

Maybe both/neither of us.  :-)

> Please send a patch showing what you are trying to do here, so that we
> can properly understand.
> 

Please help to check the patch below, thanks.

--------------------------patch begin----------------------------------

'asm-generic' need provide necessary configuration checking, if can't
pass checking, 'asm-generic' shouldn't implement it.

For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
let it pass configuration checking, and provide related dummy contents
for it.

Part of 'COMPLE_TEST' help contents in "init/Kconfig":

  "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."

One sample for using 'COMPILE_TEST':

  'PTP_1588_CLOCK_PCH' in drivers/ptp/Kconfig, which need depend on 'HAS_IOMEM'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/asm-generic/io.h |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d5afe96..301ce80 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -303,13 +303,18 @@ static inline void *phys_to_virt(unsigned long address)
 /*
  * Change "struct page" to physical address.
  *
- * This implementation is for the no-MMU case only... if you have an MMU
- * you'll need to provide your own definitions.
+ * This for the no-MMU, or no-IOMEM but still try to COMPILE_TEST cases.
+ * if you have an MMU and IOMEM, you'll need to provide your own definitions.
  */
-#ifndef CONFIG_MMU
+#if !defined(CONFIG_MMU) || \
+	(!defined(CONFIG_HAS_IOMEM) && defined(CONFIG_COMPILE_TEST))
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 {
+#if !defined(CONFIG_MMU)
 	return (void __iomem*) (unsigned long)offset;
+#else
+	return NULL;
+#endif
 }
 
 #define __ioremap(offset, size, flags)	ioremap(offset, size)
@@ -325,7 +330,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 static inline void iounmap(void __iomem *addr)
 {
 }
-#endif /* CONFIG_MMU */
+#endif /* !CONFIG_MMU || (!CONFIG_HAS_IOMEM && CONFIG_COMPILE_TEST) */
 
 #ifdef CONFIG_HAS_IOPORT
 #ifndef CONFIG_GENERIC_IOMAP
@@ -341,6 +346,15 @@ static inline void ioport_unmap(void __iomem *p)
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
+#elif defined(CONFIG_COMPILE_TEST) /* CONFIG_HAS_IOPORT */
+static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return NULL;
+}
+
+static inline void ioport_unmap(void __iomem *p)
+{
+}
 #endif /* CONFIG_HAS_IOPORT */
 
 #ifndef xlate_dev_kmem_ptr
-- 
1.7.7.6



--------------------------patch end------------------------------------


Thanks.
-- 
Chen Gang

-- 
Chen Gang
