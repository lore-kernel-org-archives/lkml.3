Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3DIPBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:01:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42195 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab3DIPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:01:28 -0400
Message-ID: <1365519681.3946.4.camel@phoenix>
Subject: regulator: ab8500-ext: Strange set_mode behavior when
 info->cfg->hwreq is set
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 23:01:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see below code && comments in enable() function:

        /*
         * To satisfy both HW high power request and SW request, the regulator
         * must be on in high power.
         */
        if (info->cfg && info->cfg->hwreq)
                *regval = info->update_val_hp;


I'm not very clear about the comment and the code.

1) Does that mean the device does not allow set REGULATOR_MODE_IDLE when
info->cfg->hwreq is set?

current code looks strange because when info->cfg->hwreq is set:
set_mode() allows set REGULATOR_MODE_IDLE and get_mode() returns the status
is REGULATOR_MODE_IDLE. However, current code actually write info->update_val_hp
to the register (which means it is in REGULATOR_MODE_NORMAL mode).

If the device does not allow set REGULATOR_MODE_IDLE when info->cfg->hwreq is 
set, we probably needs to return error in set REGULATOR_MODE_IDLE case.

Or 2) Does above comment mean the device needs set to REGULATOR_MODE_NORMAL
when the regulator is switching from off to on? Which means it allows setting
the regulator to REGULATOR_MODE_IDLE if the regulator is already on.

If this is the case, we cannot call enable() in set_mode() because current code
in set_mode() will write to register only when the regulator is already on.
Calling enable() always write info->update_val_hp to the register.
Thus it should just call abx500_mask_and_set_register_interruptible() directly
to update the register.

comments?

Regards,
Axel

