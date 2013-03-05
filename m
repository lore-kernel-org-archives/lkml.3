Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3CEOJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:09:24 -0500
Received: from canardo.mork.no ([148.122.252.1]:60689 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3CEOJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:09:22 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Fangxiaozhi \(Franko\)" <fangxiaozhi@huawei.com>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying \(Zihan\)" <zihan.xue@huawei.com>,
        "Linlei \(Lei Lin\)" <lei.lin@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Yili \(Neil\)" <neil.yi@huawei.com>,
        "Wangyuhua \(Roger\, Credit\)" <wangyuhua@huawei.com>,
        "Huqiao \(C\)" <huqiao36@huawei.com>, "balbi\@ti.com" <balbi@ti.com>,
        "mdharm-usb\@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian\@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
Organization: m
References: <87obezs888.fsf@nemi.mork.no>
	<910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
	<8738waqhx2.fsf@nemi.mork.no> <21299891.5uLjgmNaTJ@linux-5eaq.site>
Date: Tue, 05 Mar 2013 15:08:21 +0100
In-Reply-To: <21299891.5uLjgmNaTJ@linux-5eaq.site> (Oliver Neukum's message of
	"Tue, 05 Mar 2013 12:52:39 +0100")
Message-ID: <876216os6i.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oneukum@suse.de> writes:
> On Tuesday 05 March 2013 11:07:05 Bjørn Mork wrote:
>> "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> writes:
>> 
>> > ------ commit 200e0d99 and commit cd060956, only put the switch
>> > command into kernel, instead of userspace usb_modeswitch utility.
>> 
>> Yes. And that is the problem.  It was agreed years ago that this
>> functionality belongs in userspace.  Ref e.g
>> https://lkml.org/lkml/2009/12/15/332
>> https://lkml.org/lkml/2010/4/19/216
>> https://lkml.org/lkml/2012/2/28/569
>> 
>> Please note the re-occurrence of this discussion, despite the fact that
>> Matthew's message from 2009 should be quite clear.
>
> Since 2009 the facts have been changing. Basically we are encountering
> two trends
>
> 1. Power save has become more important
> 2. We are seeing devices that are switchable, yet include interfaces other
>     than communication and virtual storage, foremost real storage in the
>     form of a microSD-reader

This changed with Windows8.  You will see _less_ switchable devices in
the future.  Mode switching is now considered legacy functionality
intended for OSes released before 2012.

> Whenever we cut power to a switchable device it reverts to the power-on
> state. That involves not only the communication functionality (which we
> could live with, as it cannot handle loss of power anyway) but also other
> interfaces. In addition we need to deal with resets which may or may not
> make the device revert to power-on
>
> This is a basic problem of the design. If you want reset_resume() for power
> loss to work you need to do it in kernel space for the same reason we restore
> the configuration in kernel space before we rebind the drivers and before
> we thaw user space.
>
> However, this argues not for doing the switch simply in the storage driver
> but to switch in the core.

OK, I think I understand.  You really want us to completely ignore the
unswitched mode and just seemlessly restore the switched mode, the same
way we just silently fetch the device descriptor and restore the
configuration.

Well, that does sound interesting.  But I don't think we want the tables
hard coded in the USB core? Maybe a new userspace ABI or a new driver API?

I am not sure this is worth it though.  The "other OS" does not support
this either.  Microsoft's solution to the problem is getting rid of the
whole mode switching hell, requiring the devices to support MBIM in
their default mode.  I believe we are better off working on improving
the MBIM userspace support than trying to work around this self imposed
firmware issue.


Bjørn
