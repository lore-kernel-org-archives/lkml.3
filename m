Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab3BMNgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:36:50 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:41272 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab3BMNgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:36:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130213132920.GA3540@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	<1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	<1360620614.3524.223.camel@falcor1.watson.ibm.com>
	<20130212142636.GA23410@redhat.com>
	<1360689247.3524.275.camel@falcor1.watson.ibm.com>
	<20130212185203.GA29958@redhat.com>
	<20130212185725.GC23410@redhat.com>
	<CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
	<20130213132920.GA3540@redhat.com>
Date: Wed, 13 Feb 2013 15:36:45 +0200
Message-ID: <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should not be the only line in the policy.
Can you share full policy?

Thanks,
Dmitry


On Wed, Feb 13, 2013 at 3:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 13, 2013 at 02:14:55PM +0200, Kasatkin, Dmitry wrote:
>> Hello Vivek,
>>
>> Can you please send to us how your IMA policy looks like.
>
> Hi Dmitry,
>
> For testing purposes, I am using following.
>
> appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_optional
>
> I set this using /sys/kernel/security/policy interface after boot.
>
> Thanks
> Vivek
>
>>
>> Thanks,
>> Dmitry
>>
>> On Tue, Feb 12, 2013 at 8:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Tue, Feb 12, 2013 at 01:52:03PM -0500, Vivek Goyal wrote:
>> >> On Tue, Feb 12, 2013 at 12:14:07PM -0500, Mimi Zohar wrote:
>> >>
>> >> [..]
>> >> > > > > --- a/security/integrity/ima/ima_appraise.c
>> >> > > > > +++ b/security/integrity/ima/ima_appraise.c
>> >> > > > > @@ -124,19 +124,26 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>> >> > > > >       enum integrity_status status = INTEGRITY_UNKNOWN;
>> >> > > > >       const char *op = "appraise_data";
>> >> > > > >       char *cause = "unknown";
>> >> > > > > -     int rc;
>> >> > > > > +     int rc, audit_info = 0;
>> >> > > > >
>> >> > > > >       if (!ima_appraise)
>> >> > > > >               return 0;
>> >> > > > > -     if (!inode->i_op->getxattr)
>> >> > > > > +     if (!inode->i_op->getxattr) {
>> >> > > > > +             /* getxattr not supported. file couldn't have been signed */
>> >> > > > > +             if (iint->flags & IMA_DIGSIG_OPTIONAL)
>> >> > > > > +                     return INTEGRITY_PASS;
>> >> > > > >               return INTEGRITY_UNKNOWN;
>> >> > > > > +     }
>> >> > > > >
>> >> > > >
>> >> > > > Please don't change the result of the appraisal like this.  A single
>> >> > > > change can be made towards the bottom of process_measurement().
>> >> > >
>> >> > > I don't want to pass integrity in all cases of INTEGRITY_UNKNOWN. So
>> >> > > I can probably maintain a bool variable, say pass_appraisal, and set
>> >> > > that here and at the end of function, parse that variable and change
>> >> > > the status accordingly.
>> >> >
>> >> > process_measurement() is the only caller of ima_appraise_measurement().
>> >> > Leave the results of ima_appraise_measurement() alone.  There's already
>> >> > code at the end of process_measurement() which decides what to return.
>> >> > Just modify it based on the appraisal results.
>> >>
>> >
>> > If we do this, audit logs will be filled with integrity unknown failures.
>> > As each unsigned executable file will fail appraisal with INTEGRITY_UNKNOWN
>> > and an audit message will be logged.
>> >
>> > Thanks
>> > Vivek
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
