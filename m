Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3GABlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:41:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39456 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3GABlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:41:17 -0400
X-Spam-Score: -106.8
Message-ID: <51D0DE09.4090702@asianux.com>
Date: Mon, 01 Jul 2013 09:40:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jeff Dike <jdike@addtoit.com>, Arnd Bergmann <arnd@arndb.de>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com> <51CAAE7C.9090003@nod.at> <51CAB556.4070700@asianux.com> <51CAB689.70008@nod.at> <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com> <51CABBDD.403@asianux.com> <51CABFAC.1040505@nod.at> <51CAC0D0.60505@asianux.com>
In-Reply-To: <51CAC0D0.60505@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 06:22 PM, Chen Gang wrote:
> On 06/26/2013 06:17 PM, Richard Weinberger wrote:
>> Am 26.06.2013 12:01, schrieb Chen Gang:
>>>> On 06/26/2013 05:48 PM, Geert Uytterhoeven wrote:
>>>>>> On Wed, Jun 26, 2013 at 11:38 AM, Richard Weinberger <richard@nod.at> wrote:
>>>>>>>>>>>>>> Since the API itself already contents the meaning: "return NULL means
>>>>>>>>>>>>>> the arch has no related io memory",
>>>>>> No, NULL means it could not map the I/O memory.
>>>>>>
>>>>
>>>> "it could not map the I/O memory" includes "has no related io memory".
>>>> So it is enough for our case.
>>>>
>>>>>>>>>>>>>> Why not define a generic dummy one in "include/asm-generic/io.h" instead
>>>>>>>>>>>>>> of "HAS_IOMEM" (which has already spread many various places, and also,
>>>>>>>>>>>>>> most of new drivers have to know about it).
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> e.g: in "include/asm-generic/io.h", if "CONFIG_HAS_IOMEM=n", define a
>>>>>>>>>>>>>> dummy ioremap() which return NULL ... (also need consider more details).
>>>>>>>>>>
>>>>>>>>>> Because we don't even want to build these drivers and not make them fail while
>>>>>>>>>> executing io memory related functions.
>>>>>> Indeed, it doesn't make sense to build drivers that cannot work.
>>>>>> And they may fail in a very bad way.
>>>>
>>>> That is our 'platform' guys feeling, not the 'module' guys, as
>>>> 'platform' guys, it is better to provide the choice to 'module' guys,
>>>> and let them decide by themselves, not forced by us.
>> FYI, this is my last reply to this thread.
>>
>> As Geert and I said, drivers which need io memory have to depend on HAS_IOMEM=y.
>> If an arch does not have io memory these drivers cannot work and therefore we don't
>> want them built.
> 

Hmm, if the modules select 'COMPILE_TEST', it is better to let asm-generic
support this features (at least, not forbid it)

So how about the diff below ?  ;-)

---------------------------diff begin-----------------------------------

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d5afe96..ede3775 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -303,13 +303,17 @@ static inline void *phys_to_virt(unsigned long address)
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
+	(!defined(CONFIG_HAS_IOMEM) && defined(COMPILE_TEST))
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 {
+#if !defined(CONFIG_MMU)
 	return (void __iomem*) (unsigned long)offset;
+#else
+	return NULL;
 }
 
 #define __ioremap(offset, size, flags)	ioremap(offset, size)
@@ -325,7 +329,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 static inline void iounmap(void __iomem *addr)
 {
 }
-#endif /* CONFIG_MMU */
+#endif /* !MMU || (!HAS_IOMEM && COMPILE_TEST) */
 
 #ifdef CONFIG_HAS_IOPORT
 #ifndef CONFIG_GENERIC_IOMAP

---------------------------diff end-------------------------------------

> It is really the time for stopping discussion, and thank you all for
> spending your time resources on this discussion.
> 
> Next, I will send related patch for it (also cc to you all).
> 
> 
> Thanks.
> 


-- 
Chen Gang
