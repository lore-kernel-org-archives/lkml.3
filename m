Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3EaWVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:21:34 -0400
Received: from forward10.mail.yandex.net ([77.88.61.49]:52546 "EHLO
	forward10.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3EaWV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:21:29 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 18:21:28 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        =?utf-8?B?VHJlcMOhayBWaWxtb3M=?= <trepo@netcomga.sk>
In-Reply-To: <1360371370037208@web3f.yandex.ru>
References: <1360371370037208@web3f.yandex.ru>
Subject: Re: [PATCH]hp-wmi: Fix gps support in hp_wmi_rfkill_setup()
MIME-Version: 1.0
Message-Id: <1307091370038533@web21e.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 01 Jun 2013 02:15:33 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more error.. I'll resend patch to x86-platform mailing list

01.06.2013, 01:53, "Kirill Tkhai" <tkhai@yandex.ru>:
> Current gps support in hp_wmi_rfkill_setup() looks like bad copy/past.
> It leads to kernel panic on my HP530 laptop. So I did:
>
> 1)Fix wwan/gps register_*_error label order
> 2)Fix rfkill_set_hw_state() wrong argument in case of gps
>
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Matthew Garrett <matthew.garrett@nebula.com>
> CC: Trepák Vilmos <trepo@netcomga.sk>
> ---
>  drivers/platform/x86/hp-wmi.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
> index 45cacf7..cdb8afb 100644
> --- a/drivers/platform/x86/hp-wmi.c
> +++ b/drivers/platform/x86/hp-wmi.c
> @@ -658,7 +658,7 @@ static int hp_wmi_rfkill_setup(struct platform_device *device)
>                                             (void *) HPWMI_WWAN);
>                  if (!wwan_rfkill) {
>                          err = -ENOMEM;
> - goto register_gps_error;
> + goto register_bluetooth_error;
>                  }
>                  rfkill_init_sw_state(wwan_rfkill,
>                                       hp_wmi_get_sw_state(HPWMI_WWAN));
> @@ -666,7 +666,7 @@ static int hp_wmi_rfkill_setup(struct platform_device *device)
>                                      hp_wmi_get_hw_state(HPWMI_WWAN));
>                  err = rfkill_register(wwan_rfkill);
>                  if (err)
> - goto register_wwan_err;
> + goto register_wwan_error;
>          }
>
>          if (wireless & 0x8) {
> @@ -676,11 +676,11 @@ static int hp_wmi_rfkill_setup(struct platform_device *device)
>                                                  (void *) HPWMI_GPS);
>                  if (!gps_rfkill) {
>                          err = -ENOMEM;
> - goto register_bluetooth_error;
> + goto register_wwan_error;
>                  }
>                  rfkill_init_sw_state(gps_rfkill,
>                                       hp_wmi_get_sw_state(HPWMI_GPS));
> - rfkill_set_hw_state(bluetooth_rfkill,
> + rfkill_set_hw_state(gps_rfkill,
>                                      hp_wmi_get_hw_state(HPWMI_GPS));
>                  err = rfkill_register(gps_rfkill);
>                  if (err)
> @@ -688,16 +688,16 @@ static int hp_wmi_rfkill_setup(struct platform_device *device)
>          }
>
>          return 0;
> -register_wwan_err:
> - rfkill_destroy(wwan_rfkill);
> - wwan_rfkill = NULL;
> - if (gps_rfkill)
> - rfkill_unregister(gps_rfkill);
>  register_gps_error:
>          rfkill_destroy(gps_rfkill);
>          gps_rfkill = NULL;
>          if (bluetooth_rfkill)
>                  rfkill_unregister(bluetooth_rfkill);
> +register_wwan_error:
> + rfkill_destroy(wwan_rfkill);
> + wwan_rfkill = NULL;
> + if (gps_rfkill)
> + rfkill_unregister(gps_rfkill);
>  register_bluetooth_error:
>          rfkill_destroy(bluetooth_rfkill);
>          bluetooth_rfkill = NULL;
