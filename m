Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaJTW5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:57:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44563 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJTW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:57:04 -0400
Message-ID: <54459339.8010009@einserver.de>
Date: Tue, 21 Oct 2014 00:56:57 +0200
From: Andreas Ruprecht <rupran@einserver.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        "m.chehab" <m.chehab@samsung.com>, hverkuil@xs4all.nl
Subject: Re: randconfig build error with next-20141020, in drivers/media/platform/marvell-ccic/mcam-core.c
References: <CA+r1ZhgyOubWFZE+B0LnOLJNA7VVvPDDSmUjnRW7=z9cZBb0rA@mail.gmail.com>
In-Reply-To: <CA+r1ZhgyOubWFZE+B0LnOLJNA7VVvPDDSmUjnRW7=z9cZBb0rA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after a lot of staring at the configuration it seems like this boils
down to an issue within the Kconfig constraint description.

Broken down to the important bits:

- CONFIG_VIDEO_TW68 and CONFIG_VIDEO_SAA7134 *select*
CONFIG_VIDEOBUF2_DMA_SG

- Both of these options are set to "*m*" in the configuration provided,
which means that CONFIG_VIDEOBUF2_DMA_SG will also be selected as "m".
According to Documentation/kbuild/kconfig-language.txt, line 101, "m" is
set as the minimal value for CONFIG_VIDEOBUF2_DMA_SG by the selects, and
as no other options select it as "y", it stays "m".

- CONFIG_VIDEO_CAFE_CCIC is set to "*y*".
The header file at drivers/media/platform/marvell-ccic/mcam-core.h then
sets an internal preprocessor variable in line 28:

#if IS_ENABLED(CONFIG_VIDEOBUF2_DMA_SG)
#define MCAM_MODE_DMA_SG 1
#endif

The source code right around line 1299 in
drivers/media/platform/marvell-ccic/mcam-core.c, where the undefined
reference occurs, depends on MCAM_MODE_DMA_SG.

This means that CONFIG_VIDEOBUF2_DMA_SG is compiled as an LKM, thus the
reference for vb2_dma_sg_memops from mcam-core.c (which is statically
compiled) can not be resolved in the builtin.o files and vmlinux.

Unfortunately, I haven't got a solution on how to resolve that, but
maybe this summary helps someone else to come up with one.

Best regards,
  Andreas

On 20.10.2014 19:52, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `mcam_setup_vb2':
> /home/jim/linux/drivers/media/platform/marvell-ccic/mcam-core.c:1299: undefined
> reference to `vb2_dma_sg_memops'
> make: *** [vmlinux] Error 1
> 

