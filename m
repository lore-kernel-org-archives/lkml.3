Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3EJXhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 19:37:05 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:14579
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295Ab3EJXhB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 19:37:01 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh1432I1418Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Fri, 10 May 2013 16:36:55 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Saravana Kannan <skannan@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Emilio =?utf-8?B?TMOzcGV6?= <emilio@elopez.com.ar>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <518D320C.4010707@elopez.com.ar>
 <fe9e603e-a432-4a29-a195-fd393b875a7e@TX2EHSMHS006.ehs.local>
 <518D411D.9070209@elopez.com.ar>
 <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
 <518D7C45.2090602@codeaurora.org>
 <82612ce3-3be2-46fe-925c-3aa6ca743e7d@CO1EHSMHS004.ehs.local>
 <518D81F9.1090105@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <518D81F9.1090105@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2f341b13-2a7a-44a2-b31e-7ca0afeaa962@AM1EHSMHS008.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 04:25:45PM -0700, Saravana Kannan wrote:
> On 05/10/2013 04:06 PM, Sören Brinkmann wrote:
> >On Fri, May 10, 2013 at 04:01:25PM -0700, Saravana Kannan wrote:
> >>On 05/10/2013 03:18 PM, Mike Turquette wrote:
> 
> >>>I think that Soren wants something with a stable interface that he can
> >>>use for his Zynq use case.  Regarding that, why not write an actual
> >>>device driver to do what you want to do from userspace?
> >>
> >>Exposing clock control to userspace production use is a terrible
> >>idea. A misbehaving userspace can easily kill the system. This is
> >>not so try for GPIO. So, exposing GPIOs to userspace is relatively
> >>less of a concern.
> >Well, the FPGA clocks are only used by stuff in the FPGA. They cannot
> >mess up the Linux on the A9s. I my use-case is kinda special. And people
> >request functionality to easily adjust the frequency for their FPGA
> >design in SW from Linux.
> 
> How do you talk to the FPGA? What happens if the FPGA clock gets
> turned off when the Linux is communicating with it? At the least the
> I2C or whatever bus you used to talk to it could hang. You need to
> explain more about why it's "special" before people might turn
> around to give userspace ABI for clock control.
> 
> >Nevertheless, there is no real protection from taking the driver I'm
> >proposing to control the FPGA clocks to control a clock vital to the
> >system.
> 
> If we are talking about changing the kernel to control different
> clocks, that true for any driver.
> 
> If your idea of this driver was something that will take a clock
> name and rate and change that clock's rate, then that's not a good
> design. What Mike probably meant was a FPGA specific driver that
> will only clk_get() the clocks related to the FPGA, and expose
> options to userspace. Not the actual rate or enable/disable
> capability.
How? You do this through device tree. If you give that driver a
different clock than the one it should get it might mess up. But this
does apply to all device drivers. Assume you give you ethernet driver
the wrong clock reference. When it tries to adjust the link speed it
will mess up the clock. There is no protection against this.

> For example, opening the device could cause clk_prepare_enable() and
> closing it would cause clk_disable_unprepare().
In the current state: Enable/disable is explicitly done through the 'enable'
file in sysfs.  The driver takes care of that all enable/disable is
balanced. I.e. prepare_enable is called if non-zero is written to enable
and the driver didn't enable the clock yet and similar for disable.

> You might have
> ioctls to let userspace pick one of different modes of operation
> with each corresponding to a different clock rate and other
> corresponding FPGA configuration changes, etc.
It's an FPGA and therefore fully programmable even during runtime.

> That's just a rough
> sketch. If you write such a driver, userspace can't misuse it to
> mess with other clocks or leave the FPGA clock in a bad state.
Currently, you cannot mess with the enable counts and whether the
frequency is sane or not is up to the user. Unless you have a known
design and appropriate DT bindings there is no way of knowing this
upfront, which is kinda the point of having the driver.
The first use case in my mind is just some simple bring up. Having the
clocks let some LEDs blink and now let them blink faster/slower by
changing the frequency.

	Sören


