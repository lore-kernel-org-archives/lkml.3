Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3CGHol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:44:41 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:60548 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3CGHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:44:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130305191350.GD4519@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
	<1360871745-20616-6-git-send-email-vgoyal@redhat.com>
	<20130305191350.GD4519@redhat.com>
Date: Thu, 7 Mar 2013 09:44:37 +0200
Message-ID: <CALLzPKbO-8FtGw437zLmAEVB+Z8crX8JfBUTk0n0ekN9QpfwSA@mail.gmail.com>
Subject: Re: [PATCH 5/6] ima: Allow appraisal of digitally signed files only
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 9:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Feb 14, 2013 at 02:55:44PM -0500, Vivek Goyal wrote:
>> Currently ima appraises all the files as specified by the rule. So
>> if one wants to create a system where only few executables are
>> signed, that system will not work with IMA.
>>
>> With secureboot, one needs to disable kexec so that unsigned kernels
>> can't be booted. To avoid this problem, it was proposed that sign
>> /sbin/kexec binary and if signatures are verified successfully, give
>> an special capability to the /sbin/kexec process. And in secureboot
>> mode processes with that special capability can invoke sys_kexec()
>> system call.
>>
>> So there is a need for IMA to allow appraising only signed binaries.
>> Unsigned binaries will pass the appraisal too, but will not get the
>> special capability. (Capability patches for that are yet to be written).
>>
>> This patch adds new option, appraise_type=imasig_optional to allow
>> appraisal to pass even if no signatures are present on the file. If
>> signatures are present, then it has to be valid digital signature,
>> otherwise appraisal will fail.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
>>  Documentation/ABI/testing/ima_policy |    2 +-
>>  security/integrity/ima/ima_main.c    |   14 ++++++++++++--
>>  security/integrity/ima/ima_policy.c  |    2 ++
>>  security/integrity/integrity.h       |    1 +
>>  4 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
>> index de16de3..cc69872 100644
>> --- a/Documentation/ABI/testing/ima_policy
>> +++ b/Documentation/ABI/testing/ima_policy
>> @@ -30,7 +30,7 @@ Description:
>>                       uid:= decimal value
>>                       fowner:=decimal value
>>               lsm:    are LSM specific
>> -             option: appraise_type:= [imasig]
>> +             option: appraise_type:= [imasig] | [optional]
>>
>>               default policy:
>>                       # PROC_SUPER_MAGIC
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index 3e751a9..da9e348 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -207,8 +207,18 @@ out_digsig:
>>               rc = -EACCES;
>>  out:
>>       mutex_unlock(&inode->i_mutex);
>> -     if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
>> -             return -EACCES;
>> +     if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE)) {
>> +             /*
>> +              * If IMA_APPRAISAL_OPT is set, then access is allowed
>> +              * even if hash or digital signatures are not present.
>> +              */
>> +             if ((iint->flags & IMA_APPRAISAL_OPT) &&
>> +                  (rc == INTEGRITY_XATTR_NOTSUPP ||
>> +                   rc == INTEGRITY_IMA_NOLABEL))
>> +                     return 0;
>> +             else
>> +                     return -EACCES;
>
> I think there is problem here. "appraise_type=optional" can be specified
> per rule/hook. So two different hooks can specify two different rules.
>
> appraise func=MMAP_CHECK appraise_type=optional
> appraise func=BPRM_CHECK
>
> I think if a file is first mmaped(), then appraisal will take place and
> IMA_APPRAISAL_OPT will be set in iint->flags.
>
> Later when BPRM_CHECK hook gets executed, and it will return success
> based on IMA_APPRAISAL_OPT even if there was no label. And that's not
> what exec() expects.
>
> So storing IMA_APPRAISAL_OPT in iint->flags seems wrong (espectially as
> part of IMA_ACTION_FLAGS bits). I think only bits which are valid
> across all rules/hooks should be stored here.
>
> Any property which is hook/rule specific should either not be stored
> or should be stroed in hook specific property area.
>
> We don't have enough space to store more hook specific properties, so
> I will explore the option of passing around this flag when hook is being
> executed and then discard it.
>

Hi,

I think there is no need to store optional in iint->flags.
Just test "action" which is returned by ima_get_action().
Then it will be rule specific...

- Dmitry

> Thanks
> Vivek
>
>> +     }
>>       return 0;
>>  }
>>
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index 4adcd0f..fd92dc3d4 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -598,6 +598,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>>                       ima_log_string(ab, "appraise_type", args[0].from);
>>                       if ((strcmp(args[0].from, "imasig")) == 0)
>>                               entry->flags |= IMA_DIGSIG_REQUIRED;
>> +                     else if ((strcmp(args[0].from, "optional")) == 0)
>> +                             entry->flags |= IMA_APPRAISAL_OPT;
>>                       else
>>                               result = -EINVAL;
>>                       break;
>> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
>> index 0ae08fc..4d330a7 100644
>> --- a/security/integrity/integrity.h
>> +++ b/security/integrity/integrity.h
>> @@ -29,6 +29,7 @@
>>  #define IMA_ACTION_FLAGS     0xff000000
>>  #define IMA_DIGSIG           0x01000000
>>  #define IMA_DIGSIG_REQUIRED  0x02000000
>> +#define IMA_APPRAISAL_OPT    0x04000000
>>
>>  #define IMA_DO_MASK          (IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>>                                IMA_APPRAISE_SUBMASK)
>> --
>> 1.7.7.6
