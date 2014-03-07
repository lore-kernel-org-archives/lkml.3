Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaCGFoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:44:03 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63998 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaCGFoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140307025842.GA6435@lskakaxi-intel>
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
	<CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
	<20140304014002.GA10071@lskakaxi-intel>
	<CAGXu5j+5CXKJ7+vaWgZXVJgFGHFzcwO6-D1iE+wyDcpr+g8jdw@mail.gmail.com>
	<20140307025842.GA6435@lskakaxi-intel>
Date: Thu, 6 Mar 2014 21:43:59 -0800
X-Google-Sender-Auth: JO2TffpXYD6XOPE2WBig9YABG0I
Message-ID: <CAGXu5jLz99m4bVtCy73M_PfUC4wiq1CUz-QfSUR7UfZGQrdh_w@mail.gmail.com>
Subject: Re: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
From: Kees Cook <keescook@chromium.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Anton Vorontsov <anton@enomsg.org>,
        yanmin_zhang@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 6:58 PM, Liu ShuoX <shuox.liu@intel.com> wrote:
> On Tue  4.Mar'14 at 11:11:11 -0800, Kees Cook wrote:
>>
>> On Mon, Mar 3, 2014 at 5:40 PM, Liu ShuoX <shuox.liu@intel.com> wrote:
>>>
>>> On Mon  3.Mar'14 at 11:45:59 -0800, Kees Cook wrote:
>>>>
>>>>
>>>> On Thu, Feb 27, 2014 at 10:37 PM,  <shuox.liu@intel.com> wrote:
>>>>>
>>>>>
>>>>> From: Liu ShuoX <shuox.liu@intel.com>
>>>>>
>>>>> ftrace_read_cnt need to be reset in open to support mutli times
>>>>> getting the records.
>>>>>
>>>>> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
>>>>> ---
>>>>>  fs/pstore/ram.c | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
>>>>> index fa8cef2..a5d0cab 100644
>>>>> --- a/fs/pstore/ram.c
>>>>> +++ b/fs/pstore/ram.c
>>>>> @@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct pstore_info
>>>>> *psi)
>>>>>
>>>>>         cxt->dump_read_cnt = 0;
>>>>>         cxt->console_read_cnt = 0;
>>>>> +       cxt->ftrace_read_cnt = 0;
>>>>>         return 0;
>>>>>  }
>>>>
>>>>
>>>>
>>>> I think we need a separate function for "clear" for the
>>>> ramoops_context struct. IIUC, we're missing a similar initialization
>>>> in ramoops_probe, which lacks both console_read_cnt=0 and
>>>> ftrace_read_cnt=0. Then both places could call this?
>>>
>>>
>>> Hi Kees,
>>> Currently, we have only one static ramoops_context named oops_cxt.
>>> *_read_cnt should be initialized to 0 as default. Need we still add
>>> such function for 'clear'?
>>
>>
>> We have the pstore-global "oops_cxt" context. It is "initialized" only
>> once in ramoops_probe (and seems to needlessly set dump_read_cnt to
>> 0). Otherwise, the context is initialized via ramoops_register_dummy
>> from module parameters (and initialized to zero with kzalloc).
>>
>> So, I think my initial comment about "clear" is probably not right,
>> but that ramoops_pstore_open should be doing that (i.e. your original
>> patch is close). However, I think I'd like to see the needless zeroing
>> in ramoops_probe removed, and the "variables that need clearing on
>> open" documented in comments in "struct ramoops_context". That should
>> make this code more clear to read next time. :)
>
> Sorry for delay reply. How about below patch?
>
>
> From: Liu ShuoX <shuox.liu@intel.com>
>
> ftrace_read_cnt need to be reset in open to support mutli times
> getting the records.
>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>  fs/pstore/ram.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index fa8cef2..9fe5b13 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -86,6 +86,7 @@ struct ramoops_context {
>         struct persistent_ram_ecc_info ecc_info;
>         unsigned int max_dump_cnt;
>         unsigned int dump_write_cnt;
> +       /* _read_cnt need clear on ramoops_pstore_open */
>         unsigned int dump_read_cnt;
>         unsigned int console_read_cnt;
>         unsigned int ftrace_read_cnt;
> @@ -101,6 +102,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
>
>         cxt->dump_read_cnt = 0;
>         cxt->console_read_cnt = 0;
> +       cxt->ftrace_read_cnt = 0;
>         return 0;
>  }
>  @@ -428,7 +430,6 @@ static int ramoops_probe(struct platform_device *pdev)
>         if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
>                 pdata->ftrace_size =
> rounddown_pow_of_two(pdata->ftrace_size);
>  -      cxt->dump_read_cnt = 0;
>         cxt->size = pdata->mem_size;
>         cxt->phys_addr = pdata->mem_address;
>         cxt->record_size = pdata->record_size;
> --
> 1.8.3.2
>

Thanks! That looks right to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
