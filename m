Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3KSSI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:08:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44641 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3KSSIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:08:24 -0500
Message-ID: <528BA90D.5070009@infradead.org>
Date: Tue, 19 Nov 2013 10:08:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>, kmo@daterainc.com,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for Nov 15 (target_core_mod)
References: <20131115162455.b45631434f6417b221f2a4d5@canb.auug.org.au>	 <52865CB7.3070608@infradead.org> <1384804015.4307.11.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1384804015.4307.11.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/13 11:46, Nicholas A. Bellinger wrote:
> On Fri, 2013-11-15 at 09:41 -0800, Randy Dunlap wrote:
>> On 11/14/13 21:24, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Please do *not* add any v3.14 material to linux-next until after
>>> v3.13-rc1 is released.
>>>
>>> Changes since 20131114:
>>>
>>
>>
>> on i386:
>>
>>
>> ERROR: "percpu_ref_cancel_init" [drivers/target/target_core_mod.ko] undefined!
>> ERROR: "percpu_ref_kill_and_confirm" [drivers/target/target_core_mod.ko] undefined!
>> ERROR: "percpu_ref_init" [drivers/target/target_core_mod.ko] undefined!
>>
>>
>> Full randconfig file is attached.
>>
> 
> Mmmm, confirmed that lib/Makefile not including percpu-refcount.o in
> obj-y is the problem here..  (CC'ing Tejun + Kent).
> 
> Applying the following patch to target-pending/for-next now..
> 
> --nab
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index f3bb2cb..eaa946d 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>          bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
>          gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
>          bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
> -        percpu_ida.o
> +        percpu-refcount.o percpu_ida.o
>  obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
>  obj-y += kstrtox.o
> 
> --

That does fix the build errors.  Thanks.

Here is a more complete patch with a patch description and S-O-B.
I would have put your S-O-B in it but you didn't include one.
Feel free to add yours now.

---
From: Randy Dunlap <rdunlap@infradead.org>

Drop percpu_ida.o from lib-y since it is also listed in obj-y
and it doesn't need to be listed in both places.

Move percpu-refcount.o from lib-y to obj-y to fix build errors
in target_core_mod:

ERROR: "percpu_ref_cancel_init" [drivers/target/target_core_mod.ko] undefined!
ERROR: "percpu_ref_kill_and_confirm" [drivers/target/target_core_mod.ko] undefined!
ERROR: "percpu_ref_init" [drivers/target/target_core_mod.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20131115.orig/lib/Makefile
+++ linux-next-20131115/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o percpu-refcount.o percpu_ida.o
+	 earlycpio.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
@@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o h
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
-	 percpu_ida.o
+	 percpu-refcount.o percpu_ida.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
