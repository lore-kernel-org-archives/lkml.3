Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbbAQArK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:47:10 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54104 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbbAQArH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:47:07 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.140.40]
In-Reply-To: <20150116101746.GA21809@leverpostej>
References: <1421269101-51105-1-git-send-email-s-anna@ti.com>
 <1421269101-51105-2-git-send-email-s-anna@ti.com> <20150115135201.GG16217@leverpostej>
 <20150115135556.GH16217@leverpostej> <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com>
 <CAK=WgbYQ=BbinqJ5fsw2Y+FKdy=nasLsw9mX8pw6S_o3owy9-g@mail.gmail.com> <20150116101746.GA21809@leverpostej>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 17 Jan 2015 02:46:46 +0200
Message-ID: <CAK=WgbYBqPoUm9byx0du_g5ZmHdYaUVLpSPZYHoCVzNoatNKpw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] Documentation: dt: add common bindings for hwspinlock
To: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robherring2@gmail.com>, Suman Anna <s-anna@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Andersson <bjorn@kryo.se>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Fri, Jan 16, 2015 at 12:17 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> The hwlock is a basic hardware primitive that allow synchronization
>> between different processors in the system, which may be running Linux
>> as well as other operating systems, and may have no other means of
>> communication.
>>
>> The hwlock id numbers are predefined, global and static across the
>> entire system: Linux may boot well after other operating systems are
>> already running and using these hwlocks to communicate, and therefore,
>> in order to use these hardware devices, it must not enumerate them
>> differently than the rest of the system.
>
> That's not true.
>
> In order to communicate it must agree with the other users as to the
> meaning of each instance, and the protocol for use. That doesn't
> necessarily mean that Linux needs to know the numerical ID from a
> datasheet, and regardless that ID is separate from the logical ID Linux
> uses internally.

Let me describe hwspinlocks a bit more so we all get to know it better
and can then agree on a proper solution.

- What makes handling of hwspinlock ID numbers convenient is the fact
that it's not based on random datasheet numbers. In fact, hwspinlocks
is just special memory: usually datasheets just define the base
address and the size of the hwspinlock area. So any numerical ID we
use to call the locks themselves are already logical and sane, similar
to the way we handle memory (i.e. if we have 32 locks we'll always use
0..31). So hwlocks ids are very much like memory addressing, and not
irq numbers.

- Sometimes Linux will have to dynamically allocate a hwlock, and send
the ID of the allocated lock to a remote processor (which may not be
running Linux).
- Sometimes a remote processor, which may not be running Linux, will
have to dynamically allocate a hwlock, and send the ID of the
allocated lock to us (another processor running Linux)

We cannot tell in advance what kind of IPC is going to be used for
sending and receiving this hwlock ID. Some are handled by Linux
(kernel) and some by the user space. So we must be able to expose an
ID the system will understand as well as receive one.

Thanks,
Ohad.
