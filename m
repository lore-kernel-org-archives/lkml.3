Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbbA2Boy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:44:54 -0500
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:30544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbbA2Bou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:50 -0500
Date: Wed, 28 Jan 2015 16:09:55 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: your mail
In-Reply-To: <20150121235728.GB5669@obsidianresearch.com>
Message-ID: <alpine.DEB.2.02.1501281555020.17464@linuxheads99>
References: <20150121201024.GA4548@obsidianresearch.com> <alpine.DEB.2.02.1501211520150.13480@linuxheads99> <20150121235728.GB5669@obsidianresearch.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR01CA037.prod.exchangelabs.com (25.160.23.27) To
 BY1PR0301MB1239.namprd03.prod.outlook.com (25.161.203.23)
Authentication-Results: obsidianresearch.com; dkim=none (message not signed)
 header.d=none;obsidianresearch.com; dmarc=none action=none
 header.from=opensource.altera.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY1PR0301MB1239;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1239;
X-Forefront-PRVS: 047001DADA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51704005)(110136001)(92566002)(66066001)(46102003)(47776003)(50466002)(2950100001)(33716001)(83506001)(46406003)(42186005)(87976001)(23726002)(221733001)(122386002)(86152002)(76176999)(62966003)(50986999)(53416004)(77156002)(40100003)(54356999)(86362001)(7059030)(111123002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1239;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1239;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 22:10:57.6874 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1239
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Jason Gunthorpe wrote:

> [unfutzd the cc a bit, sorry]
> 
> On Wed, Jan 21, 2015 at 04:19:17PM -0600, atull wrote:
> > > If we consider a Zynq, for instance, there are a number of clock nets
> > > that the CPU drives into the FPGA fabric. These nets are controlled by
> > > the kernel CLK framework. So, before we program the FPGA bitstream the
> > > clocks must be setup properly.
> > 
> > It's pretty normal for drivers to find out what their clocks are from
> > the DT and enable them.  
> 
> Sure, but the clocks are bitfile specific, and not related to
> programming. Some bitfiles may not require CPU clocks at all.

The bitfile specific clocks are the clocks that are turned on by the device
driver for that chunk of the bitfile.  So those clocks can be specified
the same way as clocks are specied in the DT.

> 
> > Yes the DT overlay can specify:
> >   * clock info
> >   * firmware file name if user is doing it that way
> >   * fpga manager - specific info
> >     * compatiblity string specifies what type of fpga it is
> >     * which fpga this image should go into
> >   * fpga/processor bridges to enable
> >   * driver(s) info that is dependent on the above
> 
> All sounds reasonable
> 
> > > Today in our Zynq systems we have the bootloader preconfigure
> > > everything for what we are trying to do - but that is specific to the
> > > particular FPGA we are expecting to run, and eg, I expect if we ran a
> > > kernel using the Zynq clk framework there would be problems with it
> > > mangling the configuration.
> > > 
> > > So there would have to be some kind of sequence where the DT is
> > > loaded, the zynq specific FPGA programmer does its pre setup, then the
> > > request_firmarw/fpga_program_fw loads the bitstream and another pass
> > > for a zynq specific post setup and completion handshake?
> > 
> > fpga-mgr.c has the concept that each different FPGA family will
> > likely need its own way of doing these 3 steps:
> >  * write_init (prepare fgpa for receiving configuration information)
> >  * write (write configuration info to the fpga)
> >  * write_complete (done writing, put fpga into running mode)
> > 
> > There are callbacks into the manufacturor/fpga family specific lower
> > level driver to do these things (as part of the "fpga_manager_ops"
> 
> I think the missing bit here is that there are bitfile specific things
> as well.
> 
> The functions above are fine for a generic manufacturer bitfile loader,
> ie Xilinx GPIO twiddling, Altera JTAG, Zynq DMA, etc.
> 
> But wrappered around that should be another set of functions that are
> bitfile specific.
> 
> Like Zynq-PL-boot-protocol-v1 - which deasserts a reset line and waits
> for the PL to signal back that it has completed reset.
> 
> Or jgg-boot-protocol-v1 which monitors the configuration GPIOs for a
> specific ready pattern..
> 
> Or ... 
> 
> All of those procedures depend on the bitfile to implement something.
> 
> > > The DT needs to specify not only the bitstream programming HW to use
> > > but this ancillary programming protocol. There are many ways to do
> > > a out of reset and completion handshake on Zynq, for instance.
> > 
> > Currently the lower level driver supports only one preferred method
> > of programming.  I guess we could add an enumerated DT property to
> > select programming protocol.  It would have to be manufacturor specific.
> > Alternatively it could be encoded into the compatibility string if that
> > makes sense.
> 
> From a DT perspective I'd expect it to look something like:
> 
> soc {
> 
>   // This is the 'how to program a bitstream'
>   fpga-bitstream0: zynq_pl_dma 
>   {
>      compatible = "xilinx,zynq,pl,dma";
>      regs = <..>
>   }
> 
>   fpga: ..
>   {
>      // This is 'what is in the bitstream'
>      boot-protocol = "xilinx,zynq,protocol1";
>      compatible = "jgg,fpga-foo-bar";
>      manager = @fpga-bitstream0
>      clocks = ..
>      clock-frequency = ...
> 
>      zynq_axi_gp0
>      {
>       // Settings for a CPU to FPGA AXI bridge
>        axi setting 1 = ...
>        [...]
>      }
>   }
> }

That's good.  It also needs to specify the driver(s) for the hardware that the
bitstream will instantiate.

> 
> I could also see integrating with the regulator framework as well to
> power up FPGA specific controllable power supplies.
> 
> > > And then user space would need to have control points between each of
> > > these steps.
> 
> > We could have two options, configurable from the ioctl:
> > * When the DT is loaded, do everything
> > * Even when the DT is loaded, wait for further instructions from ioctl or
> > 
> > Freewheeling flow:
> > * Tell ioctl that we are in freewheeling mode
> > * Load DT overlay
> > 
> > Tightly controlled flow:
> > * Tell ioctl that we are doing things stepwise
> > * Load DT overlay
> > * Use ioctl to step through getting the fpga loaded and known to be happy
> 
> I think you've certainly got the idea!
> 
> Thinking it through some more, if the kernel DT tells the fpga-mgr
> that it is 
> 
>   boot-protocol = "xilinx,zynq,protocol1","jgg,foo-bar";
> 
> Then the kernel should refuse to start it if it doesn't know how to do
> both 'xilinx,zynq,protocol1' and 'jgg,foo-bar'.
> 
> Thus the user space ioctl interface becomes more of how to implement a
> boot protocol helper in userspace? With the proper locking - while the
> helper is working the FPGA cannot be messed with..
> 
> Jason
> 
