Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3LKCrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:47:11 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:43710 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3LKCrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:47:08 -0500
MIME-Version: 1.0
In-Reply-To: <74430a05-1640-4174-977d-52d2d2b8519f@email.android.com>
References: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
	<20131209213057.GA11314@phenom.dumpdata.com>
	<CABawtvMGOJg5DPRwdWAOSTkxgurv5bx8n=3yJFOq=aagxzseZQ@mail.gmail.com>
	<74430a05-1640-4174-977d-52d2d2b8519f@email.android.com>
Date: Wed, 11 Dec 2013 10:47:07 +0800
Message-ID: <CABawtvM-wt2sDB=jzaapAVKjdMcdzTvNt+ohT5xXYsdzJakArw@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] iscsi_boot_sysfs: Fix a memory leak in iscsi_boot_destroy_kset()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: michaelc@cs.wisc.edu, pjones@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:11 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Ethan Zhao <ethan.kernel@gmail.com> wrote:
>>Konrad,
>>
>> boot_kset was allocated when module loaded by
>>ibft_init()
>>  iscsi_boot_create_kset()
>>     kzalloc()
>>
>>but wasn't freed when module unloaded by
>>ibft_exit()
>>   ibft_cleanup()
>>     iscsi_boot_destroy_kset()
>>
>>Thanks,
>>Ethan
>>
>>On Tue, Dec 10, 2013 at 5:30 AM, Konrad Rzeszutek Wilk
>><konrad.wilk@oracle.com> wrote:
>>> On Mon, Dec 09, 2013 at 05:37:11PM +0800, Ethan Zhao wrote:
>>>> From: "Ethan Zhao" <ethan.kernel@gmail.com>
>>>>
>>>> Load and unload iscsi_ibft module will cause kernel memory leak, fix
>>it
>>>> in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().
>>>>
>>>
>>> Is there a stack trace?
>>>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>>>> ---
>>>>  drivers/scsi/iscsi_boot_sysfs.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/iscsi_boot_sysfs.c
>>b/drivers/scsi/iscsi_boot_sysfs.c
>>>> index 14c1c8f..680bf6f 100644
>>>> --- a/drivers/scsi/iscsi_boot_sysfs.c
>>>> +++ b/drivers/scsi/iscsi_boot_sysfs.c
>>>> @@ -490,5 +490,6 @@ void iscsi_boot_destroy_kset(struct
>>iscsi_boot_kset *boot_kset)
>>>>               iscsi_boot_remove_kobj(boot_kobj);
>>>>
>>>>       kset_unregister(boot_kset->kset);
>>>> +     kfree(boot_kset);
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);
>>>> --
>>>> 1.8.3.4 (Apple Git-47)
>>>>
>
> Right. In the past we did not do that b/c certain drivers (like broadcom) would allocate on the kset their name and try to free (the driver would after freeing the ibft). So you would end up with this patch a double free ( and it might be fixed by now but I can't recall).
>
> My question was - did you observer a crash or bug. Hence the question about stack trace? How did you see this?

That is quite simple, just like fuzzy test, load and unload a module
millions of times with a script in low memory size machine, in the
meanwhile, monitor OOM etc.

Thanks,
Ethan

>
> Thank you.
>
