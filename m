Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaBGNwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:52:24 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:32909 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBGNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:52:21 -0500
Date: Fri, 7 Feb 2014 14:53:20 +0100
From: Emil Goode <emilgoode@gmail.com>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: David Laight <David.Laight@ACULAB.COM>,
        "'Igor Gnatenko'" <i.gnatenko.brain@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ming Lei <ming.lei@canonical.com>, Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: asix: fix bad header length bug
Message-ID: <20140207135320.GA4252@lianli>
References: <1391691384-8486-1-git-send-email-emilgoode@gmail.com>
 <1391692768.2843.4.camel@X1Carbon.localdomain>
 <063D6719AE5E284EB5DD2968C1650D6D0F6B99F7@AcuExch.aculab.com>
 <20140206224121.GB5251@lianli>
 <87wqh7i7pf.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wqh7i7pf.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:38:04AM +0100, Bjørn Mork wrote:
> Emil Goode <emilgoode@gmail.com> writes:
> > On Thu, Feb 06, 2014 at 03:28:13PM +0000, David Laight wrote:
> >> From: Igor Gnatenko
> >> > On Thu, 2014-02-06 at 13:56 +0100, Emil Goode wrote:
> >> > > The AX88772B occasionally send rx packets that cross urb boundaries
> >> > > and the remaining partial packet is sent with no header.
> >> > > When the buffer with a partial packet is of less number of octets
> >> > > than the value of hard_header_len the buffer is discarded by the
> >> > > usbnet module. This is causing dropped packages and error messages
> >> > > in dmesg.
> 
> > I will do some more digging in the code, but the test of skb->len
> > against hard_header_len is done already in the completion callback
> > function passed to usb_fill_bulk_urb so it seems that buffers of less
> > than hard_header_len number of octets will be dropped regardless.
> 
> I am pretty sure you are right about this bug. And the exact same
> solution is already used by the cx82310_eth minidriver, so I don't see
> the problem.  Your fix is fine IMHO.  But you should apply it to all the
> devices using asix_rx_fixup_common(), not just the ax88772 ones.
> 
> You could maybe make this a usbnet flag instead and create a generic
> solution in usbnet, but frankly I believe the number of flags and their
> meaning have exceeded drivers authors capabilities a long time ago.  At
> least mine, which are quite limited ;-)
> 
> An example of that problem is another bloody obvious bug I noticed while
> looking at this driver: The 'struct driver_info ax88178_info' points to
> asix_rx_fixup_common without setting the FLAG_MULTI_PACKET.  This will
> result in usbnet rx_process() calling usbnet_skb_return() on skbs which
> are already consumed by the minidriver.  Not a big problem, but will
> give some odd results.  But if you allow skbs shorter than ETH_HLEN to
> slip through then it might go boom, so you should probably fix that as
> well.
> 
> 
> Bjørn

Yes I believe the patch is necessary, but maybe it would be nice with
a prettier solution rather than setting hard_header_len to 0 for all
devices with this behaviour. Perhaps it would be better to let each
driver that uses the usbnet module decide what skbs to discard?

What David describes seems to be another bug, but I don't think it is
related to this patch as I'm able to reproduce the bug without the patch
beeing applied by setting the mtu to pretty much any value other than 
1500 and using ping with a larger packet size than that mtu value.

Best regards,

Emil Goode
