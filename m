Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3EWNKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:10:25 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64356 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab3EWNKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <1368506210.17660.11.camel@joe-AO722>
References: <1368492098-3140-1-git-send-email-ruslan.bilovol@ti.com>
	<1368506210.17660.11.camel@joe-AO722>
Date: Thu, 23 May 2013 16:10:23 +0300
X-Google-Sender-Auth: 27miyxustG812tA04zhDdEDoBkA
Message-ID: <CAB=otbQPchFcgAAAStmu_yL4swBF=GRLXqTUGV8YWZg1dGSC-w@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: add check for wrong "if (IS_ERR_OR_NULL(<foo>))
 return PTR_ERR(<foo>)" uses
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Joe Perches <joe@perches.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thank you for looking into this.

On Tue, May 14, 2013 at 7:36 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-05-14 at 03:41 +0300, Ruslan Bilovol wrote:
>> This was many times discussed by Russell King
>> and I also was about wrong usage of IS_ERR_OR_NULL()
>> in my patch. So I added this check and other people will
>> be at least warned about potentially wrong usage
>> of mentioned macro.
> []
>> Tested on:
>> +     if (IS_ERR_OR_NULL(soc_dev))
>> +             return PTR_ERR(soc_dev);
>> +
>> +     if (IS_ERR_OR_NULL(soc_dev))en
>> +             return soc_dev ? PTR_ERR(soc_dev) : -ENODEV;
>
> I did a grep for IS_ERR_OR_NULL and this misses variants like:
>
>                 if (unlikely(IS_ERR_OR_NULL(etc...

Agree, I checked and you are right

>
> Perhaps something like this?

hmm.. your variant have false positives.
I used next 2 examples for verification:

This one - is incorrect usage of IS_ERR_OR_NULL
+     if (IS_ERR_OR_NULL(soc_dev))
+             return PTR_ERR(soc_dev);

But this one is correct and checkpach shouldn't react here but in your
version does react
+     if (IS_ERR_OR_NULL(soc_dev))
+             return soc_dev ? PTR_ERR(soc_dev) : -ENODEV;

Care to fix it?

Best regards,
Ruslan

> ---
>  scripts/checkpatch.pl | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b954de5..18c7d8c 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2184,6 +2184,15 @@ sub process {
>                                 WARN("SUSPECT_CODE_INDENT",
>                                      "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
>                         }
> +
> +# check for misuses of IS_ERR_OR_NULL
> +                       if ($stat =~ /^\+.*\bIS_ERR_OR_NULL\s*\(\s*($Lval)\s*\)/) {
> +                               my $test = $1;
> +                               if ($stat =~ /\bPTR_ERR\s*\(\s*${test}\s*\)/) {
> +                                       WARN("IS_ERR_OR_NULL",
> +                                            "Use of IS_ERR_OR_NULL($test) with PTR_ERR($test) is usually wrong: see http://permalink.gmane.org/gmane.linux.ports.arm.omap/97874\n" . $herecurr . "$stat_real\n");
> +                               }
> +                       }
>                 }
>
>                 # Track the 'values' across context and added lines.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
