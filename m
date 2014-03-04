Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaCDTLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:11:15 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46362 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaCDTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140304014002.GA10071@lskakaxi-intel>
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
	<CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
	<20140304014002.GA10071@lskakaxi-intel>
Date: Tue, 4 Mar 2014 11:11:11 -0800
X-Google-Sender-Auth: 8lrOjrVu-uNTM55db5_YcLRRuUI
Message-ID: <CAGXu5j+5CXKJ7+vaWgZXVJgFGHFzcwO6-D1iE+wyDcpr+g8jdw@mail.gmail.com>
Subject: Re: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
From: Kees Cook <keescook@chromium.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Anton Vorontsov <anton@enomsg.org>,
        yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 5:40 PM, Liu ShuoX <shuox.liu@intel.com> wrote:
> On Mon  3.Mar'14 at 11:45:59 -0800, Kees Cook wrote:
>>
>> On Thu, Feb 27, 2014 at 10:37 PM,  <shuox.liu@intel.com> wrote:
>>>
>>> From: Liu ShuoX <shuox.liu@intel.com>
>>>
>>> ftrace_read_cnt need to be reset in open to support mutli times
>>> getting the records.
>>>
>>> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
>>> ---
>>>  fs/pstore/ram.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
>>> index fa8cef2..a5d0cab 100644
>>> --- a/fs/pstore/ram.c
>>> +++ b/fs/pstore/ram.c
>>> @@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct pstore_info
>>> *psi)
>>>
>>>         cxt->dump_read_cnt = 0;
>>>         cxt->console_read_cnt = 0;
>>> +       cxt->ftrace_read_cnt = 0;
>>>         return 0;
>>>  }
>>
>>
>> I think we need a separate function for "clear" for the
>> ramoops_context struct. IIUC, we're missing a similar initialization
>> in ramoops_probe, which lacks both console_read_cnt=0 and
>> ftrace_read_cnt=0. Then both places could call this?
>
> Hi Kees,
> Currently, we have only one static ramoops_context named oops_cxt.
> *_read_cnt should be initialized to 0 as default. Need we still add
> such function for 'clear'?

We have the pstore-global "oops_cxt" context. It is "initialized" only
once in ramoops_probe (and seems to needlessly set dump_read_cnt to
0). Otherwise, the context is initialized via ramoops_register_dummy
from module parameters (and initialized to zero with kzalloc).

So, I think my initial comment about "clear" is probably not right,
but that ramoops_pstore_open should be doing that (i.e. your original
patch is close). However, I think I'd like to see the needless zeroing
in ramoops_probe removed, and the "variables that need clearing on
open" documented in comments in "struct ramoops_context". That should
make this code more clear to read next time. :)

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
