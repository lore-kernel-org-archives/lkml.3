Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaDNQAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:00:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12366 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaDNQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:00:15 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-67-534c060dd9b5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Shiraz Hashim <shiraz.hashim@st.com>,
        "...)" <linux-ide@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pata_arasan_cf: fix ata_host_activate() failure handling
Date: Mon, 14 Apr 2014 18:00:04 +0200
Message-id: <1861056.i4MLEJ6v1d@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAOh2x=n8PGuykczfpi0T1-WwVmakURyX+RuuOQiFVhpYPmrS6A@mail.gmail.com>
References: <7093981.6c4k98qyGh@amdc1032>
 <CAOh2x=n8PGuykczfpi0T1-WwVmakURyX+RuuOQiFVhpYPmrS6A@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jAV1eNp9ggwkbLSw2Pb7GanFsxyMm
	i8u75rBZNHT3sFvMmbGZ1eLX8qOMFhu/ejiwe2xa1cnmcefaHjaPkxdOsnhsXlLv8fTHXmaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDKmLn7GVDCJr+LVvD1sDYynuLoYOTkkBEwknh7bzARhi0lc
	uLeeDcQWEljEKDFjoW0XIxeQ3cIk8XHKD7AiNgEriYntqxi7GDk4RAS0JF7eTAWpYRZYxCRx
	8/RHsGZhAV+JCz23WEFsFgFViT8LmsHivAKaEvfbr7GA2KICnhI7tq8Ei3MKBEv82jaPFWJx
	gcTk3mvsEPWCEj8m3wOrZxaQl9i3fyorhK0jsb91GtsERoFZSMpmISmbhaRsASPzKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzgUH8mtYNxZYPFIUYBDkYlHt4J77yDhVgTy4orcw8xSnAw
	K4nwum4FCvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamAU
	Yi9K5L4v7rFpTeCT+vQZPdfkTdRPvXSR/vL7+gmrSy2tvH/NYuyeRNgG3HY9FerKcig2QO2N
	39mf0y8LC81f09THyVhncMr0j3fZVYUfmd+FNnxeGv/JoPDo7JOzt2/6+3DrLoFy6amuISrJ
	TjMLr23xvrvaUt9B9/bZu5obNCwzo1e7yR5UYinOSDTUYi4qTgQA5s1A0XECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, April 01, 2014 09:50:42 AM Viresh Kumar wrote:
> On Mon, Mar 31, 2014 at 11:19 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Add missing cf_exit() and clk_put() calls to ata_host_activate()
> > failure path.
> >
> > Cc: Viresh Kumar <viresh.linux@gmail.com>
> > Cc: Shiraz Hashim <shiraz.hashim@st.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/ata/pata_arasan_cf.c |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > Index: b/drivers/ata/pata_arasan_cf.c
> > ===================================================================
> > --- a/drivers/ata/pata_arasan_cf.c      2014-03-31 16:57:47.443727785 +0200
> > +++ b/drivers/ata/pata_arasan_cf.c      2014-03-31 17:09:48.171715498 +0200
> > @@ -898,9 +898,15 @@ static int arasan_cf_probe(struct platfo
> >
> >         cf_card_detect(acdev, 0);
> >
> > -       return ata_host_activate(host, acdev->irq, irq_handler, 0,
> > -                       &arasan_cf_sht);
> > +       ret = ata_host_activate(host, acdev->irq, irq_handler, 0,
> > +                               &arasan_cf_sht);
> > +       if (ret)
> > +               goto exit_cf;
> >
> > +       return 0;
> 
> Probably this would be better:
> 
> if (!ret)
>     return 0
> 
> and then no need of a goto..

I considered doing it this way initially but decided that code consistency
with other host drivers is more important.  However if this is what you
prefer I'll re-do the patch and post it as v2.

> > +
> > +exit_cf:
> > +       cf_exit(acdev);
> >  free_clk:
> >         clk_put(acdev->clk);
> >         return ret;
> >

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

