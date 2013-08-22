Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3HVIoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:44:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:25816 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3HVIn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:43:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,932,1367996400"; 
   d="scan'208";a="285253096"
Message-ID: <1377161014.6167.67.camel@yhuang-dev>
Subject: Re: kmemleak in apei_res_add
From: Huang Ying <ying.huang@intel.com>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 22 Aug 2013 16:43:35 +0800
In-Reply-To: <20130821134455.GC12595@sanechka.spb.ru>
References: <20130812024556.GB29956@sanechka.spb.ru>
	 <CAHkRjk4y06puTL_Gq5RbpoV+kpEp+k32z5aq3HpEu9u3qsS_Aw@mail.gmail.com>
	 <20130821134455.GC12595@sanechka.spb.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexandra,

On Wed, 2013-08-21 at 17:44 +0400, Alexandra N. Kossovsky wrote:
> On Aug 21 10:38, Catalin Marinas wrote:
> > On 12 August 2013 03:45, Alexandra N. Kossovsky
> > <Alexandra.Kossovsky@oktetlabs.ru> wrote:
> > > When running 3.10.3 with kmemleak enabled, I see following warnings from
> > > kmemleak:
> > >
> > > unreferenced object 0xffff88024d2219a0 (size 32):
> > >   comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
> > >   hex dump (first 32 bytes):
> > >     58 de 0c 73 02 88 ff ff 58 de 0c 73 02 88 ff ff  X..s....X..s....
> > >     18 50 fd 7d 00 00 00 00 3f 50 fd 7d 00 00 00 00  .P.}....?P.}....
> > >   backtrace:
> > >     [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
> > >     [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
> > >     [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
> > >     [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
> > >     [<ffffffff81278faa>] collect_res_callback+0x6d/0x7c
> > >     [<ffffffff812788ed>] apei_exec_for_each_entry+0x78/0x93
> > >     [<ffffffff8127891d>] apei_exec_collect_resources+0x15/0x17
> > >     [<ffffffff81b010e5>] erst_init+0x278/0x2a3
> > >     [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
> > >     [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
> > >     [<ffffffff813db19f>] kernel_init+0x9/0xd6
> > >     [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
> > >     [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > Are there any "APEI:" errors in the kernel log? It could be some
> > freeing missing on an error path.
> 
> No.
> dmesg |grep APEI
> [    9.602274] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
> 

Can you try the following debug patch, and send me back the output of:

$ dmesg | grep apei_res

Best Regards,
Huang Ying


---
 drivers/acpi/apei/apei-base.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -310,6 +310,8 @@ static int apei_res_add(struct list_head
 	struct apei_res *res, *resn, *res_ins = NULL;
 	unsigned long end = start + size;
 
+	pr_info("apei_res_add: %p: %lx - %lx\n", res_list, start, end);
+
 	if (end <= start)
 		return 0;
 repeat:
@@ -346,6 +348,7 @@ static int apei_res_sub(struct list_head
 			struct list_head *res_list2)
 {
 	struct apei_res *res1, *resn1, *res2, *res;
+	pr_info("apei_res_sub: %p - %p\n", res_list1, res_list2);
 	res1 = list_entry(res_list1->next, struct apei_res, list);
 	resn1 = list_entry(res1->list.next, struct apei_res, list);
 	while (&res1->list != res_list1) {
@@ -386,6 +389,7 @@ static void apei_res_clean(struct list_h
 {
 	struct apei_res *res, *resn;
 
+	pr_info("apei_res_clean: %p\n", res_list);
 	list_for_each_entry_safe(res, resn, res_list, list) {
 		list_del(&res->list);
 		kfree(res);


