Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaLMUvJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 15:51:09 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41372 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaLMUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 15:51:07 -0500
Message-ID: <548CA6B6.3060901@colorfullife.com>
Date: Sat, 13 Dec 2014 21:51:02 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, aquini@redhat.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero' variable
References: <547F0486.7020400@samsung.com> <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com> <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
In-Reply-To: <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------090408000305030706090900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090408000305030706090900
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 12/04/2014 12:25 AM, Andrew Morton wrote:
> On Wed, 03 Dec 2014 15:41:21 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
>
>> Use the 'unsigned long' type for 'zero' variable to fix this.
>> Changing type to 'unsigned long' shouldn't affect any other users
>> of this variable.
>>
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>   kernel/sysctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 15f2511..45c45c9 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -120,7 +120,7 @@ static int sixty = 60;
>>   
>>   static int __maybe_unused neg_one = -1;
>>   
>> -static int zero;
>> +static unsigned long zero;

After some (useless) playing around (see the attached patch):

Using
 >    .extra1=zero,
for proc_doulongvec_minmax doesn't make any sense:

  __do_proc_doulongvec_minmax() internally contains
>                       if ((min && val < *min) || (max && val > *max))
>                                 continue;

What about just deleting the offending .extra1=zero line?
.extra1=NULL has the same effect as .extra1=&zero.

--
     Manfred




--------------090408000305030706090900
Content-Type: text/x-patch;
 name="0001-kernel-sysctl.c-Type-safe-macros.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-kernel-sysctl.c-Type-safe-macros.patch"

>From 194e5d4758bb30531bad0907f06f3518002cd8b4 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Sat, 13 Dec 2014 21:25:27 +0100
Subject: [PATCH] kernel/sysctl.c: Type safe macros

struct ctl_table is used for creating entries in e.g. /proc/sys/kernel.

The structure contains three void * entries and a function pointer, thus
there is the risk of incorrectly mixing types.

The patch create a macro that prevents accidential mixing, it enforces
that the type expected by the function pointer and the three void * are
all of the same type.

Notes:
- From my first impression, most proc entries mix types, and it works,
  because (int)1 and (unsigned int)1 are identical.
  Thus I'm not sure if this is the right approach.

- the code doesn't compile, it contains an intentional incompatible type

What do you think?

--
	Manfred
---
 kernel/sysctl.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 97 insertions(+), 16 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 15f2511..bc446a6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -276,6 +276,101 @@ static int min_extfrag_threshold;
 static int max_extfrag_threshold = 1000;
 #endif
 
+/*
+ * Type safe macros for creating the sysctl table entries:
+ *
+ * TODO:
+ * - 1) It works.
+ *	I.e. it complains when _dointvec is used to assign
+ *      to an unsigned int. Unfortunately, this is very common:
+ *       * _minmax is used, with min=0 and e.g. max=int_max.
+ *	 * the variable is actually used as a boolean, thus it doesn't matter
+ *	   if the user space interface returns -1 or 0xffffffff.
+ *	 * unsigned int zero is used as min
+ *	 * ...
+ *      Thus most error messages would be false positives.
+ *
+ * - 2) The error message is difficult to understand
+ *		error: initializer element is not constant
+ */
+
+#define ASSIGN_TYPE_SAFE(param, type)					\
+    __builtin_choose_expr(__builtin_types_compatible_p(typeof(param), type), \
+        param,							\
+        /* The void expression results in a compile-time error	\
+             when assigning the result to something.  */		\
+        ((void)0)							\
+    )
+
+#define SYSCTL_BUILD_INT_ENTRY_MINMAX(name, entry, min_ptr, max_ptr) \
+	{ \
+		.procname	= (name), \
+		.data		= ASSIGN_TYPE_SAFE(&(entry), int *), \
+		.maxlen		= sizeof( (entry) ), \
+		.mode		= 0644, \
+		.proc_handler	= proc_dointvec_minmax, \
+		.extra1		= ASSIGN_TYPE_SAFE( (min_ptr), int *), \
+		.extra2		= ASSIGN_TYPE_SAFE( (max_ptr), int *) \
+	}
+
+#define SYSCTL_BUILD_ULONG_ENTRY_MINMAX(name, entry, min_ptr, max_ptr) \
+	{ \
+		.procname	= (name), \
+		.data		= ASSIGN_TYPE_SAFE(&(entry), unsigned long *), \
+		.maxlen		= sizeof( (entry) ), \
+		.mode		= 0644, \
+		.proc_handler	= proc_doulongvec_minmax, \
+		.extra1		= ASSIGN_TYPE_SAFE( (min_ptr), unsigned long *), \
+		.extra2		= ASSIGN_TYPE_SAFE( (max_ptr), unsigned long *) \
+	}
+
+#define SYSCTL_BUILD_ENTRY_MINMAX(name, entry, min_ptr, max_ptr)	\
+	{ \
+		.procname	= (name), \
+		.data		= &(entry), \
+		.maxlen		= sizeof( (entry) ), \
+		.mode		= 0644, \
+		.proc_handler	= __builtin_choose_expr(__builtin_types_compatible_p(typeof( &(entry)), int *), \
+					proc_dointvec_minmax, \
+					__builtin_choose_expr(__builtin_types_compatible_p(typeof( &(entry)), unsigned long *), \
+						proc_doulongvec_minmax, \
+						((void)0) ) ), \
+		.extra1		= ASSIGN_TYPE_SAFE( (min_ptr), typeof( &(entry) )), \
+		.extra2		= ASSIGN_TYPE_SAFE( (max_ptr), typeof( &(entry) )) \
+	}
+
+#define SYSCTL_BUILD_INT_ENTRY(name, entry) \
+	{ \
+		.procname	= (name), \
+		.data		= ASSIGN_TYPE_SAFE( &(entry), int *), \
+		.maxlen		= sizeof( (entry) ), \
+		.mode		= 0644, \
+		.proc_handler	= proc_dointvec, \
+	}
+
+#define SYSCTL_BUILD_ULONG_ENTRY(name, entry) \
+	{ \
+		.procname	= (name), \
+		.data		= ASSIGN_TYPE_SAFE( &(entry), unsigned long *), \
+		.maxlen		= sizeof( (entry) ), \
+		.mode		= 0644, \
+		.proc_handler	= proc_doulongvec, \
+	}
+
+#define SYSCTL_BUILD_ENTRY(name, entry)	\
+	{ \
+		.procname	= (name), \
+		.data		= &(entry), \
+		.maxlen		= sizeof( (entry) ), \
+		.mode		= 0644, \
+		.proc_handler	= __builtin_choose_expr(__builtin_types_compatible_p(typeof( &(entry)), int *), \
+					proc_dointvec, \
+					__builtin_choose_expr(__builtin_types_compatible_p(typeof( &(entry)), unsigned long *), \
+						proc_doulongvec, \
+						((void)0) ) ) \
+	}
+
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sched_child_runs_first",
@@ -1344,22 +1439,8 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	{
-		.procname	= "block_dump",
-		.data		= &block_dump,
-		.maxlen		= sizeof(block_dump),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
-	},
-	{
-		.procname	= "vfs_cache_pressure",
-		.data		= &sysctl_vfs_cache_pressure,
-		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
-	},
+	SYSCTL_BUILD_ENTRY_MINMAX("block_dump", block_dump, &zero, (unsigned int *)NULL),
+	SYSCTL_BUILD_ENTRY_MINMAX("vfs_cache_pressure", sysctl_vfs_cache_pressure, &zero, (int *)NULL),
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
 		.procname	= "legacy_va_layout",
-- 
2.1.0


--------------090408000305030706090900--
