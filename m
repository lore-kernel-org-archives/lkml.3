Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3LSVXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:23:51 -0500
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:43909
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139Ab3LSVXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:23:49 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(z579ehzbb2dI98dI9371Ic89bh146fI103dK154dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Thu, 19 Dec 2013 13:23:36 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 3/9] clocksource/cadence_ttc: Store timer frequency in
 driver data
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
 <1385514296-26702-4-git-send-email-soren.brinkmann@xilinx.com>
 <5cff3201-db97-4061-a686-bf79ac17d4fe@CO1EHSMHS006.ehs.local>
 <52B1B6FF.7000400@linaro.org>
 <ce29829b-3727-46ba-8c46-54273ce04745@DB8EHSMHS003.ehs.local>
 <52B21A82.7050608@linaro.org>
 <0d7ba9e5-6a62-415d-86e1-763335645406@CH1EHSMHS002.ehs.local>
 <52B35CBA.7020202@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52B35CBA.7020202@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f5bcb974-8645-48d3-b03c-f894c0bb5b7b@DB8EHSMHS014.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Dec 19, 2013 at 09:53:14PM +0100, Daniel Lezcano wrote:
> On 12/19/2013 07:32 PM, Sören Brinkmann wrote:
> >Hi Daniel,
> >
> >On Wed, Dec 18, 2013 at 10:58:26PM +0100, Daniel Lezcano wrote:
> >>On 12/18/2013 05:47 PM, Sören Brinkmann wrote:
> >>>Hi Daniel,
> >>>
> >>>On Wed, Dec 18, 2013 at 03:53:51PM +0100, Daniel Lezcano wrote:
> >>>>On 12/17/2013 08:21 PM, Sören Brinkmann wrote:
> >>>>>Hi Daniel,
> >>>>>
> >>>>>On Tue, Nov 26, 2013 at 05:04:50PM -0800, Soren Brinkmann wrote:
> >>>>>>It is not allowed to call clk_get_rate() from interrupt context. To
> >>>>>>avoid such calls the timer input frequency is stored in the driver's
> >>>>>>data struct which makes it accessible to the driver in any context.
> >>>>>>
> >>>>>>Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>>>>>Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>>>>
> >>>>>I doubt that we'll resolve all issues with this series before the
> >>>>>holidays or even the next merge window. Could you take this patch into
> >>>>>your tree for 3.14? It is not directly related to the cpufreq work and
> >>>>>fixes an actual issue that triggers a kernel WARN under some condition
> >>>>>(I missed preserving the details and the trace). That would take the
> >>>>>easy stuff out of the way and we can focus on the more controversial
> >>>>>changes.
> >>>>
> >>>>You are asking to take it for 3.14 but shouldn't it go as a 3.13 fix ?
> >>>
> >>>That's also an option. As I remember, the patch fixes a kernel WARN. The
> >>>system still seemed operational though. Up to you whether this is
> >>>considered severe enough for the 3.13 series. I'm happy either way.
> >>
> >>I was not able to reproduce the WARN with my board.
> >>
> >>Please, could you give the WARN or give the procedure to reproduce it ?
> >
> >I can't either... I thought I saw the WARN on a vanilla kernel during
> >boot (IIRC, when cpuidle started). Is there any chance the timer core
> >calls the timer's set_mode() from interrupt context?
> >Anyway, let's drop it for now. I'll make sure to record more information
> >in case it reappears.
> 
> Finally I was able to reproduce it with the highres timers disabled,
> the periodic tick system and the locks debug.
> 
> Indeed, we are in an interrupt context (IPI) and we are calling
> clk_get_rate in the the set_mode function which in turn ends up by
> getting a mutex... Even if that does not hang, it is a potential
> kernel crash so I will apply the patch with an updated changelog.

Thanks! Kind of comforting to know that the issue I tried to fix actually exists.

	Sören


