Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaGGUm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:42:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53960 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751247AbaGGUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:42:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: Colin King <colin.king@canonical.com>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / EC: Free saved_ec on error exit path
Date: Mon, 07 Jul 2014 23:00:29 +0200
Message-ID: <1409471.TCjFK6RGzy@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAOLK0pxQ=iBXLDLQ8hGkeF0oLHHSs+qTa93ixqWhUh2COq-MqQ@mail.gmail.com>
References: <1404344109-30805-1-git-send-email-colin.king@canonical.com> <CAOLK0pxQ=iBXLDLQ8hGkeF0oLHHSs+qTa93ixqWhUh2COq-MqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 04, 2014 10:15:52 AM Lan Tianyu wrote:
> 2014-07-03 7:35 GMT+08:00 Colin King <colin.king@canonical.com>:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Smatch detected two memory leaks on saved_ec:
> >
> > drivers/acpi/ec.c:1070 acpi_ec_ecdt_probe() warn: possible
> >   memory leak of 'saved_ec'
> > drivers/acpi/ec.c:1109 acpi_ec_ecdt_probe() warn: possible
> >   memory leak of 'saved_ec'
> >
> > Free saved_ec on these two error exit paths to stop the memory
> > leak.  Note that saved_ec maybe null, but kfree on null is allowed.
> >
> 
> Acked-by: Lan Tianyu <tianyu.lan@intel.com>

Queued up for 3.16, thanks!

> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/acpi/ec.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> > index ad11ba4..9800f50 100644
> > --- a/drivers/acpi/ec.c
> > +++ b/drivers/acpi/ec.c
> > @@ -1066,8 +1066,10 @@ int __init acpi_ec_ecdt_probe(void)
> >         /* fall through */
> >         }
> >
> > -       if (EC_FLAGS_SKIP_DSDT_SCAN)
> > +       if (EC_FLAGS_SKIP_DSDT_SCAN) {
> > +               kfree(saved_ec);
> >                 return -ENODEV;
> > +       }
> >
> >         /* This workaround is needed only on some broken machines,
> >          * which require early EC, but fail to provide ECDT */
> > @@ -1105,6 +1107,7 @@ install:
> >         }
> >  error:
> >         kfree(boot_ec);
> > +       kfree(saved_ec);
> >         boot_ec = NULL;
> >         return -ENODEV;
> >  }
> > --
> > 2.0.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
