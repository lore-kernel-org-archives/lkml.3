Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbaFRHfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:35:14 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61311 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaFRHfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:35:12 -0400
Date: Wed, 18 Jun 2014 08:35:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Simon Glass <sjg@chromium.org>, Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] mfd: cros_ec: Check result code from EC messages
Message-ID: <20140618073505.GC21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-10-git-send-email-dianders@chromium.org>
 <CAPnjgZ3qqRiLvgnkCSoUTTkL8XvRHNkrFhfqi_Fofx-5ixU5LQ@mail.gmail.com>
 <CAD=FV=WNWt111t3wYnOA2npPnAUdnFUC5WbLe+t6n0nJPeiqCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=WNWt111t3wYnOA2npPnAUdnFUC5WbLe+t6n0nJPeiqCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Doug Anderson wrote:

> Simon,
> 
> On Tue, Jun 17, 2014 at 8:43 PM, Simon Glass <sjg@chromium.org> wrote:
> >> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> >> index 09ca789..4d34f1c 100644
> >> --- a/drivers/mfd/cros_ec_spi.c
> >> +++ b/drivers/mfd/cros_ec_spi.c
> >> @@ -289,21 +289,23 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
> >>                 goto exit;
> >>         }
> >>
> >> -       /* check response error code */
> >>         ptr = ec_dev->din;
> >> -       if (ptr[0]) {
> >> -               if (ptr[0] == EC_RES_IN_PROGRESS) {
> >> -                       dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
> >> -                               ec_msg->command);
> >> -                       ret = -EAGAIN;
> >> -                       goto exit;
> >> -               }
> >> -               dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
> >> -                        ec_msg->command, ptr[0]);
> >> -               debug_packet(ec_dev->dev, "in_err", ptr, len);
> >> -               ret = -EINVAL;
> >> +
> >> +       /* check response error code */
> >> +       ec_msg->result = ptr[0];
> >> +       switch (ec_msg->result) {
> >> +       case EC_RES_SUCCESS:
> >> +               break;
> >> +       case EC_RES_IN_PROGRESS:
> >> +               ret = -EAGAIN;
> >> +               dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
> >> +                       ec_msg->command);
> >>                 goto exit;
> >> +       default:
> >> +               dev_warn(ec_dev->dev, "command 0x%02x returned %d\n",
> >> +                        ec_msg->command, ec_msg->result);
> >>         }
> >
> > Since this code is the same as the above, should it go in a common
> > function in cros_ec?
> 
> So you are thinking it should be written like:
> 
> ec_msg->result = ptr[0];
> ret = cros_ec_check_result(ec_dev, ec_msg);
> if (ret)
>   goto exit;
> 
> ---
> 
> int cros_ec_check_result(struct cros_ec_device *ec_dev, struct
> cros_ec_command *ec_msg)
> {
>        switch (ec_msg->result) {
>        case EC_RES_SUCCESS:
>                return 0;
>        case EC_RES_IN_PROGRESS:
>                dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
>                        ec_msg->command);
>                return -EAGAIN;
>        default:
>                dev_warn(ec_dev->dev, "command 0x%02x returned %d\n",
>                         ec_msg->command, ec_msg->result);
>                return 0;
> }
> 
> OK, that seems reasonable.  I'll plan to spin tomorrow with that.

+1

I'll do a proper review when you re-spin the patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
