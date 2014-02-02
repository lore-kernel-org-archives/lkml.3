Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaBBSlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 13:41:11 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41534 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaBBSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:41:10 -0500
Message-ID: <52EE913F.1030209@gmail.com>
Date: Sun, 02 Feb 2014 19:41:03 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>
CC: Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/23]
References: <cover.1390986082.git.moinejf@free.fr> <20140202124358.GD26684@n2100.arm.linux.org.uk> <20140202190606.6fa193ce@armhf> <20140202182349.GJ26684@n2100.arm.linux.org.uk>
In-Reply-To: <20140202182349.GJ26684@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 07:23 PM, Russell King - ARM Linux wrote:
> On Sun, Feb 02, 2014 at 07:06:06PM +0100, Jean-Francois Moine wrote:
>> - on encoder_destroy(), the function drm_i2c_encoder_destroy()
>>    unregisters the i2c client, so, with a DT, a second encoder_init()
>>    would crash.
>
> I think this is one of the down-sides of trying to bolt DT into this:
> the drm encoder slave support is not designed to cope with an i2c client
> device pre-created.
>
> In fact, I can't see how this stuff comes anywhere close to working in
> a DT setup: in such a scenario, you declare that there's a tda998x
> device in DT.  I2C parses this, and creates an i2c_client itself for
> the tda998x.
>
> When the TDA998x driver initialises, it finds this i2c client and
> binds to it, calling tda998x_probe(), which does nothing.
>
> However, the only way to attach a slave encoder to a DRM device is via
> a call to drm_i2c_encoder_init(), which unconditionally calls
> i2c_new_device().  This creates a _new_ i2c_client structure, again
> unconditionally, for the tda998x.  This must be bound by the I2C
> subsystem to a driver - hopefully the tda998x driver, which then
> calls it's encoder_init function.
>
> None of this will happen if DT has already created an i2c_client at
> the appropriate address, because DRMs i2c_new_device() will fail.

drm_i2c_encoder_init() could look at .of_node of the i2c_board_info.
If it is there, do not try to i2c_new_device as it has already been
registered by DT i2c auto-probing.

Sebastian

