Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaDASys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:54:48 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37994 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaDASya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:54:30 -0400
Message-ID: <533B0B2B.5070402@ahsoftware.de>
Date: Tue, 01 Apr 2014 20:53:31 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Laura Abbott <lauraa@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if CONFIG_JUMP_LABEL
 is enabled
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>	<533AFF77.5030106@codeaurora.org> <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
In-Reply-To: <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.04.2014 20:36, schrieb Kees Cook:
> On Tue, Apr 1, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
>> On 4/1/2014 3:04 AM, Alexander Holler wrote:
>>> CONFIG_DEBUG_SET_MODULE_RONX sounds like a nice security feature, but
>>> things might fail late (and unexpected) if module code is set to read-only
>>> while CONFIG_JUMP_LABEL is enabled (e.g. modprobe bridge).
>
> Isn't this a ordering problem? I thought jump labels got set up once,
> and then after that, the memory could be made RO?

I basically just run into that and looked up what happened. But the 
problem appears e.g. in netfiler/core.c function nf_register_hook() 
which calls static_key_slow_inc(). So you would have to make sure 
nf_register_hook() will be called before the code is set ro. Something 
that doesn't look easy to do.

I would have to look up when that might be called, but I assume there 
are many ways to register and unregister hooks in netfilter and some of 
them might happen outside any init, probe or whatever one might set the 
code read-only afterwards. You would have to set the code rw too, before 
nf_unregister_hook() happens.

Maybe it's possible to mark some modules to not become ro at all, I 
don't know. And doing so would make them a prefered target for exploits. 
So I'm not sure if it would make sense.

Regards,

Alexander Holler
