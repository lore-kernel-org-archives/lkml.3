Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaANRfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:35:42 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:49318 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaANRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:35:40 -0500
MIME-Version: 1.0
In-Reply-To: <52D55CE5.1060902@ti.com>
References: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org>
	<52D404DE.2020806@ti.com>
	<CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com>
	<52D55CE5.1060902@ti.com>
Date: Tue, 14 Jan 2014 09:35:38 -0800
Message-ID: <CAA3XUr2cnF_rxMYvZfjBx22Sa8YE45o_qUU8GNoerQwhWqxhNQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Tero Kristo <t-kristo@ti.com>, Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On 14 January 2014 07:51, Nishanth Menon <nm@ti.com> wrote:
> On 01/14/2014 05:14 AM, Taras Kondratiuk wrote:
>> On 13 January 2014 17:23, Nishanth Menon <nm@ti.com> wrote:
>>> On 01/13/2014 09:03 AM, Taras Kondratiuk wrote:
>>>> From: Victor Kamensky <victor.kamensky@linaro.org>
>>>>
>>>> Assembler functions defined in sleep44xx.S need to byteswap values
>>>> after read / before write from h/w register if code compiled in big
>>>> endian mode. Simple change to do 'rev x, x' before str instruction
>>>> and after ldr instruction that deals with h/w registers.
>>>>
>>>> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
>>>> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
>>>> ---
>>>> This is a part of RFC series [1].
>>>> Based on v3.13-rc8.
>>>>
>>>> [1] http://www.spinics.net/lists/linux-omap/msg99927.html
>>>>
>>>>  arch/arm/mach-omap2/sleep44xx.S |   17 +++++++++++++++++
>>>>  1 file changed, 17 insertions(+)
>>>>
>>>
>>> OMAP4 is LE, and if there is a gcc flag for the same, is'nt it cleaner
>>> to deal with it in Makefile rather than trying to make an assembly
>>> meant only for LE by force building it for BE?
>>
>> Hi Nishanth
>> I'm not sure I got your point.
>> Do you propose to build this file as LE while the rest of kernel is BE?
>>
> I dont see why I should deal with the BE macro for every code change
> we have in omap4,am335x assembly. The hardware is LE and wont change
> just coz you are building it for BE. So I dont get the rationale for
> changing the assembly here - yes, if the assembly can be maintained as
> LE only mode and the build handling be adequately handled in Makefile
> (similar to SMC handling), that would be the best.

ARM core is capable of running in LE or BE modes. Yes, OMAP
memory mapped periphery gives data in LE form. When core runs
in BE mode after reading h/w register it will byteswap it, also before
writing h/w register it byteswap it. In such way BE kernel can work
with LE periphery.

When it comes to C code that works with LE periphery, if correct
access functions are used like readl_relaxed and writel_relaxed
(vs __raw_readl and __raw_writel), the functions will take care of
the swaps. In case of asm files there is no other way than to insert
those byteswaps manually and conditionally - they will be enabled only
if kernel compiled in BE mode. The reason why it could be done only
manually is that load/store opcodes behavior changes when core
runs in BE mode (E bit set) in these case ldr/str treat memory as
big endian. So when LE periphery register is read/stored additional
byteswaps that compensate for it should be inserted.

When BE kernel is built Makefile does take of compiling code in BE
mode. I.e all proper flags like -mbig-endian and -Wl,--be8 will be set.

> is the idea of BE build meant to deal with having a single BE kernel
> build work for all platforms (including LE ones)?

Sort of. The idea here to run BE image on OMAP4 chip, with
kernel that would deals with LE periphery correctly, but ARM
core run in BE with special kernel that compiled for BE case (i.e
CONFIG_CPU_BIG_ENDIAN is set).

Thanks,
Victor

> --
> Regards,
> Nishanth Menon
