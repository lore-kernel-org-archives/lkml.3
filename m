Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab3BMVpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:45:31 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40073 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab3BMVp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:45:29 -0500
Message-ID: <1360791923.3524.466.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 16:45:23 -0500
In-Reply-To: <CALLzPKbdrvsPuH9t19rvQqGZ=0+abPuWPNke4FLsadj0ORieJg@mail.gmail.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
	 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
	 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
	 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
	 <CALLzPKbdrvsPuH9t19rvQqGZ=0+abPuWPNke4FLsadj0ORieJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021321-5806-0000-0000-00001F99DBC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 19:33 +0200, Kasatkin, Dmitry wrote:
> On Wed, Feb 13, 2013 at 3:44 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2013-02-13 at 15:13 +0200, Kasatkin, Dmitry wrote:
> >> On Wed, Feb 13, 2013 at 2:56 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> > On Wed, 2013-02-13 at 14:31 +0200, Kasatkin, Dmitry wrote:
> >> >> On Mon, Feb 11, 2013 at 10:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >
> >> >> > @@ -158,7 +165,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> >> >> >         }
> >> >> >         switch (xattr_value->type) {
> >> >> >         case IMA_XATTR_DIGEST:
> >> >> > -               if (iint->flags & IMA_DIGSIG_REQUIRED) {
> >> >> > +               if (iint->flags & IMA_DIGSIG_REQUIRED ||
> >> >> > +                   iint->flags & IMA_DIGSIG_OPTIONAL) {
> >> >> >                         cause = "IMA signature required";
> >> >> >                         status = INTEGRITY_FAIL;
> >> >> >                         break;
> >> >>
> >> >> This looks a bit odd... If "optional" signature is missing  - we fail..
> >> >> It is optional... Why we should fail?
> >> >
> >> > 'imasig_optional' does not only mean that the signature is optional, but
> >> > also implies that it has to be a digital signature, not a hash.  This
> >> > latter part is what IMA_DIGSIG_REQUIRED means.
> >> >
> >> > If 'imasig_optional' set both 'IMA_DIGSIG_OPTIONAL' and
> >> > 'IMA_DIGSIG_REQUIRED', then this change wouldn't be necessary.
> >> >
> >> > IMA_DIGSIG_REQUIRED would enforce that it is a signature.
> >> > IMA_DIGSIG_OPTIONAL would fail only for files with invalid signatures.
> >> >
> >>
> >> It sounds odd that optional signature is actually required.
> >> Optional for me means that it may be there or may be not.
> >> If it is not there, then it may be hash or nothing.
> >>
> >> I see it is more logical if it is "appraise_type=optional",
> >> which means that we might have no xattr value, hash or signature.
> >> It if happens to be a signature, then IMA_DIGSIG flag will be set.
> >
> > Right, 'appraise_type=' could have been defined either as a comma
> > separated list of options (eg. appraise_type=imassig,optional) or, as
> > Vivek implemented, a new option.  Eventually, we will need to extend
> > 'appraise_type=' (eg. required algorithm), but for now I don't have a
> > problem with the new option.
> >
> 
> It is not exactly what I meant. IOW, I do not want
> appraise_type=imasig,optional.
> 
> Optional for me is that xattr value is optional. It might be nothing,
> hash or imasig...

To summarize:

Option 1: appraise_type:= [[imasig] | [imahash]]  [optional]

sample rules:
# require either hash or signature
func=bprm
 
# require signature
func=bprm appraise_type=imasig

# permit nothing, hash, or signature
func=bprm appraise_type=optional

# permit nothing or hash
func=bprm appraise_type=imahash, optional

# permit nothing or signature
func=bprm appraise_type=imasig, optional


Option 2: appraise_type:= [imasig] | [imasig_optional]

As I don't see a use case for either just 'optional' or 'imahash,
optional', this leaves 'imasig,optional', which could be expressed as
'imasig_optional'.


Option 3: appraise_type:= [imasig] | [imahash] | [optional]

Dmitry is recommending this syntax, as IMA_DIGSIG will be set in the
iint flags.


Any of these options should work.

> If it would happen that it contains signature, then IMA_DIGSIG flag
> would be set,
> and process could get needed capability as Vivek wants.

With the 'optional' condition, both unsigned and validly signed files
will succeed.  One way of making this information accessible to an LSM,
would be to define a new integrity capability and set it here.  The new
integrity capability would indicate the file was validly signed. 

thanks,

Mimi

