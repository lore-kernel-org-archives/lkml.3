Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbaFCWTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:19:16 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54563 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaFCWTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140602100548.GW15585@mwanda>
References: <1401629611-19166-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140602100548.GW15585@mwanda>
Date: Wed, 4 Jun 2014 00:19:14 +0200
Message-ID: <CAFo99gZ_idLvvvh86pEuiMTTwkK=dgZBop_qZAbA2z_Y00boPA@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: pmgr: dspapi.c: Cleaning up
 uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I send in a new patch now, hope I interpreted you correctly how you
wanted the changes.

Worth mention is that in mgrwrap_enum_node_info()   unless you wanted to remove
"if (size < sizeof(struct dsp_ndbprops))" then size will always be the
same as sizeof(struct dsp_ndbprops)


Best regards
Rickard Strandqvist


2014-06-02 12:10 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> [ I am writing this at the end after writing the rest of this email.
>
>   After looking at the CP_TO_USR() macro more carefully, I realize that
>   the uninitialized variable bugs you are fixing are false positives.
>   The information leaks where the max size is not capped are real
>   security bugs.
>
>   This code is total garbage.  It makes me irritated to look at it.
>   Let's replace the stupid CP_TO_USR() macro with normal copy_to_user()
>   calls, for example.  -- dan ]
>
> On Sun, Jun 01, 2014 at 03:33:31PM +0200, Rickard Strandqvist wrote:
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/tidspbridge/pmgr/dspapi.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
>> index b7d5c8c..4e12a5b 100644
>> --- a/drivers/staging/tidspbridge/pmgr/dspapi.c
>> +++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
>> @@ -340,7 +340,7 @@ int api_init_complete2(void)
>>  u32 mgrwrap_enum_node_info(union trapped_args *args, void *pr_ctxt)
>>  {
>>       u8 *pndb_props;
>> -     u32 num_nodes;
>> +     u32 num_nodes = 0;
>>       int status = 0;
>>       u32 size = args->args_mgr_enumnode_info.ndb_props_size;
>>
>
> The error handling in this function really sucks.
>
> The "num_nodes" variable was supposed to be initialized in
> mgr_enum_node_info().
>
> The error handling in this function really sucks.  If the kmalloc()
> fails then we will hit your uninitialized variable bug and also we will
> hit a NULL dereference bug and crash.
>
> Besides those two bugs, there is a third even worse bug which is that if
> if "size" is greater than sizeof(struct dsp_ndbprops) then we leak the
> extra information to the user.  It is a security problem.
>
> Please could you send something to clean this up completely?
>
> 1) Add a check:
>         if (size > sizeof(struct dsp_ndbprops))
>                 size = sizeof(struct dsp_ndbprops);
>
> 2) Return immediately on kmalloc() failure
>
> 3) if mgr_enum_node_info() fails then goto free_props, do not copy bogus
>    data to the user.
>
>
>> @@ -372,7 +372,7 @@ u32 mgrwrap_enum_node_info(union trapped_args *args, void *pr_ctxt)
>>  u32 mgrwrap_enum_proc_info(union trapped_args *args, void *pr_ctxt)
>>  {
>>       u8 *processor_info;
>> -     u8 num_procs;
>> +     u8 num_procs = 0;
>>       int status = 0;
>>       u32 size = args->args_mgr_enumproc_info.processor_info_size;
>>
>
> This function has all the same problems as the previous function but
> fixing it is more complicated.  The sizeof() check should be:
>
>         if (size > sizeof(struct mgr_processorextinfo))
>                 size = sizeof(struct mgr_processorextinfo);
>
> And change the kmalloc() to a kzalloc() in case the size is somewhere in
> the middle of sizeof(struct dsp_processorinfo) and
> sizeof(struct mgr_processorextinfo).
>
>> @@ -475,7 +475,7 @@ u32 mgrwrap_wait_for_bridge_events(union trapped_args *args, void *pr_ctxt)
>>       int status = 0;
>>       struct dsp_notification *anotifications[MAX_EVENTS];
>>       struct dsp_notification notifications[MAX_EVENTS];
>> -     u32 index, i;
>> +     u32 index = 0, i;
>>       u32 count = args->args_mgr_wait.count;
>>
>>       if (count > MAX_EVENTS)
>
> This function is total garbage as well.  Fix up the error handling.
>
>> @@ -1755,7 +1755,7 @@ u32 strmwrap_register_notify(union trapped_args *args, void *pr_ctxt)
>>   */
>>  u32 strmwrap_select(union trapped_args *args, void *pr_ctxt)
>>  {
>> -     u32 mask;
>> +     u32 mask = 0;
>>       struct strm_object *strm_tab[MAX_STREAMS];
>>       int status = 0;
>>       struct strm_res_object *strm_res;
>
>
>
>> --
>> 1.7.10.4
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
