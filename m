Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbbASQ4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:56:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:59230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbASQ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:56:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,428,1418112000"; 
   d="scan'208";a="514368842"
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
Thread-Index: AQHQHJv/pV0/XzoQpUK45pIcNb1+QJzIOKwAgAAiaICAAAGLAIAAAd8A
Date: Mon, 19 Jan 2015 16:56:45 +0000
Message-ID: <1421686560.4459.400.camel@spandruv-desktop.jf.intel.com>
References: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
	 <5494A3D6.60607@gmx.de>
	 <CAEnQRZABxH5MuWEnS=RHmQqGUN0QhFTtXxnM1uyrLxvP2a-Rmg@mail.gmail.com>
	 <1419110796.2843.6.camel@spandruv-hsb-test>
	 <1419110952.2843.8.camel@spandruv-hsb-test>
	 <CAEnQRZC_SR_p2oYq9EpDDfBi2nCAAWvYmf0tR7V7WPZRZEp79g@mail.gmail.com>
	 <1421685827.4459.397.camel@spandruv-desktop.jf.intel.com>
	 <CAEnQRZAfRJ+-1x_ZgRAC2Kkr2js4EQB1xA6gTJ5n0uCAZS4y2g@mail.gmail.com>
In-Reply-To: <CAEnQRZAfRJ+-1x_ZgRAC2Kkr2js4EQB1xA6gTJ5n0uCAZS4y2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.7.199.150]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D26A7C13AC7424199C30616CF3BCCED@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0JGuwq2004867

On Mon, 2015-01-19 at 18:49 +0200, Daniel Baluta wrote: 
> On Mon, Jan 19, 2015 at 6:44 PM, Pandruvada, Srinivas
> <srinivas.pandruvada@intel.com> wrote:
> > On Mon, 2015-01-19 at 16:40 +0200, Daniel Baluta wrote:
> >> Hello,
> >>
> >> On Sat, Dec 20, 2014 at 11:29 PM, Pandruvada, Srinivas
> >> <srinivas.pandruvada@intel.com> wrote:
> >> > +Mika
> >> >
> >> > On Sat, 2014-12-20 at 13:26 -0800, Srinivas Pandruvada wrote:
> >> >> On Sat, 2014-12-20 at 00:25 +0200, Daniel Baluta wrote:
> >> >> > On Sat, Dec 20, 2014 at 12:16 AM, Hartmut Knaack <knaack.h@gmx.de> wrote:
> >> >> > > Daniel Baluta schrieb am 18.12.2014 um 18:16:
> >> >> > >> When using ACPI, if acpi_match_device fails then chipset enum will be
> >> >> > >> uninitialized and &ak_def_array[chipset] will point to some bad address.
> >> >> > >>
> >> >> I am missing something. You are enumerated over i2c device, which was
> >> >> created from ACPI PNP resource. There is a valid handle or and the
> >> >> device has an ACPI companion at the least. If this failing, I have to
> >> >> check the code for acpi i2c.
> >> >> Can you check why this check failed? We may have bug in i2c handling.
> >>
> >> You are right about this. Under normal circumstances, if probe is called
> >> then acpi_match_device will not fail. I even tried to remove the
> >> device after probe
> >> but before acpi_match_device, anyhow acpi_match_device was still successful :)
> >>
> >> This is more a matter of code correctness.
> >>
> >> In ak8975_match_acpi_device we have:
> >>
> >> Â»       const struct acpi_device_id *id;
> >>
> >> Â»       id = acpi_match_device(dev->driver->acpi_match_table, dev);
> >> Â»       if (!id)
> >> Â»       Â»       return NULL;
> >> Â»       *chipset = (int)id->driver_data;
> >>
> >> Compiler complains on the fact that chipset might be uninitialized
> >> if this returns NULL, and we shouldn't ignore this warning even this case
> >> will never happen.
> >>
> > Will this fix?
> > data->chipset = AK8975;
> > before
> > ak8975_match_acpi_device(&client->dev, &data->chipset);
> >
> 
> Yes, this is done in the original patch:
> 
> +       *chipset = AK_MAX_TYPE;
Since data memory is not zero alloced, other member of data are anyway
initialized, so adding this also may be better. 
> 
> .. and fixes the warning.
> 
> Daniel.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
