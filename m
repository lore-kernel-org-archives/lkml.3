Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3CELw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:52:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3CELwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:52:25 -0500
From: Oliver Neukum <oneukum@suse.de>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
Date: Tue, 05 Mar 2013 12:52:39 +0100
Message-ID: <21299891.5uLjgmNaTJ@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.8.0-rc7-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <8738waqhx2.fsf@nemi.mork.no>
References: <87obezs888.fsf@nemi.mork.no> <910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com> <8738waqhx2.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013 11:07:05 Bjørn Mork wrote:
> "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> writes:
> 
> > ------ commit 200e0d99 and commit cd060956, only put the switch
> > command into kernel, instead of userspace usb_modeswitch utility.
> 
> Yes. And that is the problem.  It was agreed years ago that this
> functionality belongs in userspace.  Ref e.g
> https://lkml.org/lkml/2009/12/15/332
> https://lkml.org/lkml/2010/4/19/216
> https://lkml.org/lkml/2012/2/28/569
> 
> Please note the re-occurrence of this discussion, despite the fact that
> Matthew's message from 2009 should be quite clear.

Since 2009 the facts have been changing. Basically we are encountering
two trends

1. Power save has become more important
2. We are seeing devices that are switchable, yet include interfaces other
    than communication and virtual storage, foremost real storage in the
    form of a microSD-reader

Whenever we cut power to a switchable device it reverts to the power-on
state. That involves not only the communication functionality (which we
could live with, as it cannot handle loss of power anyway) but also other
interfaces. In addition we need to deal with resets which may or may not
make the device revert to power-on

This is a basic problem of the design. If you want reset_resume() for power
loss to work you need to do it in kernel space for the same reason we restore
the configuration in kernel space before we rebind the drivers and before
we thaw user space.

However, this argues not for doing the switch simply in the storage driver
but to switch in the core.

	Regards
		Oliver

