Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487Ab3BMSVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:21:01 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:51836 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475Ab3BMSU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130213175115.GF6750@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	<1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	<CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
	<1360760195.3524.355.camel@falcor1.watson.ibm.com>
	<CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
	<1360763044.3524.367.camel@falcor1.watson.ibm.com>
	<CALLzPKbdrvsPuH9t19rvQqGZ=0+abPuWPNke4FLsadj0ORieJg@mail.gmail.com>
	<20130213175115.GF6750@redhat.com>
Date: Wed, 13 Feb 2013 20:20:57 +0200
Message-ID: <CALLzPKYADGnV+S4+pDZrteK-O7pb6DdthKwtdHnDU-KDb1eJHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 7:51 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 13, 2013 at 07:33:13PM +0200, Kasatkin, Dmitry wrote:
>> On Wed, Feb 13, 2013 at 3:44 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > On Wed, 2013-02-13 at 15:13 +0200, Kasatkin, Dmitry wrote:
>> >> On Wed, Feb 13, 2013 at 2:56 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> >> > On Wed, 2013-02-13 at 14:31 +0200, Kasatkin, Dmitry wrote:
>> >> >> On Mon, Feb 11, 2013 at 10:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> >
>> >> >> > @@ -158,7 +165,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>> >> >> >         }
>> >> >> >         switch (xattr_value->type) {
>> >> >> >         case IMA_XATTR_DIGEST:
>> >> >> > -               if (iint->flags & IMA_DIGSIG_REQUIRED) {
>> >> >> > +               if (iint->flags & IMA_DIGSIG_REQUIRED ||
>> >> >> > +                   iint->flags & IMA_DIGSIG_OPTIONAL) {
>> >> >> >                         cause = "IMA signature required";
>> >> >> >                         status = INTEGRITY_FAIL;
>> >> >> >                         break;
>> >> >>
>> >> >> This looks a bit odd... If "optional" signature is missing  - we fail..
>> >> >> It is optional... Why we should fail?
>> >> >
>> >> > 'imasig_optional' does not only mean that the signature is optional, but
>> >> > also implies that it has to be a digital signature, not a hash.  This
>> >> > latter part is what IMA_DIGSIG_REQUIRED means.
>> >> >
>> >> > If 'imasig_optional' set both 'IMA_DIGSIG_OPTIONAL' and
>> >> > 'IMA_DIGSIG_REQUIRED', then this change wouldn't be necessary.
>> >> >
>> >> > IMA_DIGSIG_REQUIRED would enforce that it is a signature.
>> >> > IMA_DIGSIG_OPTIONAL would fail only for files with invalid signatures.
>> >> >
>> >>
>> >> It sounds odd that optional signature is actually required.
>> >> Optional for me means that it may be there or may be not.
>> >> If it is not there, then it may be hash or nothing.
>> >>
>> >> I see it is more logical if it is "appraise_type=optional",
>> >> which means that we might have no xattr value, hash or signature.
>> >> It if happens to be a signature, then IMA_DIGSIG flag will be set.
>> >
>> > Right, 'appraise_type=' could have been defined either as a comma
>> > separated list of options (eg. appraise_type=imassig,optional) or, as
>> > Vivek implemented, a new option.  Eventually, we will need to extend
>> > 'appraise_type=' (eg. required algorithm), but for now I don't have a
>> > problem with the new option.
>> >
>>
>> It is not exactly what I meant. IOW, I do not want
>> appraise_type=imasig,optional.
>>
>> Optional for me is that xattr value is optional. It might be nothing,
>> hash or imasig...
>>
>> If it would happen that it contains signature, then IMA_DIGSIG flag
>> would be set,
>> and process could get needed capability as Vivek wants.
>
> Hi Dmitry,
>
> While we are at it, I thought I will mention what else is going in my
> mind w.r.t next step.
>
> I looked at your patch. That patch looks at IMG_DIGSIG
> flag and sets bprm->unsafe with appropriate flag. It works well if
> signature verification before loading executable alone is sufficient.
>
> But this leaves a small window open where somebody could write to the
> disk block directly (bypass filesystem) after IMA signature verification.
> Then modified image will be loaded by the binary handler.
>
> To avoid that, I think I will need to do appraisal after loading the file
> (with VM_LOCKED flag).
>
> I guess I will need to introduce another hook say bprm_post_load() to
> verify integrity of file.
>
> So this raises few questions.
>
> - Are two appraisals really necessary. From my use case perspective
>   initially I just need to know whether digital signature are present
>   or not and appraisal of file is not required. I guess it is one
>   optimization area to keep appraisal overhead minimum in exec() path.
>
> - When I go for second appraisal after loading file, current IMA code
>   will have success result in iint->flags. I need to figure a way out
>   to reset cache result and force reappraisal.
>
> Thanks
> Vivek

Hello,

My patch was just a 5 minute example how to go with that.
Sure, when we deal with MAP_LOCKED, we might do appraisal after
loading the binary.
Yes, it looks like that we really need another hook for that...

But then process_measurement might do things a bit differently.
It might check the policy, allocated iint and return if locking is
needed (or another hook will be called).
Next hook will just collect and appriase...

- Dmitry
