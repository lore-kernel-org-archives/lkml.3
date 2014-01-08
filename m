Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaAHOk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:40:29 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34741 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988AbaAHOkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:40:25 -0500
Message-ID: <52CD6358.7010706@gmail.com>
Date: Wed, 08 Jan 2014 22:40:24 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] drivers: target: target_core_mod: use div64_u64_rem()
 instead of operator '%' for u64
References: <52B4F837.1010403@gmail.com>  <1387680997.5567.91.camel@haakon3.risingtidesystems.com>  <52B6AE19.80401@gmail.com> <1387781487.5567.147.camel@haakon3.risingtidesystems.com> <52B90111.5050203@gmail.com> <52CCFF0C.7070704@suse.de>
In-Reply-To: <52CCFF0C.7070704@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 03:32 PM, Hannes Reinecke wrote:
> On 12/24/2013 04:35 AM, Chen Gang wrote:
>> On 12/23/2013 02:51 PM, Nicholas A. Bellinger wrote:
>>> On Sun, 2013-12-22 at 17:17 +0800, Chen Gang wrote:
>>>> On 12/22/2013 10:56 AM, Nicholas A. Bellinger wrote:
>>>>> Hi Chen,
>>>>>
>>>>> On Sat, 2013-12-21 at 10:08 +0800, Chen Gang wrote:
>>>>>> In kernel, need use div64_u64_rem() instead of operator '%' for u64, or
>>>>>> can not pass compiling (with allmodconfig under metag):
>>>>>>
>>>>>>     MODPOST 2909 modules
>>>>>>   ERROR: "__umoddi3" [drivers/target/target_core_mod.ko] undefined!
>>>>>>
>>>>>> Also need u64 type cast for u32 variable multiply u32 variable, or will
>>>>>> cause type overflow issue.
>>>>>>
>>>>>>
>>>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>>>> ---
>>>>>>  drivers/target/target_core_alua.c | 3 ++-
>>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>
>>>>>
>>>>> FYI, this unsigned long long division in core_alua_state_lba_dependent()
>>>>> was fixed for 32-bit in linux-next >= 12192013 code.
>>>>>
>>>>
>>>> OK, thanks.
>>>>
>>>> The related fix patch changed "start_lba = lba % ..." to "start_lba =
>>>> lba / ...", and also assumed "segment_size * segment_mult" is still
>>>> within u32 (can not cause type over flow).
>>>>
>>>> I guess the original author already knew about them, and intended to do
>>>> like that (if not, please let me know, thanks).
>>>>
>>>
>>> Sorry, your correct that the original code is using modulo division to
>>> calculate start_lba.
>>>
>>
>> Oh, that's all right, (in fact, don't need sorry), I am not quite
>> familiar with the details, so need related member help check it.  :-)
>>
>>> Hannes, can you please double check this below..?
>>>
>>
>> Please help check when have time, thanks.
>>
> I would even convert segment_size and segment_mult to u64,
> to ensure no overflows occur:
> 
> diff --git a/drivers/target/target_core_alua.c
> b/drivers/target/target_core_alua
> .c
> index 9b1856d..54b1e52 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -477,8 +477,7 @@ static inline int core_alua_state_lba_dependent(
>         u8 *alua_ascq)
>  {
>         struct se_device *dev = cmd->se_dev;
> -       u32 segment_size, segment_mult, sectors;
> -       u64 lba;
> +       u64 segment_size, segment_mult, sectors, lba;
> 
>         /* Only need to check for cdb actually containing LBAs */
>         if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB))
> 
> 

OK, thanks.

> Other than that the sector_div() patch is correct.
> 

So we really need use '/' instead of original '%'?


Thanks
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
