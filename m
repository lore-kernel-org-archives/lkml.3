Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaDDOR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:17:28 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:59141 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaDDOR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140404140614.GA2147@redhat.com>
References: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com>
 <20140403173701.75c1f497@north> <20140404081908.GB1448@redhat.com>
 <20140404110106.6d249615@north> <20140404140614.GA2147@redhat.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 4 Apr 2014 16:17:04 +0200
Message-ID: <CACQ1gAimN_Y8cfaZNFx0Cj1yCoLMdauc4T0vp3Pxaqh5TeXqDg@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: BUG: remove double loop on REGISTER_BUSY_COUNT
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-04 16:06 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Fri, Apr 04, 2014 at 11:01:06AM +0200, Jakub Kiciński wrote:
>> On Fri, 4 Apr 2014 10:19:09 +0200, Stanislaw Gruszka wrote:
>> > On Thu, Apr 03, 2014 at 05:37:01PM +0200, Jakub Kiciński wrote:
>> > > On Thu,  3 Apr 2014 16:12:07 +0200, Richard Genoud wrote:
>> > > > rt2x00usb_register_read_lock() calls rt2x00usb_vendor_req_buff_lock()
>> > > > that calls rt2x00usb_vendor_request() which is already looping up to
>> > > > REGISTER_BUSY_COUNT times.
>> > > >
>> > > > So this loop is not needed.
>> > >
>> > > Not true.  rt2x00usb_vendor_request() busy-waits for usb_control_msg()
>> > > to succeed, rt2x00usb_register_read_lock() busy-waits for the register
>> > > field itself to become 0.
>> >
>> > Yeah, but still we are looping REGISTER_BUSY_COUNT*REGISTER_BUSY_COUNT
>> > what seems to be far too long.
>>
>> Yes, the busy waiting itself takes roughly 1s (100*100*100us) and then
>> there are transfer times, so it might be too long indeed.  Vendor driver
>> waits only 10 * 5ms in RTUSB_VendorRequest() so
>
> We use "timeout" argument which is set to 500ms , so perhaps that
> could be the reason why Richard sees "infinite" loop i.e.
> 100*100*(500ms + 100us)
That's what I thougth at the begining, so I applied this patch, but it
was still looping on errors -EPROTO.

>> rt2x00usb_vendor_request() seems like a better place to cut down the
>> number of loops.
>>
>> Alternatively we could make rt2x00usb_regbusy_read() check the retval
>> from rt2x00usb_vendor_request() and exit early?
>
> Make sense, but I think we should review the area and make some more
> changes to fine tune the timeout of USB reg reading functions.
>
> Stanislaw
