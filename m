Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaA2PFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:05:47 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43742 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaA2PFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:05:46 -0500
Message-ID: <52E918C9.7030408@linux.vnet.ibm.com>
Date: Wed, 29 Jan 2014 16:05:45 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.13: BUG: unable to handle kernel paging request at 00000000b4343e88
References: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee> <20140121141037.f76dba61212c5597ff733207@linux-foundation.org> <alpine.SOC.1.00.1401221731150.3033@math.ut.ee> <52E26EF3.1090901@linux.vnet.ibm.com> <alpine.SOC.1.00.1401242249540.16252@math.ut.ee> <52E68111.6010005@linux.vnet.ibm.com> <alpine.SOC.1.00.1401280832500.5459@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1401280832500.5459@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012915-8372-0000-0000-000008786867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.01.2014 07:33, Meelis Roos wrote:
>>>>>> It looks like gcov exploded when running a module's constructors or
>>>>>> init function, but I'm unable to work out which module it was :(
>>>>> [...]
>>>>>
>>>>>> Maybe it's tg3.
>>>>>>
>>>>>> Could you add `ignore_loglevel' to the kernel boot parameters?  That
>>>>>> should make all pr_debug()s come out and they include the module's
>>>>>> name.
>>>>
>>>> I'm not sure if this related, but all 3 kernel logs consistently contain
>>>> this error message:
>>>>
>>>>> [    0.617401] gcov: could not create file
>>>>
>>>> which should only be shown in case of severe out-of-memory situations or
>>>> duplicate object file names.
>>>>
>>>> Could you retry with the following patch applied (2 times if possible)
>>>> and send dmesg output?
>>>
>>> This seems to be relevant - now there is a reproducible crash during the 
>>> printk. Captured end of the backtrace from HP ILO as image, attached. 
>>> This is reproducible.
>>
>> Ok, that's a lead. It appears that gcov-kernel receives gcov_info
>> structures in an unexpected format. Based on your previous dmesg output,
>> your kernel was compiled using gcc 4.7.2 which gcov-kernel should be able
>> to handle just fine. Could you please try out this debugging patch
>> (replacing the previous one)? Output will likely be quite verbose, so you
>> might consider using log_buf_len=1M or similar as kernel parameter.
> 
> I do not get very far - it still crashes on startuo. PNG attached.

I tried to reproduce this behavior a couple of times with no success.
Could you post your kernel configuration? I've also modified the
debugging patch to ensure that the gcov_info structure passed to
gcov_init() is no longer accessed beyond displaying the first 64
bytes. If you could apply this and send dmesg output, this might
hopefully provide a clue as to why the kernel cannot handle these
data structures correctly.

diff -Naurp a/kernel/gcov/base.c b/kernel/gcov/base.c
--- a/kernel/gcov/base.c
+++ b/kernel/gcov/base.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/printk.h>
 #include "gcov.h"

 static int gcov_events_enabled;
@@ -31,6 +32,10 @@ void __gcov_init(struct gcov_info *info)
 {
 	static unsigned int gcov_version;

+	pr_warn("__gcov_init(%p): enter\n", info);
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_ADDRESS, 16, 4, info,
+		       64, true);
+	return;
 	mutex_lock(&gcov_lock);
 	if (gcov_version == 0) {
 		gcov_version = gcov_info_version(info);
diff -Naurp a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3003,8 +3003,11 @@ static void do_mod_ctors(struct module *
 #ifdef CONFIG_CONSTRUCTORS
 	unsigned long i;

-	for (i = 0; i < mod->num_ctors; i++)
+	for (i = 0; i < mod->num_ctors; i++) {
+		pr_warn("Calling mod(%s)->ctors[%ld]=%p\n", mod->name, i,
+			mod->ctors[i]);
 		mod->ctors[i]();
+	}
 #endif
 }

