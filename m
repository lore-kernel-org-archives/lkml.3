Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3ENQqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:46:18 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41627 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3ENQqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:46:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
Cc: Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
 <20130512143344.GC3200@sirena.org.uk>
 <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
 <20130513052135.GD6836@sirena.org.uk>
 <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local>
 <519112F9.2010102@gmail.com>
 <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local>
 <519124D3.2040403@gmail.com>
 <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
Message-ID: <20130514164611.10068.46384@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
Date: Tue, 14 May 2013 09:46:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sören Brinkmann (2013-05-13 10:58:49)
> On Mon, May 13, 2013 at 07:37:23PM +0200, Sebastian Hesselbarth wrote:
> > On 05/13/13 19:24, Sören Brinkmann wrote:
> > >On Mon, May 13, 2013 at 06:21:13PM +0200, Sebastian Hesselbarth wrote:
> > >>>Well, that driver actually exists. But that just programs a bitstream
> > >>>you give it to program. It does not know anything about the design it
> > >>>programs and cannot make any kind of decision whether the clocks should
> > >>>be userspace controlled or not.
> > >>
> > >>what Mark wants to point out is that you add fabric clocks to the Xilinx
> > >>driver instead. This way, you will have user-space controllable clocks
> > >>but only if you loaded the xilinx driver first.
> > >What "Xilinx driver", are we talking about?
> > 
> > The device config driver you mention below.
> > 
> > >>IIRC the fabric clock controller provided by Zynq _is_ always there and
> > >>accessible from ARM CPUs. You just don't have a new generic driver
> > >>allowing to poke with all clocks, but a xilinx only driver allowing you
> > >>to set the (xilinx only) fabric clocks.
> > >Right.
> > >
> > >>I've played with Zynq a while ago, did Xilinx mainline the bitfile
> > >>driver already? If not, why don't you give it a shot?
> > >The device config driver is not in mainline, AFAIK. And I think it's in
> > >rather bad shape and needs a lot of work before it is upstreamable. But
> > >this is probably the right place to put this.
> > 
> > It is, as it will only expose clocks on Zynq and that's what Mark and
> > Mike are worried about. Expose clocks to user space and you will have
> > people mess with it for sure.
> Well, even if you contain it in that driver you can still mess with
> other clocks. Just give it the "wrong" input clock references in DT and
> you are free to control them. As I said before, there is no protection
> against such misuse.

My objections are not about creating the most secure platform ever.  My
objections are about lowering the barrier of entry for folks to misuse
the clk api.  Clearly anyone that can compile a kernel and flash it to a
device can misuse anything they want.  Likewise if someone can compile a
DTB and flash it then there is another vector for misuse.

However, making an api available to any userspace application
substantially lowers the barrier to misuse.  Physical access to the
device is no longer needed in case of flashing new stuff to nand, or
emmc or whatever.  And by misuse I do not only mean people trying to
steal your credit card (I would be impressed if controlling clocks was a
part of that!), but I do not want to encourage vendors to implement crap
userspace drivers to control clocks instead of upstreaming proper Linux
device drivers.  And it is clearly possible to destroy a device with
irresponsible clock control.

While most of us agree that exposing clock controls to userspace is
useful for debugging, at this point I do not think the positive aspects
of mainlining the feature are strong enough to overcome the negative
aspects.

I'm sure implementations of this functionality will exist out-of-tree
(as pointed out by Peter), but not everything should be merged to
mainline.

Regards,
Mike

> 
> > 
> > About the shape of it, I didn't expect that to change at all. Just
> > wondering, if it still requires you to manually end it's endianess
> > mess with the bitfiles. If you go at it, consider reading the magic
> > hidden in the bitfile and swap it when it is required. But that will
> > go OT here.
> It still takes byteswapped, binary images as input, unfortunately.
> 
> > 
> > >On the other hand, currently this driver is only required for
> > >programming the FPGA from Linux, which is not required. One of the
> > >bootloaders could do this for you earlier.
> > 
> > Well, exposing clocks to user space is not required _at all_ on all
> > other platforms you can think of. So, if you have a Zynq, you can
> > always load a Zynq driver even if you are not going to use it's
> > bitfile programming capabilities but only to configure clocks.
> > 
> > If you don't want to merge both drivers, have a Zynq-only clock
> > fabric driver instead?
> That was my original intention. But due to the nature of it, it will
> always be possible to use it with other clocks too. Hence my generic
> approach.
> I actually like the idea of making it part of the device config driver.
> The downside of it is, that this driver seems a bit far from mainline.
> 
>         Sören
