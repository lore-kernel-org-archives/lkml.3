Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaCHEJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 23:09:08 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38177 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaCHEJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 23:09:06 -0500
Date: Sat, 8 Mar 2014 12:09:04 +0800
From: Liu Shuo <shuox.liu@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Liu ShuoX <shuox.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Anton Vorontsov <anton@enomsg.org>,
        yanmin_zhang@linux.intel.com
Subject: [PATCH] pstore: clarify clearing of _read_cnt in ramoops_context
Message-ID: <20140308040901.GA8339@shuo-gentoo>
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
 <CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
 <20140304014002.GA10071@lskakaxi-intel>
 <CAGXu5j+5CXKJ7+vaWgZXVJgFGHFzcwO6-D1iE+wyDcpr+g8jdw@mail.gmail.com>
 <20140307025842.GA6435@lskakaxi-intel>
 <20140307132514.b6c596879f78478cad190e65@linux-foundation.org>
 <CAGXu5jLiAi9Yofimw5tUvz2HELRWAJBaj3XXWaN-EHK_wANZDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jLiAi9Yofimw5tUvz2HELRWAJBaj3XXWaN-EHK_wANZDA@mail.gmail.com>
X-Mailer: Mutt 1.5.x/OS X 10.7.x
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri  7.Mar'14 at 16:23:29 -0800, Kees Cook wrote:
>On Fri, Mar 7, 2014 at 1:25 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 7 Mar 2014 10:58:43 +0800 Liu ShuoX <shuox.liu@intel.com> wrote:
>>
>>>
>>> ftrace_read_cnt need to be reset in open to support mutli times
>>> getting the records.
>>>
>>> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
>>> ---
>>>   fs/pstore/ram.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>> ...
>>
>> The dump_read_cnt changes appear to be unrelated to the actual bugfix?
>
>I recommended this change since it is being cleared during open, and
>this zeroing was confusing.
>
>> If so, please send this along as a separate patch.  With a full
>> changelog - this one doesn't explain the dump_read_cnt changes at all.
>
>Liu, I would recommend a changelog along the lines of:
>
>Clarify which variables need to be cleared during pstore_open. Added
>missed ftrace_read_cnt clearing and removed duplicate clearing in
>ramoops_probe.
>
>-Kees
Thanks. It's more clearly. I copied some of your comments into changelog. :)
Re-sent the patch with the new changelog. The subject also changed.

----
From: Liu ShuoX <shuox.liu@intel.com>

*_read_cnt in ramoops_context need to be cleared during pstore ->open
to support mutli times getting the records. The patch added missed
ftrace_read_cnt clearing and removed duplicate clearing in ramoops_probe.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/ram.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index fa8cef2..9fe5b13 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -86,6 +86,7 @@ struct ramoops_context {
 	struct persistent_ram_ecc_info ecc_info;
 	unsigned int max_dump_cnt;
 	unsigned int dump_write_cnt;
+	/* _read_cnt need clear on ramoops_pstore_open */
 	unsigned int dump_read_cnt;
 	unsigned int console_read_cnt;
 	unsigned int ftrace_read_cnt;
@@ -101,6 +102,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 
 	cxt->dump_read_cnt = 0;
 	cxt->console_read_cnt = 0;
+	cxt->ftrace_read_cnt = 0;
 	return 0;
 }
 
@@ -428,7 +430,6 @@ static int ramoops_probe(struct platform_device *pdev)
 	if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
 		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
-	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
-- 
1.8.3.2
