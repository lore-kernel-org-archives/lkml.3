Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3JUEXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 00:23:54 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7915 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3JUEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 00:23:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 Oct 2013 21:23:52 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Oct 2013 09:53:48 +0530
Subject: RE: [PATCH] HID: i2c-hid: Stop querying for init reports
Thread-Topic: [PATCH] HID: i2c-hid: Stop querying for init reports
Thread-Index: Ac7LYlF29jLtgo/0TpiHbtmkfJQaWgCstDlA
Message-ID: <77F7DB30C698A44DA22FB222C89DE941A68D423ECA@BGMAIL01.nvidia.com>
References: <1381825709-5098-1-git-send-email-bbasu@nvidia.com>
 <CAN+gG=FukmZEpo8wvsmNeV=0h7xR9xYOPLyvYEiDq98T-4tn=A@mail.gmail.com>
In-Reply-To: <CAN+gG=FukmZEpo8wvsmNeV=0h7xR9xYOPLyvYEiDq98T-4tn=A@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9L4ORuu029036


Hi Benjamin,


> -----Original Message-----
> From: Benjamin Tissoires [mailto:benjamin.tissoires@gmail.com]
> Sent: Thursday, October 17, 2013 11:27 PM
> To: Bibek Basu
> Cc: Jiri Kosina; linux-input; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] HID: i2c-hid: Stop querying for init reports
> 
> Hi Bibek,
> 
> On Tue, Oct 15, 2013 at 4:28 AM, Bibek Basu <bbasu@nvidia.com> wrote:
> > According to specifications, HID over I2C devices are not bound to
> > respond to query for INPUT REPORTS. Thus dropping the call during init
> > as many devices does not respond causing error messages during boot.
> >
> 
> This time, the patch is removing too many things that are correct. :)
> 
> see below to know what to remove and what to keep:
> 
> > Signed-off-by: Bibek Basu <bbasu@nvidia.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 59
> > -------------------------------------------
> >  1 file changed, 59 deletions(-)
> >
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c
> > b/drivers/hid/i2c-hid/i2c-hid.c index fd7ce37..58a4f12 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -409,62 +409,6 @@ static int i2c_hid_get_report_length(struct
> hid_report *report)
> >                 report->device->report_enum[report->type].numbered +
> > 2;  }
> >
> > -static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
> > -       size_t bufsize)
> > -{
> > -       struct hid_device *hid = report->device;
> > -       struct i2c_client *client = hid->driver_data;
> > -       struct i2c_hid *ihid = i2c_get_clientdata(client);
> > -       unsigned int size, ret_size;
> > -
> > -       size = i2c_hid_get_report_length(report);
> > -       if (i2c_hid_get_report(client,
> > -                       report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> > -                       report->id, buffer, size))
> > -               return;
> > -
> > -       i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);
> > -
> > -       ret_size = buffer[0] | (buffer[1] << 8);
> > -
> > -       if (ret_size != size) {
> > -               dev_err(&client->dev, "error in %s size:%d / ret_size:%d\n",
> > -                       __func__, size, ret_size);
> > -               return;
> > -       }
> > -
> > -       /* hid->driver_lock is held as we are in probe function,
> > -        * we just need to setup the input fields, so using
> > -        * hid_report_raw_event is safe. */
> > -       hid_report_raw_event(hid, report->type, buffer + 2, size - 2, 1);
> > -}
> 
> This function should be kept
> 
> > -
> > -/*
> > - * Initialize all reports
> > - */
> > -static void i2c_hid_init_reports(struct hid_device *hid) -{
> > -       struct hid_report *report;
> > -       struct i2c_client *client = hid->driver_data;
> > -       struct i2c_hid *ihid = i2c_get_clientdata(client);
> > -       u8 *inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
> > -
> > -       if (!inbuf) {
> > -               dev_err(&client->dev, "can not retrieve initial reports\n");
> > -               return;
> > -       }
> > -
> 
> Above should be kept
> 
> > -       list_for_each_entry(report,
> > -               &hid->report_enum[HID_INPUT_REPORT].report_list, list)
> > -               i2c_hid_init_report(report, inbuf, ihid->bufsize);
> > -
> 
> these for lines should be removed (they are the one giving the errors in the
> logs)
> 
> and please keep the rest of the code as is.
> 
> 
> > -       list_for_each_entry(report,
> > -               &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
> > -               i2c_hid_init_report(report, inbuf, ihid->bufsize);
> 
> Actually, this part is very important because we have no spontaneous events
> emitted by features, so we don't know the value of the feature until we
> probed it. So please keep this part as mentioned above.

Thanks for the inputs. I am repushing  the patch. Unfortunately, looks like I need to upgrade the firmware of my HID keyboard, as it does not responds to the FEATURE_REPORT
query:(

regards
Bibek
> 
> Cheers,
> Benjamin
> 
> > -
> > -       kfree(inbuf);
> > -}
> > -
> >  /*
> >   * Traverse the supplied list of reports and find the longest
> >   */
> > @@ -683,9 +627,6 @@ static int i2c_hid_start(struct hid_device *hid)
> >                         return ret;
> >         }
> >
> > -       if (!(hid->quirks & HID_QUIRK_NO_INIT_REPORTS))
> > -               i2c_hid_init_reports(hid);
> > -
> >         return 0;
> >  }
> >
> > --
> > 1.8.1.5
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
