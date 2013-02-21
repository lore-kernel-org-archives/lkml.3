Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3BUTgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:36:46 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63887 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3BUTgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:36:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=Wgbam=Y5GJQxg2DSt2yR6CdcDxjZ5k_Av_0H8+6m+scN+Yw@mail.gmail.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
	<1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
	<CAJK669bDu3SphxmEtA+h+v=btsN91t0S9Mn6ik-OKr=8gtducw@mail.gmail.com>
	<CAK=Wgba5XkK3c7qh1tYHMGEe7-Qima96uYO4E+uAPcaB8K6bmQ@mail.gmail.com>
	<CAJK669YHwR=nf2zSQR6buaA-x1JSowJfU16hkz1+N_WLL0qA+A@mail.gmail.com>
	<CAK=Wgbam=Y5GJQxg2DSt2yR6CdcDxjZ5k_Av_0H8+6m+scN+Yw@mail.gmail.com>
Date: Thu, 21 Feb 2013 20:36:42 +0100
Message-ID: <CAJK669Yr=rkmBhUNZGSQAQzC46c3v2KVewnAaEJhKT1a0Ci8Pw@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Thu, Feb 21, 2013 at 6:55 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Thu, Feb 21, 2013 at 7:28 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
>> The motivation for using vringh was to avoid copying buffers
>> when sending data from the modem to the host.
>
> I may be missing something here, but why do you need vringh for that?
>
> With rpmsg (which uses two regular vrings) both ends send huge amount
> of data without copying it - we just send the pointers across.

OK, We did carefully consider using the normal vrings, but concluded it was
not doable. I'll try to give you some of the background that I can
recall from top of my head.
(I can dig out more if you're still not convinced :)

The modem we're integrating with is a complex beast (multi mode modem
LTE, HSPA+, etc).
When a packet is received deep down in the radio stack, it allocates packet
buffers using the internal slab allocator.The packet may contain
anything from control, voice,
or IP packets. If the packet contains IP-payload it will travel to a
different asymmetric CPU that
handles the IPC towards the modem. If the packet is not a IP-packet it will be
processed internally and eventually freed.

What we have done to integrate virtio is to inject the carveout into the
the modem internal slab-allocator.

Using the reversed ring allows us to introduce zero-copy for virtio
with virtually no
impact on the radio-stack, only a small change on the modem slab allocator.
It supports dynamic size buffer allocation, and modem internal
messaging using data
allocated from the shared region. It also allows modem to manage it's
own memory,
without any dependency on host side allocators.


Thanks,
Sjur
