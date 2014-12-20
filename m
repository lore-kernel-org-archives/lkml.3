Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaLTV3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 16:29:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:59357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaLTV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 16:29:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,615,1413270000"; 
   d="scan'208";a="657787336"
From: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
To: "Baluta, Daniel" <daniel.baluta@intel.com>
CC: "lars@metafoo.de" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "knaack.h@gmx.de" <knaack.h@gmx.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Purdila, Octavian" <octavian.purdila@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "pmeerw@pmeerw.net" <pmeerw@pmeerw.net>,
        "beomho.seo@samsung.com" <beomho.seo@samsung.com>,
        "gwendal@chromium.org" <gwendal@chromium.org>
Subject: Re: [RFC PATCH] iio: ak8975: Make sure chipset is always initialized
Thread-Topic: [RFC PATCH] iio: ak8975: Make sure chipset is always
 initialized
Thread-Index: AQHQHJv/pV0/XzoQpUK45pIcNb1+QA==
Date: Sat, 20 Dec 2014 21:29:12 +0000
Message-ID: <1419110952.2843.8.camel@spandruv-hsb-test>
References: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
	 <5494A3D6.60607@gmx.de>
	 <CAEnQRZABxH5MuWEnS=RHmQqGUN0QhFTtXxnM1uyrLxvP2a-Rmg@mail.gmail.com>
	 <1419110796.2843.6.camel@spandruv-hsb-test>
In-Reply-To: <1419110796.2843.6.camel@spandruv-hsb-test>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.13.126]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E4228446C73A34BB6959D0EE32CF8A5@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBKLTOUc026111

+Mika

On Sat, 2014-12-20 at 13:26 -0800, Srinivas Pandruvada wrote:
> On Sat, 2014-12-20 at 00:25 +0200, Daniel Baluta wrote:
> > On Sat, Dec 20, 2014 at 12:16 AM, Hartmut Knaack <knaack.h@gmx.de> wrote:
> > > Daniel Baluta schrieb am 18.12.2014 um 18:16:
> > >> When using ACPI, if acpi_match_device fails then chipset enum will be
> > >> uninitialized and &ak_def_array[chipset] will point to some bad address.
> > >>
> I am missing something. You are enumerated over i2c device, which was
> created from ACPI PNP resource. There is a valid handle or and the
> device has an ACPI companion at the least. If this failing, I have to
> check the code for acpi i2c.
> Can you check why this check failed? We may have bug in i2c handling.
> 
> Thanks,
> Srinivas
> 
> > >> This fixes the following compilation warning:
> > >>
> > >> drivers/iio/magnetometer/ak8975.c: In function â€˜ak8975_probeâ€™:
> > >> drivers/iio/magnetometer/ak8975.c:788:14: warning: â€˜chipsetâ€™ may be used
> > >> uninitialized in this function [-Wmaybe-uninitialized]
> > >>   data->def =ak_def_array[chipset];
> > >>
> > >> Reported-by: Octavian Purdila <octavian.purdila@intel.com>
> > >> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> > >> ---
> > >> This is a RFC because while I'm pretty sure that chipset should be initialized
> > >> with AK_MAX_TYPE in ak8975_match_acpi_device, I am not sure if we can live with
> > >> a NULL return value of ak8975_match_acpi_device. Current implementation ignores
> > >> return value of ak8975_match_acpi_device.
> > > This seems to be the actual problem: these _match_acpi_device functions return
> > > NULL on failure, and this should be checked for.
> > 
> > Ok, so this would acceptable?
> > 
> > diff --git a/drivers/iio/magnetometer/ak8975.c
> > b/drivers/iio/magnetometer/ak8975.c
> > index 0d10a4b..68d99e9 100644
> > --- a/drivers/iio/magnetometer/ak8975.c
> > +++ b/drivers/iio/magnetometer/ak8975.c
> > @@ -776,8 +776,9 @@ static int ak8975_probe(struct i2c_client *client,
> >                 name = id->name;
> >         } else if (ACPI_HANDLE(&client->dev))
> >                 name = ak8975_match_acpi_device(&client->dev, &chipset);
> > -       else
> > -               return -ENOSYS;
> > +
> > +       if (!name)
> > +               return -ENODEV;
> > 
> > 
> > I still have some doubts about return code in case of error.
> > 
> > For ak8975 we use -ENOSYS, but for kxcjk-1013 we use -ENODEV.
> > 
> > I will send a patch after we clear this out.
> > 
> > thanks,
> > Daniel.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
