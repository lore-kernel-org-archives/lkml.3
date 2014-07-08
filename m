Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaGHIlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:41:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36618 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaGHIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:41:00 -0400
Message-ID: <53BBAE86.6090500@gmail.com>
Date: Tue, 08 Jul 2014 10:40:38 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Drake <drake@endlessm.com>, Tomasz Figa <t.figa@samsung.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 0/3] Deterministic UART numbering on Samsung SoCs
References: <1403781875-5425-1-git-send-email-t.figa@samsung.com>	<20140626113939.GP32514@n2100.arm.linux.org.uk>	<53AC0BCC.1010608@samsung.com> <CAD8Lp45MvDLsxehayx8uuGt3w3O0vGskiFjb1vdvtOyOv2nG2w@mail.gmail.com>
In-Reply-To: <CAD8Lp45MvDLsxehayx8uuGt3w3O0vGskiFjb1vdvtOyOv2nG2w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.2014 10:32, Daniel Drake wrote:
> Hi,
> 
> How can we move forward here?

Greg, Jiri, what do you think?

> 
> On Thu, Jun 26, 2014 at 1:02 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> - basically Samsung UART already has its own namespace (ttySAC) and the
>> order inside it is well-defined - instance ID shall be the hardware
>> instance number as specified by documentation. The ports vary in certain
>> aspects and the ID is important knowledge of the driver. The problem
>> here was broken implementation of assigning IDs based on probe order,
>> which worked only because on all Exynos platforms all ports have been
>> always registered (which we want to change now and keep unused ones
>> "disabled" in DT),
> 
> Yes, the kernel help text documents this quite well:
> 
> config SERIAL_SAMSUNG
>     tristate "Samsung SoC serial support"
>     depends on PLAT_SAMSUNG
>     select SERIAL_CORE
>     help
>       Support for the on-chip UARTs on the Samsung S3C24XX series CPUs,
>       providing /dev/ttySAC0, 1 and 2 (note, some machines may not
>       provide all of these ports, depending on how the serial port
>       pins are configured.
> 
>> - we already have a lot of userspace depending on the aforementioned
>> ttySAC namespace and proper ordering of instances there. While I believe
>> the proper solution as of today would be to go back to standard ttyS
>> namespace and make userspace use a smarter way of identifying the
>> instances (e.g. by path or id, as you suggested), I don't think this
>> will make anyone's life easier with current assumptions,
> 
> I like the sound of going to the standard ttyS notation and only
> providing ports for ones that exist, but is this userspace-visible
> naming change OK? You could argue that userspace that relies on fixed
> device paths is a bit broken, but that argument would be a bit cloudy
> given the kernel documentation for the ttySAC devices above.

I'd say such argument would be completely invalid as this is most likely
almost all of the userspace for Samsung SoCs and, in addition to this,
quite a lot of firmware which pass console=ttySACx through command line.

> 
>> - correct me if I'm wrong, but I don't think the
>> /dev/serial/by-{path,id} would be handled in kernel's console= parameter.
> 
> That's right, that problem is left to the user, but at least we'd be
> consistent with other SoCs (and open to generic solutions to that
> inconvenience).

And so the point of this series is to make this no longer be left to the
user, making hardware UART 2 always UART 2 (which is supposed to be the
current behavior, but not always due to broken implementation) which is
completely orthogonal to raised issues.

Regardless of whether we stick to ttySAC or move back to ttyS, we still
need a deterministic way to assign the ID (even for internal driver
purposes) and that's why this series adds parsing of aliases. No user
visible behavior should be changed by this series.

Best regards,
Tomasz
