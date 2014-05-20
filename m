Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaETIQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:16:20 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59688 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaETIQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:16:17 -0400
Message-ID: <537B0EE0.4080406@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 13:44:24 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: mikey@neuling.org, avagin@openvz.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com> <537252C0.6090005@redhat.com> <53730326.6000400@linux.vnet.ibm.com> <53735044.5030008@redhat.com> <537479FD.2010200@linux.vnet.ibm.com> <5374AE24.1030302@redhat.com> <5379EF0E.6090504@linux.vnet.ibm.com> <537A1889.8030801@redhat.com>
In-Reply-To: <537A1889.8030801@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052008-2674-0000-0000-00000E61574B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 08:13 PM, Pedro Alves wrote:
> On 05/19/2014 12:46 PM, Anshuman Khandual wrote:
> 
>>>> I couldn't actually find any arch that currently returns -ENODEV in
>>>> the "active" hook.  I see that binfmt_elf.c doesn't handle
>>>> regset->active() returning < 0.  Guess that may be why.  Looks like
>>>> something that could be cleaned up, to me.
>>>>
>> Also it does not consider the return value of regset->active(t->task, regset)
>> (whose objective is to figure out whether we need to request regset->n number
>> of elements or less than that) in the subsequent call to regset->get function.
> 
> Indeed.
> 
> TBC, do you plan on fixing this?  Otherwise ...

Sure, thinking something like this as mentioned below. But still not sure how to use
the return type of -ENODEV from the function regset->active(). Right now if any
regset does have the active hook and it returns anything but positive value, it will
be ignored and the control moves to the next regset in view. This prevents the thread
core note type being written to the core dump.

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index aa3cb62..80672fb 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1553,7 +1553,15 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
                if (regset->core_note_type && regset->get &&
                    (!regset->active || regset->active(t->task, regset))) {
                        int ret;
-                       size_t size = regset->n * regset->size;
+                       size_t size;
+
+                       /* Request only the active elements in the regset */
+                       if (!regset->active)
+                               size = regset->n * regset->size;
+                       else
+                               size = regset->active(t->task, regset)
+                                                               * regset->size;
+
                        void *data = kmalloc(size, GFP_KERNEL);
                        if (unlikely(!data))
                                return 0;

> 
>> Now coming to the installation of the .active hooks part for all the new regsets, it
>> should be pretty straight forward as well. Though its optional and used for elf_core_dump
>> purpose only, its worth adding them here. Example of an active function should be something
>> like this. The function is inexpensive as required.
>>
>> +static int tm_spr_active(struct task_struct *target,
>> +                               const struct user_regset *regset)
>> +{
>> +       if (!cpu_has_feature(CPU_FTR_TM))
>> +               return -ENODEV;
> 
> ... unfortunately this will do the wrong thing.

I am not sure whether I understand this correctly. Are you saying that its wrong to return
-ENODEV in this case as above ?

