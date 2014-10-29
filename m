Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaJ2Hxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:53:50 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53337 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaJ2Hxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:53:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 10/11] irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
Date: Wed, 29 Oct 2014 08:53:38 +0100
Message-ID: <7518897.LmfE2WsusV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-10-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-10-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XoVJaEioVZjgZch+BcyEnqlGnllO/4yEHrDsKBPvFH4
 HfShp9BCKZ+6LZicRBXlX+zdFtc5dNcKT3DcFAAULnVJsjLLff
 hDaiYUWjKVfXcHYLtW7HL7oNWfs3qnenZCURVxmz7loyLtg8s7
 UEQAXbC2kisuDnUpzSYJ2zqww0u0ugB35A6Vqnjyepg8xZpUBT
 BBufzF8ChyW+Z3Gt33avd2rxCSLcDYAwe2NhHrX7Mab54ouWjZ
 VOdJ7XXQAeRAJZ4O2ohh7A67JyuVvu3xMZbESe48WqBrKEpSD2
 ZuNhv+NuqtffPZ4G9c8NVTPKNEfJebmWhL+g2MLivahYRD9+8E
 NSrQzouL3t4JJtcrhFzk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:57 Kevin Cernekee wrote:
> Most implementations of the bcm7120-l2 controller only have a single
> 32-bit enable word + 32-bit status word.  But some instances have added
> more enable/status pairs in order to support 64+ IRQs (which are all
> ORed into one parent IRQ input).  Make the following changes to allow
> the driver to support this:
> 
>  - Extend DT bindings so that multiple words can be specified for the
>    reg property, various masks, etc.
> 
>  - Add loops to the probe/handle functions to deal with each word
>    separately
> 
>  - Allocate 1 generic-chip for every 32 IRQs, so we can still use the
>    clr/set helper functions
> 
>  - Update the documentation
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

You should probably specify a 'big-endian' DT property for the driver
to check. If you have both LE and BE versions of this device, we
must make sure that we use the correct accessors.

As long as we don't need to build a kernel that supports both (if
I understand you correctly, the ARM SoCs use a LE instance of this
device, while the MIPS SoCs use a BE version) you can still decide
at compile-time which one you want, but please add the runtime check
now, so if we ever get a new combination we can handle it at runtime
with a more complex driver implementation.

If I read your code right, you have decided to use one IRQ domain
per register set, rather than one domain for all of them. I don't
know which of the two ways is better here, but it would be good if
you could explain in the patch description why you did it like this.

	Arnd
