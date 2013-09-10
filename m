Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3IJNS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:18:26 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:62059 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3IJNSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+MGGBfmm1jwtKGP_d3EjkLdf5B_E_5RT___PVh1e=8jw@mail.gmail.com>
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
 <1378351680-14696-2-git-send-email-acourbot@nvidia.com> <5228CEDB.1090306@gmail.com>
 <CAAVeFu+MGGBfmm1jwtKGP_d3EjkLdf5B_E_5RT___PVh1e=8jw@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 10 Sep 2013 14:18:03 +0100
X-Google-Sender-Auth: DtEkXL_sfqWd_Yzu5766a8ghpvk
Message-ID: <CAHkRjk5pqKv0U+NdSf+PmXQkO7jGwKnz+9cL9XX5FOvJSjjswQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2013 07:15, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Fri, Sep 6, 2013 at 3:35 AM, Rob Herring <robherring2@gmail.com> wrote:
>> On 09/04/2013 10:27 PM, Alexandre Courbot wrote:
>>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>>> can be invoked  using a consistent SMC-based API on all supported
>>> platforms. This patch adds initial basic support for Trusted
>>> Foundations using the ARM firmware API. Current features are limited
>>> to the ability to boot secondary processors.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>>> ---
>>>  .../arm/firmware/tl,trusted-foundations.txt        | 17 +++++
>>>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>>>  arch/arm/Kconfig                                   |  2 +
>>>  arch/arm/Makefile                                  |  1 +
>>>  arch/arm/firmware/Kconfig                          | 25 +++++++
>>>  arch/arm/firmware/Makefile                         |  1 +
>>>  arch/arm/firmware/trusted_foundations.c            | 82 ++++++++++++++++++++++
>>>  arch/arm/include/asm/trusted_foundations.h         | 53 ++++++++++++++
>>>  8 files changed, 182 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>>>  create mode 100644 arch/arm/firmware/Kconfig
>>>  create mode 100644 arch/arm/firmware/Makefile
>>>  create mode 100644 arch/arm/firmware/trusted_foundations.c
>>>  create mode 100644 arch/arm/include/asm/trusted_foundations.h
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>>> new file mode 100644
>>> index 0000000..3954bbd
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>>> @@ -0,0 +1,17 @@
>>> +Trusted Foundations
>>> +
>>> +Boards that use the Trusted Foundations secure monitor can signal its
>>> +presence by declaring a node compatible with "tl,trusted-foundations"
>>> +under the root node.
>>> +
>>> +Required properties:
>>> +- compatible : "tl,trusted-foundations"
>>> +- version-major : major version number of Trusted Foundations firmware
>>> +- version-minor: minor version number of Trusted Foundations firmware
>>> +
>>> +Example:
>>> +     firmware {
>>> +             compatible = "tl,trusted-foundations";
>>> +             version-major = <2>;
>>> +             version-minor = <8>;
>>> +     };
>>
>> I'm wondering how we fit this in with PSCI bindings? Both are pieces of
>> firmware functionality and may co-exist. There's nothing incompatible
>> here, but there should be some commonality. Will future versions of
>> Trusted Foundations follow the SMC calling conventions doc? What about
>> armv8 support.
>
> I don't have any information about the future of TF unfortunately,
> excepted that it should remain backward-compatible. What is this SMC
> calling convention doc your are talking about btw? Is there a standard
> calling convention defined by ARM?

The SMC calling convention is here (it requires free registration):

http://infocenter.arm.com/help/topic/com.arm.doc.den0028a/index.html

>From the introduction:

"This document defines a common calling mechanism for use with the
Secure Monitor Call (SMC)
instruction in both the ARMv7 and ARMv8 architectures.

The SMC instruction is used to generate a synchronous exception that
is handled by Secure Monitor code running in EL3. The arguments are
passed in registers and then used to select which Secure function to
execute. These calls may then be passed on to a Trusted OS in S-EL1.

This specification aims to ease integration and reduce fragmentation
between software layers, such as Operating Systems, Hypervisors,
Trusted OS, Secure Monitor and System Firmware."


If you talk about booting secondary CPUs, there is also PSCI:

http://infocenter.arm.com/help/topic/com.arm.doc.den0022b/index.html

-- 
Catalin
