Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaH1U2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:28:22 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54354 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaH1U2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <53FF5097.7090000@c-s.fr>
References: <53F31707.4040300@c-s.fr>
	<53FF5097.7090000@c-s.fr>
Date: Thu, 28 Aug 2014 22:28:19 +0200
Message-ID: <CAOY=C6HxdLOPb6y=VCB_0VrSt_Vyc95nuMN_3ZDFSqoV=mAfEw@mail.gmail.com>
Subject: Re: Linux 3.16: all my drivers on SPI bus report WARNING: at drivers/base/dd.c:286
From: Stijn Devriendt <highguy@gmail.com>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 5:53 PM, leroy christophe
<christophe.leroy@c-s.fr> wrote:
>
> I've been able to identify the origin of the issue. It happens since the below commit.
> Do you know what should be done to fix that ?
>
> Christophe
>
>

Actually, more things are wrong with what the driver is doing.
If inside spi_add_device() the call to device_add() fails, then that
code bails out without any call to spi_cleanup() and the same
memory will leak (Is this intended?).

Basically, fsl_spi_setup allocates memory using devm_kzalloc, while
device_add expects that any memory allocated via this way is only
done in the device's probe function.

The simple fix would be to do a normal allocation (revert the patch) and
add a free to the cleanup() function. Unfortunately that doesn't fix the
memleak I mentioned above.

So, some outside-the-box thinking brings me to conclude that another way
to fix this problem is to allocate the devm_kzalloc not on the device's
resource
list but on the controller's resources (it's controller state after all...).

Regards,
Stijn
