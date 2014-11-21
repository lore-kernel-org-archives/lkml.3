Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaKUIbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:31:20 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45836 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbaKUIbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:31:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141121010553.GA5959@www.outflux.net>
References: <20141121010553.GA5959@www.outflux.net>
Date: Fri, 21 Nov 2014 09:31:15 +0100
Message-ID: <CA+rthh-AkVT4FmBXMiKYL8863eReYyE5g6+8wDEUiOnNevt_OQ@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: prefix module autoloading with "crypto-"
From: Mathias Krause <minipli@googlemail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 02:05, Kees Cook <keescook@chromium.org> wrote:
> This prefixes all crypto module loading with "crypto-" so we never run
> the risk of exposing module auto-loading to userspace via a crypto API,
> as demonstrated by Mathias Krause:
>
> https://lkml.org/lkml/2013/3/4/70
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> [...]

Looks good so far, but unfortunately does not solve the problem
completely (af_alg_mod from the link above):

bbox:~# cat /sbin/modlog
#!/bin/sh
exec 1>/tmp/modlog.$$
echo "CMD: $0 $*"
echo "ENV: "
env
exec /sbin/modprobe "$@"
bbox:~# echo /sbin/modlog > /proc/sys/kernel/modprobe
bbox:~# lsmod | grep fat
bbox:~# af_alg_mod 'vfat(blowfish)'
bbox:~# grep CMD /tmp/modlog.*
/tmp/modlog.257:CMD: /sbin/modlog -q -- net-pf-38
/tmp/modlog.261:CMD: /sbin/modlog -q -- algif-hash
/tmp/modlog.265:CMD: /sbin/modlog -q -- crypto-vfat(blowfish)
/tmp/modlog.268:CMD: /sbin/modlog -q -- crypto-vfat(blowfish)-all
/tmp/modlog.272:CMD: /sbin/modlog -q -- vfat
bbox:~# lsmod | grep fat
vfat                   17135  0
fat                    61984  1 vfat
bbox:~#

The last modlog call does not contain the "crypto-" prefix, therefore
happily loads the vfat module.
I guess crypto templates are handled special?

Regards,
Mathias
