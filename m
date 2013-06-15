Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3FOGg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 02:36:28 -0400
Received: from nm23-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.141]:40773
	"EHLO nm23-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab3FOGg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 02:36:27 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Jun 2013 02:36:26 EDT
X-Yahoo-Newman-Id: 332084.47206.bm@smtp104.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: V7xr7TYVM1lKfpRwdB6iNBcyF0z16U9JH7eCUkleZ8agb.F
 EfOSNpiAeAP98oIjkX4xuULLkPymypKoP__SHq9IQh2vd2_9dlpOuzHLTiuq
 rzHd_8ZQCGPRJrhjmYW81jOCbpfo9VUX3FHE2H3Q3bHlZJ3cEdYG3xCzFCLm
 pu4CLJu4chnYZHKL08bCAS7eoEqVJdNCzRNl_SV_03tDj7hTkAiPvoTzzgXc
 Np75RJgtqq9q5R_ItHP.hESZSl1GQfz27UcAsUbf6WLiozgSX5nqeZPrST8Z
 qZE3IQ_OQDm2C6JEUhUKAd8MIuIh09.pFxKwbLhiEhm3fBqA0csoMSyoIi0n
 cOzQVRNWN4Bhj63Cgk_gNE27kiXT1x6AX8loSiYe4XlrAcNjKLaPQx5A7qzp
 n25tySnpba_.WswkCDUAbBpkFxmxfChqpsgTJawCDdYPlu7b2LwBwwChD46F
 Eu0f4FB5ke1dFIhsgYnIM_GZsMNq3egczgGbGbFvGTbCuBKPO3cSgtZdpFGX
 8AWJjJV._rxdRMw--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.ne1.yahoo.com with SMTP; 15 Jun 2013 06:30:52 +0000 UTC
Date: Fri, 14 Jun 2013 23:30:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ming Lei <ming.lei@canonical.com>
Cc: nirinA raseliarison <nirina.raseliarison@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000040
Message-ID: <20130615063055.GA13766@roeck-us.net>
References: <op.wyn5vzc89ey1ta@localhost>
 <CAErSpo5nxKi+dNDRn95GtufddncnsC2VyP+NWa=QBMt0aH3AoA@mail.gmail.com>
 <20130614154325.GA30105@roeck-us.net>
 <op.wyoht9hm9ey1ta@localhost>
 <CACVXFVP5-d_1RUC+vBTLxnHZje3F1rYaJvDCgbV2-ngXfb_KNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVP5-d_1RUC+vBTLxnHZje3F1rYaJvDCgbV2-ngXfb_KNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:32:14AM +0800, Ming Lei wrote:
> On Sat, Jun 15, 2013 at 1:07 AM, nirinA raseliarison
> <nirina.raseliarison@gmail.com> wrote:
> 
> > patch applied and no longer have the bug message when i
> > reboot and wake up the ethernet controller.
> 
> I am wondering if Guenter's patch can fix the race really, but I'd like to
> see Guenter's explanation on his patch.
> 
> The race should be caused by below:
> 
> - request timeout triggered by internal timer
> 
> - user space aborts the requests before the line in _request_firmware_load()
> 
>              fw_priv->buf = NULL
> 
> which is run in timeout path
> 
> - then the abort() called from firmware_loading_store() may use a freed fw buf
> since the timeout path will free the fw buffer.
> 
> Considered clearing 'fw_priv->buf' in _request_firmware_load()() isn't protected
> by fw_lock now, so Guenter's patch can't avoid the race entirely.
> 
I agree; my patch only protects one specific path, and was based on the
observation that access to fw_priv->buf is protected elsewhwere in the code.
My suspicion was that fw_priv->buf was freed while waiting for the mutex in
firmware_loading_store().

Your patch is more comprehensive.

Guenter
