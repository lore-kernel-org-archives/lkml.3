Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab3GRQnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:43:42 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:34232 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3GRQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:43:41 -0400
Message-ID: <51E81B39.2030805@linaro.org>
Date: Thu, 18 Jul 2013 17:43:37 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
 debug is disabled
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com> <20130717151148.GM24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130717151148.GM24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 04:11 PM, Russell King - ARM Linux wrote:
> On Wed, Jul 17, 2013 at 02:25:38PM +0100, Stefano Stabellini wrote:
>> On Mon, 15 Jul 2013, Julien Grall wrote:
>>> Even if uncompress debug is disabled, some board will continue to print
>>> information during uncompress step.
>>
>> Are you talking about DEBUG_UNCOMPRESS?
>> Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
>> some board will continue to print information during the uncompress step"?
>>
>> Isn't this a bug in the platform specific code that should be fixed anyway?
> 
> Hang on, let's be clear what's going on here.
> 
> 1. The normal output from the decompressor is *not* debugging.  By that
>    I mean the "Uncompressing kernel... done" message.  That is part of
>    user output.
> 
> 2. In non-multiplatform environments, the decompressor will normally use
>    the putc/flush functions found in arch/arm/mach-*/include/mach/uncompress.h
>    to implement its output, irrespective of the DEBUG_UNCOMPRESS setting.
>    (An interesting point is that DEBUG_UNCOMPRESS really should depend on
>    MULTIPLATFORM so that this point is explicit - the option requires
>    MULTIPLATFORM to be set.)
> 
> 3. DEBUG_UNCOMPRESS allows the functions which we've implemented for LL
>    debug to be re-used for decompressor output.

When Xen will boot, it will use one UART, given by the user, to be able
to log its information. Xen will not map the UART region and the IRQ to
dom0. Of course it will not be present in the device tree either. So if
Linux tries to access to this memory region, it will crash.

When Linux will boot as dom0, it will either use an hvc console or
another UART.

In case of multi-platform environments, there is no issue because when
CONFIG_DEBUG_UNCOMPRESS is disabled.

Now, in non-multiplatform environment, the decompressor will use a
pre-defined UART. This UART may be already used by Xen and Linux will
abort at the first access.

I think, the decompressor should be able to detect if the UART exists
(I'm not sure it's possible) or disabled at compile time uncompress log.

Do you have any better ideas?

Cheers,

-- 
Julien

