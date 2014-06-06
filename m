Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaFFMYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:24:14 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60039 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFFMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:24:11 -0400
MIME-Version: 1.0
In-Reply-To: <1401919181.17510.36.camel@dabdike>
References: <1401917575-2954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1401919181.17510.36.camel@dabdike>
Date: Fri, 6 Jun 2014 14:24:10 +0200
Message-ID: <CAFo99gZiFsCmLZvs7CLa0K_nHm3+NmGFaUCsCqELaHZ3pe5YWw@mail.gmail.com>
Subject: Re: [PATCH] scsi: bfa: bfad_attr.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Now I have some time to check on this.
I do not make a fuss or anything, but thought nonetheless provide some feedback.

1) I did not know that Linux had strlcpy, much better choice, of course!

2) It was not clear that this was done in the code. And my thought
was, rather, just that you were not sure if there was a null character
because it used strlcpy. if this can not possibly happen would be
almost as well to switch to strcpy outright.

3) Have now checked a little deeper, but do not see the solution you
mention really.
In the function bfa_fcs_fdmi_get_portattr() a memset NULL the whole
incoming struct.

But the only thing that is done then is a:

    strncpy(port_attr->port_sym_name.symname,
        (char *)&bfa_fcs_lport_get_psym_name(port), BFA_SYMNAME_MAXLEN);

Thus not having BFA_SYMNAME_MAXLEN -1  that would be a solution.




Best regards
Rickard Strandqvist


2014-06-04 23:59 GMT+02:00 James Bottomley
<James.Bottomley@hansenpartnership.com>:
> On Wed, 2014-06-04 at 23:32 +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> This was partly found using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/scsi/bfa/bfad_attr.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
>> index 40be670..06aa3dd 100644
>> --- a/drivers/scsi/bfa/bfad_attr.c
>> +++ b/drivers/scsi/bfa/bfad_attr.c
>> @@ -843,7 +843,8 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
>>
>>       bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
>>       strncpy(symname, port_attr.port_cfg.sym_name.symname,
>> -                     BFA_SYMNAME_MAXLEN);
>> +                     sizeof(symname));
>> +     symname[sizeof(symname) - 1] = '\0';
>
> So actually, this isn't the correct pattern for this type of potential
> problem, where the problem exists, the pattern is to replace strncpy()
> with strlcpy() which does a correct null termination on truncation.
>
> In this case I presume your static checker isn't sufficiently clever to
> see that there isn't a bug because port_attr.port_cfg.sym_name.symname
> is carefully copied to be NULL terminated and always less than
> BFA_SYMNAME_MAXLEN, so when copying out of it we can rely on the NULL
> termination fitting into BFA_SYMNAME_MAXLEN.
>
> James
>
>
