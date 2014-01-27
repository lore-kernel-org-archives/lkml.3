Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaA0Wyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:54:32 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:33026 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754545AbaA0Wy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:54:27 -0500
MIME-Version: 1.0
In-Reply-To: <5086198.ZOWZ5xuyna@wuerfel>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
	<CACoXjc=ZT9fEm_KdY4WFSoS8n5FmO+hn9LjsR4m8YZG2iBbt5A@mail.gmail.com>
	<CACoXjc=-JtpiM3m4DSA_DeOxYr3sihGGf4FSaJ2yC08rpm6ANQ@mail.gmail.com>
	<5086198.ZOWZ5xuyna@wuerfel>
Date: Mon, 27 Jan 2014 14:54:25 -0800
Message-ID: <CACoXjcnTnhWS-5yOgiHA5yVaBjdH1DVzmSsknEBJLB+CFR0EyA@mail.gmail.com>
Subject: Re: [RFC PATCH V2 1/4] pci: APM X-Gene PCIe controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, Jon Masters <jcm@redhat.com>,
        linux-doc@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 12:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 24 January 2014 13:28:22 Tanmay Inamdar wrote:
>> On Thu, Jan 16, 2014 at 5:10 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>> > On Wed, Jan 15, 2014 at 4:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> On Wednesday 15 January 2014, Tanmay Inamdar wrote:
>
>> >>
>> >>> +static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port, u32 *lanes)
>> >>> +{
>> >>> +     void *csr_base = port->csr_base;
>> >>> +     u32 val32;
>> >>> +     u64 start_time, time;
>> >>> +
>> >>> +     /*
>> >>> +      * A component enters the LTSSM Detect state within
>> >>> +      * 20ms of the end of fundamental core reset.
>> >>> +      */
>> >>> +     msleep(XGENE_LTSSM_DETECT_WAIT);
>> >>> +     port->link_up = 0;
>> >>> +     start_time = jiffies;
>> >>> +     do {
>> >>> +             val32 = readl(csr_base + PCIECORE_CTLANDSTATUS);
>> >>> +             if (val32 & LINK_UP_MASK) {
>> >>> +                     port->link_up = 1;
>> >>> +                     port->link_speed = PIPE_PHY_RATE_RD(val32);
>> >>> +                     val32 = readl(csr_base + BRIDGE_STATUS_0);
>> >>> +                     *lanes = val32 >> 26;
>> >>> +             }
>> >>> +             time = jiffies_to_msecs(jiffies - start_time);
>> >>> +     } while ((!port->link_up) || (time <= XGENE_LTSSM_L0_WAIT));
>> >>> +}
>> >>
>> >> Maybe another msleep() in the loop? It seems weird to first do an
>> >> unconditional sleep but then busy-wait for the result.
>> >
>> > ok.
>>
>> This loop can execute for maximum 4 msec. So putting msleep(1) won't
>> get us much.
>
> 4 msec is still quite a long time for a busy loop that can be spent doing
> useful work in another thread.
>

Right. If 'msleep(1)' is used, then 'checkpatch' throws a warning
saying that it can actually sleep for 20ms in some cases. I will check
if 'usleep_range' is useful here.

>> >>
>> >> Another general note: Your "compatible" strings are rather unspecific.
>> >> Do you have a version number for this IP block? I suppose that it's related
>> >> to one that has been used in other chips before, or will be used in future
>> >> chips, if it's not actually licensed from some other company.
>> >
>> > I will have to check this.
>> >
>>
>> We have decided to stick with current compatible string for now.
>
> Can you elaborate on your reasoning? Does this mean X-Gene is a one-off
> product and you won't be doing any new chips based on the same hardware
> components?

The current convention is to key upon the family name - X-Gene. Future
chips will also be a part of X-Gene family. Right now it is unclear if
there are any obvious feature additions to be done in Linux PCIe
driver. Until then same driver is expected to work as is in future
chips.

>
>         Arnd
