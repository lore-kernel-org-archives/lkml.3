Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3FKIAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:00:37 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:48745 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3FKIAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:00:35 -0400
Message-ID: <51B6D91D.3000906@gmail.com>
Date: Tue, 11 Jun 2013 10:00:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drm: encoder_slave: respect of_node on i2c encoder init
References: <1370899422-1281-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130611072433.GP22870@phenom.ffwll.local>
In-Reply-To: <20130611072433.GP22870@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 09:24, Daniel Vetter wrote:
> On Mon, Jun 10, 2013 at 11:23:42PM +0200, Sebastian Hesselbarth wrote:
>> Current DRM slave encoder API conflicts with auto-registration of i2c client
>> when using DT probed clients. To allow DRM slave encoders passed by DT, this
>> patch adds a check to drm_i2c_encoder_init for a non-NULL .of_node on
>> i2c_board_info and calls an of_i2c helper to get the i2c client device
>> instead of registering a new device.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Hm, I don't have much clue about how dt/of really works, but since of has
> this nice probing/auto-instantiation thing I think we could simplify this
> some more:
> - Create a new drm_i2c_encoder_init_of which only takes a struct
>    device_node *of_node argument instead of adap and info.
> - I think we could also drop the call to ->set_config since presumably an
>    of-enabled driver grabbed any required info already from the dt.

Daniel,

this patch is not about making DRM API DT aware but make it not _break_
on DT aware platforms. I am way out of league to rework DRM slave
encoder stuff for DT. This is the smallest non-intrusive modification
I can think of to allow i2c encoders to be passed by DT.

> I think this way we could still share encoder slaves across tons of
> platforms, only the init sequence (and specifically how they get at their

IMHO, the whole i2c encoder stuff is just wrong. Not any i2c slave
driver is even really using its probe(). Everything is packed somewhere
because it just worked.. this is at least a start.

I suggest this to get merged to at least allow to have DT slaves,
then start with improving tda998x as an example, then maybe rethink
drm_slave_encoder completely, e.g.

- generalize the concept to SPI attached encoders, "internal" encoders..
- find a way to setup .encoder_type and .connector_type correctly
- have more common of_drm_blabla helpers

> config data) would be different. That would also be extensible quite
> easily (*cough* intel platforms could setup encoder slaves from
> information out of the vbt *cough*).
>
> And ofc, a (totally broken) exemplary conversion patch for tilcdc would be
> neat ;-)

I don't have tilcdc to test so - no, I am not giving an example how to
use of_parse_phandle and assign the returned pointer to board_info's
.of_node. But it is no more than that, a single line of code.

Sebastian
