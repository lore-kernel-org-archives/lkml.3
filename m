Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890Ab3DCUoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:44:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:26691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760396Ab3DCUoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,403,1363158000"; 
   d="scan'208";a="311947124"
From: "Kankroliwala, Huzefa NomanX" <huzefa.nomanx.kankroliwala@intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: "jkosina@suse.cz" <jkosina@suse.cz>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-hid: fix length for set/get report in i2c hid
Thread-Topic: [PATCH] i2c-hid: fix length for set/get report in i2c hid
Thread-Index: AQHOL9Lq0/7mzImuFUq4xX7kT8N6j5jEqM0AgABPDSA=
Date: Wed, 3 Apr 2013 20:44:10 +0000
Message-ID: <D27C2409FF7E784EAE126953311D1A831381348A@ORSMSX103.amr.corp.intel.com>
References: <1364899967-18118-1-git-send-email-huzefa.nomanx.kankroliwala@intel.com>
 <CAN+gG=HWPCn8pdVtJUf+ijunm7hwgb-DpmNQzyRf2n3_m49+_w@mail.gmail.com>
In-Reply-To: <CAN+gG=HWPCn8pdVtJUf+ijunm7hwgb-DpmNQzyRf2n3_m49+_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,
Thanks for reviewing!

> -----Original Message-----
> From: Benjamin Tissoires [mailto:benjamin.tissoires@gmail.com]
> Sent: Wednesday, April 03, 2013 2:00 AM
> To: Kankroliwala, Huzefa NomanX
> Cc: jkosina@suse.cz; Westerberg, Mika; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c-hid: fix length for set/get report in i2c hid
> 
> Hi Huzefa,
> 
> On Tue, Apr 2, 2013 at 12:52 PM, Huzefa Kankroliwala
> <huzefa.nomanx.kankroliwala@intel.com> wrote:
> > With the current i2c hid driver set/get report does not work as
> > expected, for e.g sensor hub properties like power state, frequency
> > etc is not set properly on the device as a result we do not get
> > events.
> > The problem is that i2c hid driver in function i2c_hid_request sets
> > length equal to default buffer size for which the sensor hub does not
> > respond on get/set commands. Use report length and calculate it based
> > on report size and id.
> 
> oops, seems like I've been too lazy to get the actual size. Thanks for fixing it.
> 
> I just have one small formatting comment (see below).
> Except that, Reviewed-by: Benjamin Tissoires
> <benjamin.tissoires@redhat.com>
> 
> >
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Huzefa Kankroliwala
> > <huzefa.nomanx.kankroliwala@intel.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c
> > b/drivers/hid/i2c-hid/i2c-hid.c index 935f387..c8cd0c0 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -567,18 +567,18 @@ static void i2c_hid_request(struct hid_device
> *hid, struct hid_report *rep,
> >                 int reqtype)
> >  {
> >         struct i2c_client *client = hid->driver_data;
> > -       struct i2c_hid *ihid = i2c_get_clientdata(client);
> >         char *buf;
> >         int ret;
> > +       int len = i2c_hid_get_report_length(rep) - 2;
> >
> > -       buf = kzalloc(ihid->bufsize, GFP_KERNEL);
> > +       buf = kzalloc(len, GFP_KERNEL);
> >         if (!buf)
> >                 return;
> >
> >         switch (reqtype) {
> >         case HID_REQ_GET_REPORT:
> > -               ret = i2c_hid_get_raw_report(hid, rep->id, buf, ihid->bufsize,
> > -                                            rep->type);
> > +               ret = i2c_hid_get_raw_report(hid, rep->id, buf, len,
> > +                                                       rep->type);
> 
> No need to add a new line for rep->type when the 80 columns limit is not
> reached.
Fixed this in Patch v2

Thanks
Huzefa
> 
> Cheers,
> Benjamin
> 
> >                 if (ret < 0)
> >                         dev_err(&client->dev, "%s: unable to get report: %d\n",
> >                                 __func__, ret); @@ -587,7 +587,7 @@
> > static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
> >                 break;
> >         case HID_REQ_SET_REPORT:
> >                 hid_output_report(rep, buf);
> > -               i2c_hid_output_raw_report(hid, buf, ihid->bufsize, rep->type);
> > +               i2c_hid_output_raw_report(hid, buf, len, rep->type);
> >                 break;
> >         }
> >
> > --
> > 1.7.4.1
> >
