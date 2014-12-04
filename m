Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaLDGMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:12:51 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61519 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLDGMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:12:50 -0500
Message-ID: <547FFB5D.8000503@colorfullife.com>
Date: Thu, 04 Dec 2014 07:12:45 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
CC: Dmitry Vyukov <dvyukov@google.com>, David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, aquini@redhat.com, davidlohr@hp.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero' variable
References: <547F0486.7020400@samsung.com> <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com> <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
In-Reply-To: <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020909000003010905080900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020909000003010905080900
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

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
>>   static int __maybe_unused one = 1;
>>   static int __maybe_unused two = 2;
>>   static int __maybe_unused four = 4;
> Yeah, this is ghastly.
>
> Look at
>
> 	{
> 		.procname	= "numa_balancing",
> 		.data		= NULL, /* filled in by handler */
> 		.maxlen		= sizeof(unsigned int),
> 		.mode		= 0644,
> 		.proc_handler	= sysctl_numa_balancing,
> 		.extra1		= &zero,
> 		.extra2		= &one,
> 	},
>
> Now extra1 points at a long and extra2 points at an int.
> sysctl_numa_balancing() calls proc_dointvec_minmax() and I think your
> patch just broke big-endian 64-bit machines.  "sched_autogroup_enabled"
> breaks as well.
What about getting rid of "extra1" and "extra2" as well and replace it 
with "min" and "max"?
I've attached an idea

> and change proc_dointvec_minmax() and a million other functions to take
> `union sysctl_payload *' arguments.  But I haven't thought about it much.
Another idea: why do we pass "int *" instead of "int"?

With "int", we could use
     .int_min = 0;
     .int_max = 1;


--
     Manfred

--------------020909000003010905080900
Content-Type: text/x-patch;
 name="0001-PATCH-Allow-type-safe-documented-sysctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-PATCH-Allow-type-safe-documented-sysctl.patch"

>From 7a210bec3d9dc3382ef0d6809a7742856373bbee Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Thu, 4 Dec 2014 07:03:39 +0100
Subject: [PATCH] Allow type safe & documented sysctl

Idea from Andrew:
- add a union into struct ctl_table instead of the void *
- further idea: replace "extra1" and "extra2" with min/max
- use it for ipc

Notes:
- not tested
- not coding style reviewed
- open FIXME in ipc_sysctl.c

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sysctl.h | 16 ++++++++++++++--
 ipc/ipc_sysctl.c       | 34 ++++++++++++++++++----------------
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index b7361f8..acc7581 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -111,8 +111,20 @@ struct ctl_table
 	struct ctl_table *child;	/* Deprecated */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	struct ctl_table_poll *poll;
-	void *extra1;
-	void *extra2;
+	union {
+		void *extra1;
+		int *int_min;
+		long *long_min;
+		unsigned int *uint_min;
+		unsigned long *ulong_min;
+	};
+	union {
+		void *extra2;
+		int *int_max;
+		long *long_max;
+		unsigned int *uint_max;
+		unsigned long *ulong_max;
+	};
 };
 
 struct ctl_node {
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index c3f0326..50a6e1c 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -167,6 +167,7 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.shm_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_doulongvec_minmax,
+		/* FIXME: Why no ulong_min & ulong_max ?? */
 	},
 	{
 		.procname	= "shmall",
@@ -174,6 +175,7 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.shm_ctlall),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_doulongvec_minmax,
+		/* FIXME: Why no ulong_min & ulong_max ?? */
 	},
 	{
 		.procname	= "shmmni",
@@ -188,8 +190,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.shm_rmid_forced),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec_minmax_orphans,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.int_min	= &zero,
+		.int_max	= &one,
 	},
 	{
 		.procname	= "msgmax",
@@ -197,8 +199,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &int_max,
+		.int_min	= &zero,
+		.int_max	= &int_max,
 	},
 	{
 		.procname	= "msgmni",
@@ -206,8 +208,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_callback_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &int_max,
+		.int_min	= &zero,
+		.int_max	= &int_max,
 	},
 	{
 		.procname	=  "msgmnb",
@@ -215,8 +217,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &int_max,
+		.int_min	= &zero,
+		.int_max	= &int_max,
 	},
 	{
 		.procname	= "sem",
@@ -231,8 +233,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_ipcauto_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.int_min	= &zero,
+		.int_max	= &one,
 	},
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	{
@@ -241,8 +243,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SEM_IDS].next_id),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &int_max,
+		.int_min	= &zero,
+		.int_max	= &int_max,
 	},
 	{
 		.procname	= "msg_next_id",
@@ -250,8 +252,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.ids[IPC_MSG_IDS].next_id),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &int_max,
+		.int_min	= &zero,
+		.int_max	= &int_max,
 	},
 	{
 		.procname	= "shm_next_id",
@@ -259,8 +261,8 @@ static struct ctl_table ipc_kern_table[] = {
 		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SHM_IDS].next_id),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &int_max,
+		.int_min	= &zero,
+		.int_max	= &int_max,
 	},
 #endif
 	{}
-- 
1.9.3


--------------020909000003010905080900--
