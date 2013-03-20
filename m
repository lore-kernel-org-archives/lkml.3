Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3CTLqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:46:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3CTLqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:46:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Wed, 20 Mar 2013 11:46:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <201303201020.14654.arnd@arndb.de> <CAHkwnC-8FH0nyJ+eT=+7doP+fSdZjNYUW4zzs_r6e9wt3Yt4Fg@mail.gmail.com>
In-Reply-To: <CAHkwnC-8FH0nyJ+eT=+7doP+fSdZjNYUW4zzs_r6e9wt3Yt4Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303201146.07987.arnd@arndb.de>
X-Provags-ID: V02:K0:Dx5NgLEfFpWU5Svd5c/nPezGAybMrJkU4zCAGfWu7nT
 U55v+w2rD6s2r5gFe2gRr0wqm6W1g3aBZ3e5X2o5DLfHr2ghpr
 3HPopTla9OaosRxE9+XUv3VskiNkhm881rbhsND1HpkN/RrDty
 0+2cb5ljWICdTWz54+gFYnTDBUrEJlIOVOtQBb1VBaLr7vwlF9
 t+gx0Ud6K88TdrVbJiXPESTvE+vCr0mU3zeljlhghX1Hlgp+a/
 veSGbyqkueF98bftByIW51cLIw7KOeTegDuZqtrl04/RNgSGV2
 75SEtwBXuLuWiBIXchyhTUssKCD5lo2hxq/EoaLGl4zstjcyNg
 C/UGY2GOSc3KJnr/hNXs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013, Fabio Porcedda wrote:
> 
> On Wed, Mar 20, 2013 at 11:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 20 March 2013, Fabio Porcedda wrote:
> >> I think we can check inside the  deferred_probe_work_func()
> >> if the dev->probe function pointer is equal to platform_drv_probe_fail().
> >
> > I think it's too late by then, because that would only warn if we try to probe
> > it again, but when platform_driver_probe() does not succeed immediately, it
> 
> Maybe you mean "does succeed immediately" ?

I mean in this code (simplified for the sake of discussion)

int __init_or_module platform_driver_probe(struct platform_driver *drv,
                int (*probe)(struct platform_device *))
{
        int retval, code;

        drv->probe = probe;
        retval = code = platform_driver_register(drv);

        drv->probe = NULL;
        if (code == 0 && list_empty(&drv->driver.p->klist_devices.k_list))
                retval = -ENODEV;
        drv->driver.probe = platform_drv_probe_fail;

        if (code != retval)
                platform_driver_unregister(drv);
        return retval;
}

we assume that all devices are bound to drivers during the call to
platform_driver_register, and if the device list is empty afterwards,
we unregister the driver and will never get to the deferred probing
stage.

	Arnd
